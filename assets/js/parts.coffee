angular.module "application"
.directive "myHeader", ->
    return {
      restrict: "AE"
      templateUrl: "parts/header.html"
    }

.filter "dpath", ->
  return (text)->
    return text.split("/").slice(-1)[0]
