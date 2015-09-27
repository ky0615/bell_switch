angular.module("templates", []).run(["$templateCache", function($templateCache) {$templateCache.put("index.html","<div id=\"main\" class=\"page-header\">\n  <div class=\"row\">\n    <header id=\"header\" class=\"\">\n      <h1>発車ベルスイッチ　コントロールパネル</h1>\n    </header>\n  </div>\n  <div class=\"row\">\n    <div class=\"col-md-6\">\n      <div class=\"bs-docs-section\">\n        <h1 class=\"page-header\">再生するメロディを選択</h1>\n        <div class=\"btn-group text-center\" role=\"group\">\n          <button type=\"button\" class=\"btn btn-default\" ng-click=\"reloadBellList()\">\n            <span class=\"glyphicon glyphicon-refresh\" aria-hidden=\"true\"></span>\n            更新\n          </button>\n          <button type=\"button\" class=\"btn btn-default\" ng-click=\"bellRandomSelect()\">\n            <span class=\"glyphicon glyphicon-random\" aria-hidden=\"true\"></span>\n            ランダム選曲\n          </button>\n        </div>\n      <p>選択中のメロディ: {{nowPlayingTitle}}</p>\n      </div>\n      <div class=\"list-group\">\n        <li class=\"list-group-item bell-list\" ng-repeat=\"(key, name) in bellFiles\" ng-click=\"setBell(key)\">\n          <span class=\"glyphicon\" ng-class=\"(nowBellId == key)?\'glyphicon-play-circle\': \'glyphicon-headphones\'\" aria-hidden=\"true\"></span>\n          {{name}}\n        </li>\n      </div>\n    </div>\n    <div class=\"col-md-6\">\n      <div class=\"bs-docs-section\">\n        <h1 class=\"page-header\">操作盤</h1>\n        <button type=\"button\" class=\"btn btn-primary\" ng-click=\"clickPlayBell()\">\n        <span class=\"glyphicon glyphicon-play\" aria-hidden=\"true\"></span>\n        メロディ再生\n        </button>\n        <button type=\"button\" class=\"btn btn-primary\" ng-click=\"clickStopBell()\">\n        <span class=\"glyphicon glyphicon-stop\" aria-hidden=\"true\"></span>\n        メロディ停止\n        </button>\n      </div>\n    </div>\n  </div>\n</div>");
$templateCache.put("parts/header.html","<div class=\"navbar navbar-default navbar-fixed-top\">\n  <div class=\"container\">\n    <div class=\"navbar-header\">\n      <h3>Bell Switch</h2>\n    </div>\n  </div>\n</div>");}]);