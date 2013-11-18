---
layout: post
title: So long WordPress, hello Octopress
date: 2013-11-18 06:32
comments: true
categories: 
---
I've been using WordPress since 2011.  It works well enough, but for me there are a few drawbacks.

* It's slow. It takes time to do anything from creating a post to previewing to deploying it.  I prefer to edit text in a proper text editor, with the full array of keyboard shortcuts, so I usually end up copying and pasting anyways.  But using the UI to do everything is cumbersome.  Of course I could install a local instance of WordPress so I can preview locally.  However, I would have to deploy everything, posts and images, every time. This seems inefficient for just adding a new post.

* It's hard to backup.  I could export the WordPress content as an XML file, but this is only useful to WordPress.  For a full manual backup, I would use Control Panel to export the database, then FTP into the site and download the entire WordPress content folder as an archive.  This is time-consuming and a far cry from proper version control.

* It's hard to customize.  There are probably a dozen plugins for anything I will ever want to do.  While I could view and edit the plugin source, without an easy way to test it's effectively a blackbox.  Further, I wouldn't want to have deal with PHP just to customize a plugin.

So it's an easy to decision to put WordPress out to pasture.  I looked at Jekyll and deploying on Heroku. Jekyll seems like a good choice because it's used by GitHub, so it's more likely to be developed and less likely to go away.  I also checked out [Ruhoh](http://ruhoh.org), which is created by a Jekyll developer to address some of its shortcomings.  I really liked Ruhoh for the customizability, [Mustache](http://mustache.github.io) markup syntax and incremental page generation.  I may go back to Ruhoh at some point.  I finally settled on Octopress.  It adds a theming engine and a host of productivity enhancements to Jekyll as well as beautiful syntax highlighting.  It makes it trivially simple to deploy to GitHub Pages.

There are many good articles written about using Octopress.  The [documentation](http://octopress.org/docs), for one, is a very good place to start.  Here are just some of the issues I ran into along the way.

### Importing from WordPress

I used Jekyll's [migration tools](http://jekyllrb.com/docs/migrations), specifically `hpricot` to process a WordPress export XML file to generate posts and pages.  The process worked quite well, although as expected some manual cleanups were necessary.

### Setting up DNS

This is probably a no-brainer for many people, unfortunately I'm not among them.  Since my blog is now hosted by GitHub Pages, I had to configure my DNS to point my domain to the new IP address.  The process is quite clearly laid out in the [documentation](https://help.github.com/articles/setting-up-a-custom-domain-with-pages).  In my case, I had to create an *A record* for my top-level domain, `yentran.org`, to point to `204.232.175.78`.  I also created a CNAME record for the subdomain `www.yentran.org` as an alias which points to the same address.  I was concerned that my email address `xxx@yentran.org` would be broken.  It turns not to be the case.  Email forwarding relies on a MX record, which continues to point to my ISP's IP address.  There's also a wildcard record, which catches any unknown subdomain for which there is no matching A or CNAME record.

### Images

Previously I used NextGen gallery to manage images.  NextGen stores images in separate folders, so it's simple to copy them (rather than searching for them on my hard drive).

I now use Dropbox's Public folder to host images.  This allows me to easily manage images.  In Lightroom (or any other image organizing software), I can export the images directly to Dropbox's local sync folder and the images immediately becomes available for linking.  If I want to modify images--such as resizing them--I can work directly with the Dropbox sync folder without having to make changes to the site.

### Image gallery

I used Lightbox 2 jQuery plugin to display an image gallery.  However, it doesn't work with hotlinked images.  I decided to [roll my own](https://github.com/dinhyen/darkbox).

I wrote a small Ruby + [Thor](http://whatisthor.com) to generate the necessary markup for images based on the Dropbox folder  and append it to posts.  Thor is awesome.


### Blogging with Octopress

Everytime you add or modify a post or page, Jekyll regenerates the entire site.  This is so that it can properly update the site metadata.  However, this can take a long time, particularly if you have many posts and pages.  Octopress provides a useful optimization tool.  Type `rake isolate["blog name"]` moves all other posts except the specified post into a _stash folder, so that regeneration is significantly faster.  Once you're done, type `rake integrate` to move the other posts back; just don't forget to do this before deploying.

### Categories

Octopress doesn't provide an out-of-the-box way to display categories, but this can be easily done. I want display them as an aside (Octopress-speak for a sidebar plugin or partial).  I based mine on Octostrap3's [Category List aside](http://kaworu.github.io/octopress/blog/2013/10/03/category-list-aside).

```
<section>
  <h1>Categories</h1>
  <ul id="categories">
    &#123;% for category in site.categories %&#125;
     &#123;% capture category_url %&#125;&#123;&#123; site.category_dir &#125;&#125;/&#123;&#123; category | first | slugize | downcase | replace:' ','-' &#125;&#125;&#123;% endcapture %&#125;
      <li data-category="&#123;&#123; category | first &#125;&#125;">
        <a href="&#123;&#123; root_url | append:'/' | append:category_url &#125;&#125;">&#123;&#123; category | first &#125;&#125;</a> <em>&#123;&#123; category | last | size &#125;&#125;</em>
      </li>
    &#123;% endfor %&#125;
  </ul>
</section>
```

Each category in the `site.categories` collection is an array, the first element being the category name and the last containing the pages in the category.  Unfortunately Jekyll's Liquid markup language doesn't have a way to sort a collection of arrays.  I opted to use JavaScript. This isn't ideal, but some of Octopress's own asides use the same approach.

```javascript
<script type="text/javascript">
  $(function() {
    var categories = [];
    $('[data-category]').each(function() {
      categories.push(this);
    });
    categories.sort(function (a, b) {
      return a.attributes['data-category'].value.toLowerCase() <= b.attributes['data-category'].value.toLowerCase()
            ? -1 : 1;
    });
    $('#categories').html(categories);
  });
</script>
```

### Breadcrumbs

This would be another nice-to-have for Octopress.  There are a few solutions to display breadcrumbs using Liquid.  However, the more I work with Liquid, the less I like it.  I would much prefer Mustache.  So I again went with a JavaScript solution, which would still work if later on I happen to go with different blogging framework.

```javascript
function breadcrumbs() {
  var url_parts, $html, $li, $content, href, text, url, i;

  url = window.location.pathname;
  url_parts = $.grep(url.replace(/index\.html/, '').split(/\//), function (x) { return x.length > 0; });

  if (url_parts.length === 1) { // if at the top level
    return;
  }

  $html = $('<ol class="breadcrumbs">');
  for (i = 0; i < url_parts.length; ++i) {
    text = url_parts[i];
    href = '/' + url_parts.slice(0, i + 1).join('/');
    $content = (i < url_parts.length - 1) ? $('<a>').prop('href', href).text(text) : text;
    $('<li>').append($content).appendTo($html);
  }
  $html.insertAfter('#breadcrumbs-js');
}

$(function () {
  breadcrumbs();
});
```

Here's the CSS:

```css
.breadcrumbs {
  font-family: PT Sans, helvetica, sans-serif, arial;
  margin: 0;
  padding: 30px 15px 0 55px;
}
.breadcrumbs li {
  display: inline;
  list-style: none;
  padding-left: 15px;
}
.breadcrumbs li:not(:last-child):after {
  padding-left: 15px;
  content: "/";
}
.breadcrumbs li:first-child {
  padding-left: 0;
}
/* Octopress classic theme */
#content .breadcrumbs + div > {
  margin-top: 15px;
}
#content .breadcrumbs + div > article > header {
  padding-top: 0;
}
```

I created a partial consisting of the JavaScript and the necessary CSS, then included it in the `pages.html` layout.

```
{% render_partial _includes/custom/breadcrumbs.html %}
```

Octopress/Jekyll makes it easy to tweak and hack and do so efficiently. I only wish I'd made the switch earlier!

