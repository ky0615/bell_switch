angular.module('application').directive('myHeader', function () {
  return {
    restrict: 'AE',
    templateUrl: 'parts/header.html'
  };
}).filter('dpath', function () {
  return function (text) {
    return text.split('/').slice(-1)[0];
  };
});