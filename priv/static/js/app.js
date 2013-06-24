'use strict';
/* App Module */
angular.module('foosball', ['foosballServices']).
    config(['$interpolateProvider', '$routeProvider',
     function ($interpolateProvider, $routeProvider) {
       $interpolateProvider.startSymbol('[[');
       $interpolateProvider.endSymbol(']]');
       $routeProvider.
        when('/',
            {templateUrl: 'static/tmpl/index.html',
             controller: JoinGameCtrl}).
        when('/game/:gameid',
            {templateUrl: 'static/tmpl/ingame.html',
             controller: GameCtrl}).
        otherwise({redirectTo: '/'});
}]);
