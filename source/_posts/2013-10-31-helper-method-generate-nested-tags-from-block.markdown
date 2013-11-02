---
layout: post
title: Helper method to generate nested tags from block
categories:
- technology
---  
I'm still pretty new to Ruby. Hopefully one day I'll know enough to be able to look back and slap myself on the forehead for struggling with these issues.

Right now our views generate a menu from a simple set of links:
``` erb
<%= link_to "foo", "#" %>
<%= link_to "bar", "#" %>
```

I'd like to convert them to a drop-down menu that looks like this:
``` erb
<div class="dropdown">
	<a class="dropdown-toggle" href="#"><i class="caret"></i></a>
	<ul class="dropdown-menu">
    <li><%= link_to "foo", "#" %></li> 
    <li><%= link_to "bar", "#" %></li>
  </ul>
</div>
```


I'd like to minimize the changes to the markup as much as possible.  Initially I tried using a partial:
``` erb
<!-- /shared/_dropdown.html.erb -->
<div class="dropdown">
  <a class="dropdown-toggle" data-toggle="dropdown" href="#"><i class="caret"></i></a>
  <ul class="dropdown-menu">
    <li>
      <%= yield %>
    </li>
  </ul>
</div>
```

The view would then include the partial:
``` erb
<%= render :layout => "shared/dropdown" do %>
  <%= link_to "foo", "#" %>
  <%= link_to "bar, "#" %>
<% end %>
```


However, this put both links inside a single `<li>` tag.  It looked fine with some CSS styles, but not generating the proper markup bothered me a bit.  So I tried using a helper method which should offer some more flexibility.  The helper method would be taking a block, decompose it into individual anchor tags and and wrap them in the proper markup.

I started off with:
``` ruby
def dropdown(&block)
  content = capture(&block)
end
```

The `capture` helper method captures the block and stores it in a variable that I can process. More importantly, it also works for strings within the block.  This is an important distinction between `capture` and a similar helper method, `with_output_buffer` ([source](http://blog.agile-pandas.com/2011/01/13/rails-capture-vs-with-output-buffer)). 

If the block is empty, there is nothing to do. Otherwise, I'd turn them into links.

``` ruby
(content = capture(&block)) && anchors = content.split(/\n/).reject { |a| a.empty? }
if anchors.present?
  ...
end
```

To generate the top-level div is pretty straight-forward:
``` ruby
content_tag(:div, :class => 'dropdown') do
end
```

In the view, I could just merrily include other content_tags in the block argument.  However, in a helper mehod, the content is stored inside an output buffer.  I would have to use `concat` to add it to the output buffer.
``` ruby
content_tag(:div, :class => "dropdown") do
  concat link_to(content_tag(:i, "", :class => "caret"), "#", :class => "dropdown-toggle", :data => { :toggle => "dropdown" })
end
```

Next I wanted to add a `ul` tag and pass its content inside a block. I would also have to use `concat` as before.  In my initial attempt, I tried to do the following:
``` ruby
concat content_tag(:ul, :class => 'dropdown-menu') do
...
end 
```
This resulted in a syntax error. The `content-tag` is correctly treated as the first argument to `concat`.  However because of Ruby's order of precedence, the block is intepreted as belonging to `concat`, not `content_tag` as intended.  To be able to use `concat` with the `do..end` syntax, I would have to wrap `concat`'s arguments inside parentheses:
``` ruby
concat( content_tag(:ul, :class => 'dropdown-menu') do 
end )
```
This looked quirky and not very ruby-ish.  Fortunately, it turned out that the other block syntax using curly braces has higher precedence than `do..end` ([source](http://stackoverflow.com/questions/2122380/using-do-block-vs-brackets?lq=1)).  This let me eliminate the redundant parantheses:
``` ruby
concat content_tag(:ul, :class => "dropdown-menu") { ... }
```

Finally the links were added inside `li` tags:
``` ruby
anchors.collect { |a| concat content_tag(:li, a.html_safe) }
```

Here's the full method which turned out to be quite short:
``` ruby
def dropdown(&block)
  (content = capture(&block)) && anchors = content.split(/\n/).reject { |a| a.blank? }
  if anchors.present?
    content_tag(:div, :class => "dropdown") do
      concat link_to(content_tag(:i, "", :class => "icon-caret"), "#", :class => "dropdown-toggle #{toggleClass}", :data => { :toggle => "dropdown" })
      concat content_tag(:ul, :class => "dropdown-menu") { anchors.collect { |a| concat content_tag(:li, a.html_safe) } }
    end
  end
end
```