foosball = angular.module("foosball")

foosball.controller 'WelcomeCtrl',
($scope, $location, $timeout, FoosballData, Game, PlayerGame, LoginSvc) ->
  $scope.playername = LoginSvc.name()
  $scope.playerid = LoginSvc.id()

  Game.get
    limit: 5
    inprog: false
  , (games) ->
    $scope.recent_games = games.games

  update_games = () ->
    Game.get inprog: true
    , (games) ->
      $scope.games = games.games
  update_games()

  $scope.startjoin = (game) ->
    $scope.curgame = game
    PlayerGame.get
      fb_game_id: game.id
      fb_player_id: $scope.playerid
    , (pgames) ->
      if not pgames.team?
        $("#teammodal").modal("show")
      else
        $scope.join(pgames.team)

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
    Game.save
      inprog: true
    , (nugame) ->
      update_games()
      $scope.startjoin(nugame)
  # For recording an already plated game
  $scope.recordgame = () ->
    $location.path("/recgame")
  # Logout
  $scope.logout = () ->
    LoginSvc.logout()

foosball.controller 'GameCtrl',
($scope, $routeParams, Game, Score, LoginSvc) ->
  $scope.data = Game.get(id: $routeParams.gameid)
  $scope.playerid = LoginSvc.id()

  $scope.confirmscore = (type) ->
    #TODO: Actually use the type info, need to expand fb_score model
    nugame = Score.save
      pos: $scope.guy
      fb_game_id: $routeParams.gameid
      fb_player_id: $scope.playerid
    , ->
      $scope.result = "Score from #{nugame.pos} recorded"
    , ->
      $scope.result = "Error saving score"

foosball.controller 'RecGameCtrl', ($scope, $location, FoosballData, HistoricalGame) ->
  $scope.yellowPlayers = []
  $scope.blackPlayers = []
  $scope.scoreAmts = [1..8]
  $scope.players = FoosballData.query(model: "fb_player")
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
    if not $scope.yellowScore? || not $scope.blackScore?
      $scope.alert_txt = "Both teams must have a defined score"
    else
      HistoricalGame.save
        yellow_players: (p.id for p in $scope.yellowPlayers)
        black_players: (p.id for p in $scope.blackPlayers)
        yellow_score: $scope.yellowScore
        black_score: $scope.blackScore
      , ->
        $location.path("/")


foosball.controller 'LoginCtrl', ($scope, $location, $http, FoosballData, LoginSvc) ->
  $scope.players = FoosballData.query(model: "fb_player", (returned) ->
    # Set a default selection in the dropdown once we've loaded players
    $scope.selectedPlayer = returned[0]
  )

  $scope.login = ->
    LoginSvc.login($scope.selectedPlayer.name, $scope.selectedPlayer.id)

  $scope.nuplayer_login = ->
    # send note to server
    $http(method: "POST", url: "/login", data: "loginName=" + $scope.uname
    ).success((data, status, headers, config) ->
      $scope.uid = data.player['id']
      if data.exists is true
        $scope.result = "Username already taken, try another"
      else
        LoginSvc.login(data.player['name'], data.player['id'])
    ).error (data, status, headers, config) ->
      $scope.result = "Error logging in: #{data}"
