'use strict';
/* App Module */
angular.module('foosball', ['foosballServices']).
    config(['$interpolateProvider', '$routeProvider',
     function ($interpolateProvider, $routeProvider) {
       $interpolateProvider.startSymbol('[[');
       $interpolateProvider.endSymbol(']]');
       $routeProvider.
        when('/',
            {templateUrl: 'static/tmpl/welcome.html',
             controller: JoinGameCtrl}).
        when('/login',
            {templateUrl: 'static/tmpl/login.html',
             controller: LoginCtrl}).
        when('/game/:gameid',
            {templateUrl: 'static/tmpl/ingame.html',
             controller: GameCtrl}).
        otherwise({redirectTo: '/'});
}]);
