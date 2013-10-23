---
layout: post
title: Search box using KnockoutJS
categories:
- technology
tags:
- javascript
- knockoutjs
status: publish
type: post
published: true
meta:
  _edit_last: '1'
  _syntaxhighlighter_encoded: '1'
---
[View the live example](http://jsfiddle.net/dinhyen/GaDJD)

We're gradually gravitating toward AngularJS because it's more powerful and flexible. However with AngularJS we have some issues with IE7, which unfortunately we're stuck supporting. So when I want to add some simple enhancements to the search box, I went back to KnockoutJS.  For a simple scenario such as this, KnockoutJS works great. If we had to do this using plain jQuery, we'd have to juggle keypress, focus and blur events which is just unnecessary drudgery!

The enhanced search text box should display a prompt; since the HTML5 "placeholder" property isn't supported in IE9 and below, we'll need to use JavaScript. When focused it should expand and show a cursor. It should submit when the user hits Return, but only if the user enters (or copies and pastes) 2 or more characters into the text box. When the user starts typing, it should display an icon to clear the text box.

The markup is as follows:

``` html
<form id="site-search" action="/Search" data-bind="css: { active: isActive() }, submit: submit">
  <label class="search-magnify" data-bind="click: edit"><i class="icon-search"></i></label>
  <div class="search-overlay" data-bind="click: edit, visible: !isActive()">Search site...</div>
  <input class="search-input" name="searchText" autocomplete="off" type="text" data-bind="hasfocus: editing, value: text, valueUpdate: ['afterkeydown','propertychange','input']" />
  <label class="search-reset" data-bind="click: clear, visible: hasText()"><i class="icon-remove-sign"></i></label>
</form>
```

To show the prompt, I'm using an overlay container.  It's not very elegant, but I want to avoid changing the content of the textbox. With an MVC framework like KnockoutJS, the behavioral directives are wired into the markup via the data binding syntax; you don't have to peruse a separate JavaScript file. Even if you don't know the syntax, it's almost as understandable as plain English.  So clicking the magnifying glass or the overlay puts the search box in "edit" mode; clicking on the text also activates "edit" mode by giving it focus via the hasfocus binding.  The Reset/Clear icon is visible only when there is some text. When the search box is "active", the form has a special CSS class, "active", and the overlay becomes invisible.

The valueUpdate binding ensures that KnockoutJS updates the text box's value when the user types on the keyboard or pastes with the mouse.

The stylesheet (in [SASS](http://sass-lang.com) which is easier to read) is as follows:

``` css
#site-search {
  background-color: $bodyBackground;
  border-style: solid;
  border-width: 1px;
  border-color: $filterBorderShadow $filterBorder $filterBorderHighlight $filterBorder;
  border-radius: 12px;
  color: $grayTextColor;
  margin: 3px 0 0 0;
  padding: 0;
  position: relative;
  label,
  input,
  div {
    display: inline-block;
    @include ie7-inline-block();
  }
  .search-input {
    @include border-radius(0);
    @include box-shadow(none);
    @include transition(width 0.8s);
    background-color: transparent;
    border-style: none;
    color: $grayTextColor;
    line-height: 100%;
    margin: 0;
    outline: none;
    padding: 5px 25px;
    height: 100%;
    width: 100px;
    z-index: 1;
    &amp;:focus,
    &amp;:active {
      @include box-shadow(none);
    }
  }
  .search-overlay {
    font-style: italic;
    height: 100%;
    position: absolute;
    left: 25px;
    top: 3px;
    z-index: 0;
  }
  .search-magnify,
  .search-reset {
    cursor: default;
    position: absolute;
    top: 3px;
  }
  .search-magnify {
    left: 5px;
  }
  .search-reset {
    display: none;
    right: 5px;
    &amp;:hover {
      color: $linkColor;
    }
  }
}
#site-search.active {
  background-color: $white;
  color: $textColor;
  .search-input {
    color: $textColor;
    width: 150px;
  }
  .search-reset {
    display: inline-block;
    @include ie7-inline-block();
  }
}
```

Of note is when the form has the "active" CSS class, we change the style and width of the text box and also set the CSS3 "transition" property which results a nice animation (which of course won't show up in IE9 or lower but that's ok).

Finally the model which makes everything tick is as follows:

``` javascript
function SiteSearchViewModel() {
  var self = this;
  self.editing = ko.observable(false);
  self.edit = function() {
    self.editing(true);
  };
  self.isActive = function () {
    return (self.editing() || self.hasText());
  };

  self.text = ko.observable('');
  self.clear = function () {
    self.text('');
    self.editing(true);
  };
  self.hasText = ko.computed(function () {
    return $.trim(self.text()).length > 0;
  });

  self.submit = function () {
    return $.trim(self.text()).length >= 2;
  };
}

$(document).ready(function () {
  ko.applyBindings(new SiteSearchViewModel());
});
```

The search box is defined to be "active" when the text box has focus or when it contains text. The latter condition accounts for the scenario in which the user types something then clicks away; the search box should stay expanded instead of collapsed.

The `submit()` handler ensures that the user enters at least 2 non-white space characters.
