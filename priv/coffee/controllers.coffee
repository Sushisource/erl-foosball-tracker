foosball = angular.module("foosball")

foosball.controller 'WelcomeCtrl',
($scope, $location, $timeout, FoosballData, Game, PlayerGame) ->
  #First detect if we need to login, and redirect if we do.
  name = localStorage.getItem("playername")
  id = localStorage.getItem("playerid")
  if name is null or id is null
    name = "no name"
    $location.path "/login"
  $scope.playername = name
  $scope.playerid = id

  update_games = () ->
    $scope.games = FoosballData.query(
      model: "fb_game"
      args: "filter=inprog equals true"
    )
  update_games()

  $scope.startjoin = (game) ->
    $scope.curgame = game
    PlayerGame.query
      fb_game_id: game.id
      fb_player_id: $scope.playerid
    , (pgames) ->
        $scope.join(pgames[0].team)

  $scope.join = (team) ->
    PlayerGame.save
      team: team,
      fb_game_id: $scope.curgame.id,
      fb_player_id: $scope.playerid
    , ->
      # This timeout is here so that the modal has time to fade out
      $timeout ->
        $location.path("/game/#{$scope.curgame.id}")
      , 100

  # For creating a new interactive game
  $scope.newgame = () ->
    nugame = Game.save
      inprog: true
    update_games()
    $scope.startjoin(nugame)
  # For recording an already plated game
  $scope.recordgame = () ->
    $location.path("/recgame")


foosball.controller 'GameCtrl',
($scope, $routeParams, GameData, Score) ->
  $scope.data = GameData.query(id: $routeParams.gameid)

  $scope.confirmscore = (type) ->
    #TODO: Actually use the type info, need to expand fb_score model
    nugame = Score.save
      pos: $scope.guy
      fb_game_id: $routeParams.gameid
      fb_player_id: $scope.playerid
    , ->
        $scope.result = nugame
    , ->
        $scope.result = "error saving score"

foosball.controller 'RecGameCtrl', ($scope, FoosballData) ->
  $scope.yellowPlayers = []
  $scope.blackPlayers = []
  $scope.scoreAmts = [1..8]
  $scope.players = FoosballData.query(
    model: "fb_player"
  )
  pushr = (dest) ->
    for player in $scope.availablePlayers
      if player not in $scope.yellowPlayers && player not in $scope.blackPlayers
        if dest.length < 2
          dest.push(player)
          ixp = $scope.players.indexOf(player)
          $scope.players.splice(ixp, 1)

  $scope.restore = (from, player) ->
    $scope.players.push(player)
    ixp = from.indexOf(player)
    from.splice(ixp, 1)

  $scope.move = (direction) ->
    if direction == "left"
      pushr($scope.yellowPlayers)
    else
      pushr($scope.blackPlayers)

  $scope.submit = () ->
    console.log("wee")


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
