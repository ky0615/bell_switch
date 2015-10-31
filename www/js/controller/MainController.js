angular.module('application').controller('MainController', [
  '$rootScope',
  '$scope',
  '$http',
  function ($rootScope, $scope, $http) {
    $scope.bellFiles = [];
    $scope.nowBellId = 0;
    $scope.departureFiles = [];
    $scope.nowDepartureId = 0;
    $scope.autoPlayDeparture = 1;
    $scope.isShowSelectMusic = true;
    $scope.isShowSelectDeparture = false;
    $scope.nowPlayingTitle = '';
    $scope.nowDeparturePlayingTitle = '';
    $scope.setDeparture = function (key) {
      $scope.nowDepartureId = key;
      $scope.nowDeparturePlayingTitle = $scope.departureFiles[key];
      return $http.post('/setdepartureid', { id: key }).success(function (res, status) {
        return console.log(res);
      }).error(function (res, status) {
      });
    };
    $scope.getDepartureList = function () {
      return $http.get('/departurelist').success(function (res, status) {
        return $scope.departureFiles = res;
      }).error(function (res, status) {
      });
    };
    $scope.clickPlayDeparture = function () {
    };
    $scope.clickStopDeparture = function () {
    };
    $scope.reloadDepartureList = function () {
      return $scope.getDepartureList();
    };
    $scope.departureRandomSelect = function () {
      return $scope.setDeparture(Math.floor(Math.random() * $scope.departureFiles.length));
    };
    $scope.toggleAutoPlayDeparture = function (toggle) {
      if (toggle === 1) {
      } else {
      }
    };
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
    $scope.getStatus = function () {
      return $http.get('/status').success(function (res, status) {
        console.log(res);
        $scope.nowBellId = res.bell_id;
        $scope.nowDepartureId = res.departure_id;
        $scope.nowPlayingTitle = $scope.bellFiles[res.bell_id];
        return $scope.nowDeparturePlayingTitle = $scope.departureFiles[res.departure_id];
      });
    };
    $scope.reloadDepartureList();
    $scope.reloadBellList();
    setInterval($scope.getStatus, 1000);
  }
]);