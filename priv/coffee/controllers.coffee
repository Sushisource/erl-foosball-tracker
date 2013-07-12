foosball = angular.module("foosball")

foosball.controller 'JoinGameCtrl', ($scope, $location, FoosballData) ->
  #First detect if we need to login, and redirect if we do.
  name = localStorage.getItem("playername")

  if name is null
    name = "no name"
    $location.path "/login"

  $scope.games = FoosballData.query(
    model: "fb_game"
    args: "filter=inprog equals true"
  )
  $scope.playername = name

foosball.controller 'GameCtrl', ($scope, $http, $routeParams, GameData) ->
  $scope.data = GameData.query(id: $routeParams.gameid)

  $scope.score = (guy) ->
    postme = new Object()
    postme.pos = guy
    postme.fb_game_id = $routeParams.gameid
    postme.fb_player_id = localStorage.getItem("playerid")
    $http(method: "POST", url: "/game/score", data: postme
    ).success((data, status, headers, config) ->
      $scope.result = data
    ).error (data, status, headers, config) ->
      $scope.result = "Error posting score"

foosball.controller 'LoginCtrl', ($scope, $location, $http) ->
  $scope.forcename = ->
    localStorage.setItem "playername", $scope.uname
    $location.path "/"

  $scope.login = ->
    # send note to server
    $http(method: "POST", url: "/login", data: "loginName=" + $scope.uname
    ).success((data, status, headers, config) ->
      already_exists = data.response
      if already_exists is true
        $scope.result = "Username already taken, try another"
        $scope.iswear = true
      else
        $scope.forcename()
    ).error (data, status, headers, config) ->
      $scope.result = "Error logging in"
