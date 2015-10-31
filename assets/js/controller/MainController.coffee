angular.module "application"
  .controller "MainController", ($rootScope, $scope, $http)->
    $scope.bellSetFiles = []

    $scope.bellFiles = []
    $scope.nowBellId = 0

    $scope.departureFiles = []
    $scope.nowDepartureId = 0
    $scope.autoPlayDeparture = 1

    $scope.isShowSelectBellSet = false
    $scope.isShowSelectMusic = true
    $scope.isShowSelectDeparture = true

    $scope.nowPlayingTitle = ""
    $scope.nowDeparturePlayingTitle = ""

    $scope.getBellSet = ->
      $http.get "/bell_set"
        .success (res, status)->
          $scope.bellSetFiles = res
          $scope.getStatus()

    $scope.setBellSet = (id)->
      $http.get "/bell_set/#{id}"
        .success (res, status)->
          console.log res
          $scope.getStatus()

    $scope.bellsetRandomSelect = ->
      $scope.setBellSet Math.floor Math.random() * $scope.bellSetFiles.length

    $scope.setDeparture = (key)->
      $scope.nowDepartureId = key
      $scope.nowDeparturePlayingTitle = $scope.departureFiles[key]
      $http.post "/setdepartureid", id: key
        .success (res, status)->
          $scope.getStatus()
        .error (res, status)->

    $scope.getDepartureList = ->
      $http.get "/departurelist"
        .success (res, status)->
          $scope.departureFiles = res
          $scope.getStatus()
        .error (res, status)->

    $scope.clickPlayDeparture = ->
      # TODO: implement
    $scope.clickStopDeparture = ->
      # TODO: implement
    $scope.reloadDepartureList = ->
      $scope.getDepartureList()

    $scope.departureRandomSelect = ->
      $scope.setDeparture Math.floor Math.random() * $scope.departureFiles.length

    $scope.toggleAutoPlayDeparture = (toggle)->
      if toggle is 1
        # to on
      else
        # to off


    $scope.setBell = (key)->
      $scope.nowBellId = key
      $scope.nowPlayingTitle = $scope.bellFiles[key]
      $http.post "/setbellid", id: key
        .success (res, status)->
          $scope.getStatus()
        .error (res, status)->

    $scope.getBellList = ->
      $http.get "/list"
        .success (res, status)->
          $scope.bellFiles = res
          $scope.getStatus()
        .error (res, status)->

    $scope.getNowBellId = ->
      $http.get "/status"
        .success (res, status)->
          $scope.nowBellId = res.bell_id
          $scope.nowPlayingTitle = $scope.bellFiles[$scope.nowBellId]
        .error (res, status)->

    $scope.clickPlayBell = ->
      $http.get "/start"
        .success (res, status)->
          $scope.getStatus()
        .error (res, status)->

    $scope.clickStopBell = ->
      $http.get "/stop"
        .success (res, status)->
          $scope.getStatus()
        .error (res, status)->

    $scope.reloadBellList = ->
      $scope.getBellList()
      $scope.getNowBellId()

    $scope.bellRandomSelect = ->
      $scope.setBell Math.floor Math.random() * $scope.bellFiles.length

    $scope.getStatus = ->
      $http.get "/status"
        .success (res, status)->
          console.log res
          $scope.nowBellId = res.bell_id
          $scope.nowDepartureId = res.departure_id
          $scope.nowPlayingTitle = $scope.bellFiles[res.bell_id]
          $scope.nowDeparturePlayingTitle = $scope.departureFiles[res.departure_id]

    $scope.reloadDepartureList()
    $scope.reloadBellList()
    $scope.getBellSet()

    $scope.getStatus()
    return
