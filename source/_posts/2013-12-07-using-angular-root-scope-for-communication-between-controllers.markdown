---
layout: post
title: "Using Angular root scope for communication between controllers"
date: 2013-12-07 13:28
comments: true
categories:
- technology
---
Angular makes it simple to create standard index and details views.  Using the ubiquitous task list as an example, I can set up routes using the `$route` service as follows:

``` javascript
$routeProvider
  .when('/tasks', { templateUrl: '_tasks.html', controller: 'TasksIndexCtrl' })
  .when('/task/:id', { templateUrl: '_task.html', controller: 'TaskDetailsCtrl' })
  .otherwise({ redirectTo: '/tasks' });
}
```

The routes definitions specify the Angular controller and HTML template to use when the user navigates to a particular path.  Here we have 2 controllers, one for the index page and one for the details page.

The index controller retrieves the task list as a JSON array via the `$http` service:
``` javascript
function ($scope, $http) {
  $http.get('tasks.json').success(
    function (data) {
      $scope.tasks = data;
    }
  );
}
```

The index view renders each task with a link which embeds the task's id.  When clicked, the link redirects to the task's details view.
{% raw %}
``` html
<a href='#/task/{{task.id}}'>{{task.name}}</a>
```
{% endraw %}

The details controller also retrieves task data as JSON via `$http`, after extracting the id value from `$routeParams`.
``` javascript
function ($scope, $http, $routeParams) {
  $http.get('task-' + $routeParams.id + '.json').success(
    function (data) {
      $scope.task = data;
    }
  );
}
```

<a href="http://embed.plnkr.co/CzbeallomRCE4HuVWtzO/preview" target="_blank">View the first version in Plunker</a>

So far it's pretty run-of-the-mill.  But let's say the task list also contains sufficient data to show each task's details (the index page simply displays fewer information due to space constraint).  There'd be no need for a separate request to pull data for the details page.  The details controller can just search in-memory, within the task list which is already retrieved.  However, since each controller has its own scope and can't access another's scope, there has to be another way to share data between controllers.

Enters the [root scope](http://docs.angularjs.org/guide/scope), which acts as the parent scope for all other scopes.  If a property can't be found in a scope, Angular searchs its parent scope and so on until it reaches the root scope (as a consequence of prototypical inheritance).  Putting the task list in the root scope would allow Angular to find it in the index controller and, because all scopes share the same root scope, also allow the details controller to access it.

Modifying the index controller to save the task list to the root scope:
``` javascript
function ($rootScope, $http) {
  $rootScope.tasks = [];
  $http.get('tasks.json').success(
    function (data) {
      $rootScope.tasks = data;
    }
  );
}
```

Instead of making an HTTP request, the details controller can search for a task by id within the root scope.  When it finds the tasks, it saves it to its own scope.  It's probably a good idea to not pollute the root scope any more than necessary.
``` javascript
function ($rootScope, $scope, $routeParams) {
  var getTask = function (id) {
    id = parseInt(id, 10);
    for (var i = 0; task = $rootScope.tasks[i]; ++i) {
      if (task.id === id) {
        return task;
      }
    }
    return task;
  };

  $scope.task = getTask($routeParams.id);
}
```

Each time the user returns to the index page, a fresh request is made to retrieve the task list.  I could optimize it further by retrieving the task list only if it has changed.  To do so, I'd need to keep track of the modification time.  Here, I'm only making the simple check to see whether the task list has already been populated.

``` javascript
function ($rootScope, $http) {
  if (typeof $rootScope.tasks === 'undefined') {
    $rootScope.tasks = [];
    $http.get('tasks.json').success(
      function (data) {
        $rootScope.tasks = data;
      }
    );
  }
}
```

<a href="http://embed.plnkr.co/BwEtA3Ftp9SJ0OJCPHyv/preview" target="_blank">View the second version in Plunker</a>