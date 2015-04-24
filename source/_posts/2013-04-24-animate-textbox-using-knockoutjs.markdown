---
layout: post
title: Animate textbox using KnockoutJS
categories:
- technology
tags:
- knockoutjs
---
[View the live example](http://jsfiddle.net/CHMaQ/23/)

[KnockoutJS](http://knockoutjs.com) is a dynamic UI framework that can really liberate you from the tedium of low-level DOM manipulations.  Even though I've only played with it for a little while, I've become a huge fan. One of my initial attempts is to create an animated text input similar to Twitter's.

The UI is quite simple. The textbox should display a "placeholder" prompt.  When the user clicks inside the textbox, expand it and display a save button, initially disabled.  If the user types something (other than white space), enable the button.  If the textbox loses focus, shrink it to its original size, unless it contains a valid comment.

To show the placeholder prompt, I could use the HTML5 "placeholder" attribute. Unfortunately this isn't supported by all browsers (what else but IE 9 and below). So I'm using a div to wrap the textbox and display the prompt as an overlay.

The view model's isEditing boolean observable reflects whether the textbox has focus.  It's wired to the hasfocus binding on the textbox.  Additionally, clicking anywhere on the wrapper div should activate the observable, since the user should be able to focus by clicking on the overlaying prompt.

The content of the textbox is tied to the newComment observable. Per the valueUpdate binding, it is updated after a key press.  Additionally, the propertychange and input parameters allow it to be updated when the user copies and pastes with the mouse or keyboard.

To animate the textbox, I use a custom binding which is also wired to the isEditing observable. The animation should be performed only when the textbox is empty or contains only white space. When the textbox has focus, it's expanded.  When it loses focus, it's collapsed.

The button is shown when the textbox has focus. Additionally it's only enabled when the user enters non-white space text. Clicking on the button simply adds adds the new comment to the comments observable array and clears the textbox. The beauty is that KnockoutJS automatically updates the UI to reflect the change.

``` html
<span class="input-overlay" data-bind="click: isEditing">
  <div class="caption">Write something...</div>
  <textarea id="#newComment" name="newComment" cols="20" rows="2" data-bind="value: newComment, valueUpdate: ['afterkeydown','propertychange','input'], hasfocus: isEditing, animateTextbox: isEditing"></textarea>
</span>
<button data-bind="click: save, enable: hasNewComment, visible: shouldShowSave">Comment</button>
<div class="alert alert-info" data-bind="visible: comments().length == 0">No comments found</div>
<table data-bind="visible: comments().length > 0">
  <thead>
    <tr>
      <th>Date</th>
      <th>User</th>
      <th>Comment</th>
    </tr>
  </thead>
  <tbody data-bind="foreach: comments">
    <tr>
      <td data-bind="text: date"></td>
      <td data-bind="text: user"></td>
      <td data-bind="text: text"></td>
    </tr>
  </tbody>
</table>
```

``` javascript
function Comment(data) {
  this.date = ko.observable(data.date);
  this.user = ko.observable(data.user);
  this.text = ko.observable(data.text);
}

function CommentViewModel(data) {
  var self = this;
  self.comments = ko.observableArray(data);
  self.isEditing = ko.observable(false);
  self.newComment = ko.observable();
  self.hasNewComment = ko.computed(function () {
    return $.trim(self.newComment()).length > 0;
  });
  self.shouldShowSave = ko.computed(function () {
    return self.isEditing() || self.hasNewComment();
  });
  self.save = function () {
      self.comments.unshift(new Comment({ 
           date: (new Date()).toLocaleString(),
           user: 'Me',
           text: self.newComment() })
      );
      self.newComment(null);
  };
}

ko.bindingHandlers.animateTextbox = {
  init: function (element, valueAccessor) {
    ko.bindingHandlers.animateTextbox.animate(element, valueAccessor);
  },
  update: function (element, valueAccessor) {
    ko.bindingHandlers.animateTextbox.animate(element, valueAccessor);
  },
  animate: function (elem, valueAccessor) {
    var hasFocus = ko.utils.unwrapObservable(valueAccessor());
    var hasNewComment = $.trim($(elem).val()).length > 0;
    if (!hasNewComment) {
      $(elem)
          .animate({ height: hasFocus ? '100px' : '20px' }, 500)
          .closest('.input-overlay').toggleClass('off', hasFocus);
    }
  }
};

$(document).ready(function() {
  ko.applyBindings(new CommentViewModel([]));
});
```