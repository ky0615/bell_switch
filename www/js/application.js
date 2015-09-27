angular.module('application', [
  'ngRoute',
  'templates',
  'ui.bootstrap'
]).config([
  '$routeProvider',
  '$locationProvider',
  function ($routeProvider, $locationProvider) {
    $locationProvider.html5Mode(true);
    $routeProvider.when('/', {
      templateUrl: 'index.html',
      controller: 'IndexController'
    }).otherwise({
      templateUrl: 'error.html',
      controller: 'ErrorController'
    });
  }
]);