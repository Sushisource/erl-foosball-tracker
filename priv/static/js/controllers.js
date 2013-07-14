// Generated by CoffeeScript 1.6.3
(function() {
  var foosball;

  foosball = angular.module("foosball");

  foosball.controller('JoinGameCtrl', function($scope, $location, FoosballData) {
    var name;
    name = localStorage.getItem("playername");
    if (name === null) {
      name = "no name";
      $location.path("/login");
    }
    $scope.games = FoosballData.query({
      model: "fb_game",
      args: "filter=inprog equals true"
    });
    return $scope.playername = name;
  });

  foosball.controller('GameCtrl', function($scope, $http, $routeParams, GameData) {
    var modal;
    modal = $("#scoremodal").modal({
      keyboard: false,
      backdrop: 'static',
      show: false
    });
    $scope.data = GameData.query({
      id: $routeParams.gameid
    });
    $scope.confirmscore = function(type) {
      var postme;
      postme = new Object();
      postme.pos = $scope.guy;
      postme.fb_game_id = $routeParams.gameid;
      postme.fb_player_id = localStorage.getItem("playerid");
      $http({
        method: "POST",
        url: "/game/score",
        data: postme
      }).success(function(data, status, headers, config) {
        return $scope.result = data;
      }).error(function(data, status, headers, config) {
        return $scope.result = "Error posting score";
      });
      return $scope.endscore();
    };
    $scope.score = function(guy) {
      if ($scope.guy === void 0) {
        $scope.guy = guy;
        return modal.modal('show');
      }
    };
    return $scope.endscore = function() {
      $scope.guy = void 0;
      return modal.modal('hide');
    };
  });

  foosball.controller('LoginCtrl', function($scope, $location, $http) {
    $scope.forcename = function() {
      localStorage.setItem("playername", $scope.uname);
      return $location.path("/");
    };
    return $scope.login = function() {
      return $http({
        method: "POST",
        url: "/login",
        data: "loginName=" + $scope.uname
      }).success(function(data, status, headers, config) {
        var already_exists;
        already_exists = data.response;
        if (already_exists === true) {
          $scope.result = "Username already taken, try another";
          return $scope.iswear = true;
        } else {
          return $scope.forcename();
        }
      }).error(function(data, status, headers, config) {
        return $scope.result = "Error logging in";
      });
    };
  });

}).call(this);

/*
//@ sourceMappingURL=controllers.map
*/
