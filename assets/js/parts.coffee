angular.module "application"
.directive "myHeader", ->
    return {
      restrict: "AE"
      templateUrl: "parts/header.html"
    }
