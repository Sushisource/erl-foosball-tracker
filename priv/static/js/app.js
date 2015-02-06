'use strict';
/* App Module */
angular.module('foosball', ['foosballServices', 'ngRoute']).
    config(['$interpolateProvider', '$routeProvider',
     function ($interpolateProvider, $routeProvider) {
       $interpolateProvider.startSymbol('[[');
       $interpolateProvider.endSymbol(']]');
       $routeProvider.
        when('/',
            {templateUrl: 'static/tmpl/welcome.html',
             controller: 'WelcomeCtrl'}).
        when('/login',
            {templateUrl: 'static/tmpl/login.html',
             controller: 'LoginCtrl'}).
        when('/game/:gameid',
            {templateUrl: 'static/tmpl/ingame.html',
             controller: 'GameCtrl'}).
        when('/recgame',
            {templateUrl: 'static/tmpl/recordgame.html',
             controller: 'RecGameCtrl'}).
        when('/newplayer',
            {templateUrl: 'static/tmpl/nuplayer.html',
             controller: 'RecGameCtrl'}).
        otherwise({redirectTo: '/'});
}]);
