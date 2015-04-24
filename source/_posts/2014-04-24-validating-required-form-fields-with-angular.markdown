---
layout: post
title: "Validating required form fields with Angular"
date: 2014-04-24 13:33
comments: true
categories:
- Technology
---
Two things can happen when the user fills out a form field: the entered value is incorrect or the value is missing.  With Angular validating either case is consistent and simple.  The issue is when to show the error message: as the value is being entered, after the field loses focus or after the user submits the form.  I think that for a better usability, the user should be informed that the value is incorrect while entering the value.  This way the user isn't forced to scan the form to locate the problem.  If the user makes a mistake, it's more convenient to be able to fix it while already editing the field.  And we also take full advantage of Angular's instant update.  This approach works well for validating whether a value is correct.

However validating a required field is different.  We don't know if a value is missing until the user submits the form.  So to handle both scenarios, we should be able to display an error message as the user enters a value and after the user submits the form.

Before Angular 1.3, showing an error message requires some logic based on field statuses such as invalid or dirty.  With Angular 1.3 and later, we can use the new `ngMessages` directive to show an error message only when it is present.  Take as an example the following text field:

``` html
<input type="text" name="name" required ng-maxlength="5">
```

Following is how we can display an instantaneous error message as soon as the max length is exceeded.  If this is the case, the `form.name.$error` property would have the value `"$error":{"maxlength":true}` and only the `span` for `maxlength` would be displayed.  Only one error message would be displayed at a time.  If there are multiple matches, for example `maxlength` and `pattern`, I believe the one which appears earliest would be used.

``` html
<div ng-messages="form.name.$error" class="help-block">
  <span ng-message="maxlength">max length 5</span>
</div>
```

To display an error message for missing value, unfortunately, still relies on a flag for whether the form is submitted.  This would be shown after the user submits the form.
``` html
<div ng-show="form.$submitted" ng-messages="form.name.$error" class="help-block">
  <span ng-message="required">required</span>
</div>
```

Finally, we can apply a CSS class to the container when an error condition exists; i.e., when the field contains an invalid value and either the field has been modified (dirty) or the form has been submitted.  Because the field is required, it is already invalid from the start, so the additional checks ensure that we don't apply the error styling right off the bat, which would be a disconcerting experience.  We're using Bootstrap which has a class, `.has-error`, which applies red text and border to labels, inputs and help blocks.

``` html
<div class="form-group" ng-class="{'has-error':form.name.$invalid && (form.name.$dirty || form.$submitted)}">
</div>
```

Here's the [plunk](http://plnkr.co/edit/bB8mGsX6bHMZu4SvfCA2).
