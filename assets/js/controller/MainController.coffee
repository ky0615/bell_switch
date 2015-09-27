angular.module "application"
  .controller "MainController", ($rootScope, $scope, $http)->
    $scope.bellFiles = []
    $scope.nowBellId = 0

    $scope.setBell = (key)->
      $scope.nowBellId = key
      $http.post "/setbellid", id: key
        .success (res, status)->
          console.log res
        .error (res, status)->

    $scope.getBellList = ->
      $http.get "/list"
        .success (res, status)->
          $scope.bellFiles = res
        .error (res, status)->

    $scope.getNowBellId = ->
      $http.get "/status"
        .success (res, status)->
          $scope.nowBellId = res.bell_id
        .error (res, status)->

    $scope.clickPlayBell = ->
      $http.get "/start"
        .success (res, status)->
          console.log res
        .error (res, status)->

    $scope.clickStopBell = ->
      $http.get "/stop"
        .success (res, status)->
          console.log res
        .error (res, status)->

    $scope.reloadBellList = ->
      $scope.getBellList()
      $scope.getNowBellId()

    $scope.bellRandomSelect = ->
      $scope.setBell Math.floor Math.random() * $scope.bellFiles.length

    $scope.reloadBellList()
