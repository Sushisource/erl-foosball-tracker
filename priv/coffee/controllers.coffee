foosball = angular.module("foosball")

foosball.controller 'JoinGameCtrl',
($scope, $location, $timeout, FoosballData, Game, PlayerGame) ->
  #First detect if we need to login, and redirect if we do.
  name = localStorage.getItem("playername")

  if name is null
    name = "no name"
    $location.path "/login"
  $scope.playername = name

  update_games = () ->
    $scope.games = FoosballData.query(
      model: "fb_game"
      args: "filter=inprog equals true"
    )
  update_games()

  $scope.startjoin = (game) ->
    $scope.curgame = game
    $("#teammodal").modal("show")

  $scope.join = (team) ->
    PlayerGame.save
      team: team,
      fb_game_id: $scope.curgame.id,
      fb_player_id: localStorage.getItem("playerid")
    , ->
      # This timeout is here so that the modal has time to fade out
      $timeout ->
        $location.path("/game/#{$scope.curgame.id}")
      , 100

  $scope.newgame = () ->
    nugame = Game.save()
    update_games()
    $scope.startjoin(nugame)

foosball.controller 'GameCtrl',
($scope, $routeParams, GameData, Score) ->
  $scope.data = GameData.query(id: $routeParams.gameid)

  $scope.confirmscore = (type) ->
    #TODO: Actually use the type info, need to expand fb_score model
    nugame = Score.save
      pos: $scope.guy
      fb_game_id: $routeParams.gameid
      fb_player_id: localStorage.getItem("playerid")
    , ->
        $scope.result = nugame
    , ->
        $scope.result = "error saving score"

foosball.controller 'LoginCtrl', ($scope, $location, $http) ->
  $scope.forcename = () ->
    localStorage.setItem "playername", $scope.uname
    localStorage.setItem "playerid", $scope.uid
    $location.path "/"

  $scope.login = ->
    # send note to server
    $http(method: "POST", url: "/login", data: "loginName=" + $scope.uname
    ).success((data, status, headers, config) ->
      $scope.uid = data.player['id']
      if data.exists is true
        $scope.result = "Username already taken, try another"
        $scope.iswear = true
      else
        $scope.forcename()
    ).error (data, status, headers, config) ->
      $scope.result = "Error logging in"
