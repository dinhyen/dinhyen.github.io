---
layout: post
title: "Validating multiple fields with Angular"
date: 2014-07-09 16:52
comments: true
categories:
- technology
---
Angular makes it simple to validate a single form field.  Validating multiple fields requires a bit more work.  The approach that works for me is use a directive to lay out the framework, but to perform the actual validation in the parent scope.  Since the user defines the specifics of the validation, any arbitrary validation can be performed and the directive can be kept simple.

In this example, I'd like to validate that the sum of 2 text inputs equals 10.  I would specify that the validation should be performed via the `multi` directive, which also specifies the custom validation function from the parent scope.

```
<form name="form" novalidate>
  <p>
    <input type="text" name="field1" ng-model="field1" multi="validateSum" />
    <span ng-show="form.field1.$error.multi">Must add up to 10</span>
  </p>
  <p>
    <input type="text" name="field2" ng-model="field2" multi="validateSum" />
    <span ng-show="form.field2.$error.multi">Must add up to 10</span>
  </p>
</form>
```

The `validateSum` function should return true (valid) if the sum of the 2 fields equals 10, or if any of the fields is empty.

```
$scope.validateSum = function () {
  if ($scope.field1 !== null && $scope.field2 !== null) {
    return parseFloat($scope.field1) + parseFloat($scope.field2) === 10;
  } else {
    return true;
  }
};
```

The directive specifies the validation function as a value of the `multi` attribute: `multi="validateSum"`.  This isn't quite idiomatic for Angular.  The preferred alternative is probably to create an isolate scope for the directive and pass in the function via `&` or `&anotherAttribute`.  I just think providing the external function as the value of the directive's attribute is cleaner and more succinct.  However, this approach requires a bit of extra handling in the directive's postlink function:

```
 var validate = $parse(attrs.multi)(scope);
```

The `$parse` service evaluates the value of `attrs.multi`, which is the string `validateSum`, in the context of the directive's scope.  Essentially this gives us the reference to `scope.validateSum`, which is created automatically by Angular and points to the function defined in the parent scope.

In order to work properly with Angular's form validation, the directive integrates with Angular's `ngModel` directive.  This is specified with `require: 'ngModel'` in the directive definition object.  Once this is done, the model's controller is provided as a 4th parameter to the directive's postlink function.

When the user changes the value of an input, we should perform the validation.  If the validation fails, the model should be marked as invalid, which results in the form being invalid, and we can display an error message and prevent the form from being submitted.  This is as simple as calling `ngModelController.$setValidity`:

```
ngModelCtrl.$viewChangeListeners.push(function () {
  ngModelCtrl.$setValidity('multi', validate());
});
```

Calling `validate()` would invoke `scope.validateSum()` which would invoke `validateSum()` in the parent scope to perform the actual validation.  Note that validation is performed only after a change has been made, so any existing model value wouldn't be validated.

Any key can be used with `$setValidity`, in this case `multi`.  If the input is invalid, the special error object `formName.inputName.$error` would become `{ multi: true }`.  We can key on the presence of the `multi` property to manually display an error message, or use [ngMessages](https://docs.angularjs.org/api/ngMessages/directive/ngMessages).

When the user changes an input, we should validate it and related inputs, as the overall validity depends on all inputs.  Since the inputs could be anywhere in the DOM, I figured the best way to notify all inputs is to use a root scope broadcast.  Since the input which triggers the event would also handle it, it's sufficient to just triggers the event in the change handler and validate in the broadcast handler.

```
scope.$on('multi:valueChanged', function (event) {
  ngModelCtrl.$setValidity('multi', validate());
});

ngModelCtrl.$viewChangeListeners.push(function () {
  $rootScope.$broadcast('multi:valueChanged');
});
```

This is the directive in its entirety:
```
app.directive('multi', ['$parse', '$rootScope', function ($parse, $rootScope) {
  return {
    restrict: 'A',
    require: 'ngModel',
    link: function (scope, elem, attrs, ngModelCtrl) {
      var validate = $parse(attrs.multi)(scope);

      ngModelCtrl.$viewChangeListeners.push(function () {
        // ngModelCtrl.$setValidity('multi', validate());
        $rootScope.$broadcast('multi:valueChanged');
      });

      var deregisterListener = scope.$on('multi:valueChanged', function (event) {
        ngModelCtrl.$setValidity('multi', validate());
      });
      scope.$on('$destroy', deregisterListener); // optional, only required for $rootScope.$on
    }
  };
}]);
```
And there you have it.

Here's the [plunk](http://plnkr.co/edit/BHnxxKhhP0xG96MekAtr);