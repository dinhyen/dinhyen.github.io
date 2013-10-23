---
layout: post
title: Simple table sorting with Angular
categories:
- technology
tags:
- angularjs
status: publish
type: post
published: true
meta:
  _edit_last: '1'
  _syntaxhighlighter_encoded: '1'
---
<a href="http://plnkr.co/edit/rynrXkzGcSHeWZrSXENl" target="_blank">View in Plunkr</a>

I have a page with tabular data which I want to be able to sort without having to go back to the server. Also a nice-to-have would be the ability to filter the displayed items. Since I'm trying to learn Angular, this seems like an excellent opportunity to try it out.

In the controller, the variable items holds the data to be sorted/filtered, while filteredItems is initialized to an empty array. I also specify the initial sort field and direction.  

``` javascript
function tableSortCtl($scope, $filter) {
  $scope.items = $.parseJSON($('#json').html());
  $scope.filteredItems = [];
  $scope.sortField = "firstName";
  $scope.descending = false;
}
```

The data are inserted as a JSON string into the page inside a `script` tag.  I could have made a separate request to retrieve the data.  But since the data are already available and used elsewhere on the page, I decided to save the extra request.  The JSON string is parsed into an array of objects with the help of jQuery.

``` html
<script id="json" type="application/json">
[ { "id" : 1, "firstName" : "Alice", "lastName" : "Krige", "birthdate" : "1954-06-28", "address" : "123 Main Street", "phone" : "111-222-3333" }, { "id" : 2, "firstName" : "Bob", "lastName" : "Probert", "birthdate" : "1965-06-05", "address" : "23 Elm Street", "phone" : "359-324-1494" }, { "id" : 3, "firstName" : "Charlie", "lastName" : "Darwin", "birthdate" : "1809-02-12", "address" : "65 Finch Alley", "phone" : "782-624-6038" } ]
</script>
```

Here's an excerpt of the markup:

``` html
 <table class="table table-striped" id="tag-list" ng-show="items.length > 0">
  <thead>
    <tr>
      <th id="firstName">
        <a ng-click="sort('firstName')">First name <i class="icon-sort"></i></a>
      </th>
    </tr>
  </thead>
  <tbody>
    <tr ng-repeat="item in filteredItems | orderBy:sortField:descending">
      <td>{{item.firstName}}</td>
    </tr>
  </tbody>
</table>
```

The ng-repeat directive specifies that a new table row should be created for each item. With the parameterized orderBy filter, sorting is accomplished simply by assigning a value to the sort field and toggling the sort direction flag.  This is impressively straight-forward and elegant. The rest of the function is DOM-manipulation to display the proper sort arrow.

``` javascript
$scope.sort = function (newSortField) {
  if ($scope.sortField == newSortField)
    $scope.descending = !$scope.descending;

  $scope.sortField = newSortField;

  $('th i').each(function () {
    $(this).removeClass().addClass('icon-sort');  // reset sort icon for columns with existing icons
  });
  if ($scope.descending)
    $('#' + newSortField + ' i').removeClass().addClass('icon-caret-down');
  else
    $('#' + newSortField + ' i').removeClass().addClass('icon-caret-up');    
};
```

Here's the markup for the text filter.  A change to the value of the textbox triggers the search.

``` html
<input type="text" ng-model="query" ng-change="search()" class="input-large" placeholder="Filter" />
```

The search function simply iterates through all the fields of each item and attempts to find a simple (case-insensitive) match.  This works for numbers and strings but unfortunately not, for example, on the month name for a date field, for which we'd have to do some additional processing.

``` javascript
$scope.search = function () {
  $scope.filteredItems = $filter('filter')($scope.items, function (item) {
    for (var field in item) {
      if ($scope.match(item[field], $scope.query))
        return true;
    }
    return false;
  });
};
$scope.match = function(fieldValue, searchTerm) {
  if (!fieldValue) return false;
  if (!searchTerm) return true;
  return fieldValue.toString().toLowerCase().indexOf(searchTerm.toLowerCase()) >= 0;
};
```
