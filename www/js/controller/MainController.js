angular.module('application').controller('MainController', [
  '$rootScope',
  '$scope',
  '$http',
  function ($rootScope, $scope, $http) {
    $scope.bellFiles = [];
    $scope.nowBellId = 0;
    $scope.nowPlayingTitle = '';
    $scope.setBell = function (key) {
      $scope.nowBellId = key;
      $scope.nowPlayingTitle = $scope.bellFiles[key];
      return $http.post('/setbellid', { id: key }).success(function (res, status) {
        return console.log(res);
      }).error(function (res, status) {
      });
    };
    $scope.getBellList = function () {
      return $http.get('/list').success(function (res, status) {
        return $scope.bellFiles = res;
      }).error(function (res, status) {
      });
    };
    $scope.getNowBellId = function () {
      return $http.get('/status').success(function (res, status) {
        $scope.nowBellId = res.bell_id;
        return $scope.nowPlayingTitle = $scope.bellFiles[$scope.nowBellId];
      }).error(function (res, status) {
      });
    };
    $scope.clickPlayBell = function () {
      return $http.get('/start').success(function (res, status) {
        return console.log(res);
      }).error(function (res, status) {
      });
    };
    $scope.clickStopBell = function () {
      return $http.get('/stop').success(function (res, status) {
        return console.log(res);
      }).error(function (res, status) {
      });
    };
    $scope.reloadBellList = function () {
      $scope.getBellList();
      return $scope.getNowBellId();
    };
    $scope.bellRandomSelect = function () {
      return $scope.setBell(Math.floor(Math.random() * $scope.bellFiles.length));
    };
    return $scope.reloadBellList();
  }
]);