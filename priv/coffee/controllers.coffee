foosball = angular.module("foosball")

foosball.controller 'JoinGameCtrl', ($scope, $location, $http, $timeout, FoosballData) ->
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

  $scope.startjoin = (game) ->
    $scope.curgame = game

  $scope.join = (team) ->
    postme = new Object()
    postme.fb_game_id = $scope.curgame.id
    postme.team = team
    postme.fb_player_id = localStorage.getItem("playerid")
    $http.post("/game/joingame", postme
    ).success((data, status, headers, config) ->
      # We've got this little timeout here so the modal fade doesn't get stuck
      $timeout ->
        $location.path("/game/#{$scope.curgame.id}")
      , 100
    ).error (data, status, headers, config) ->
      $scope.result = "Error joining game"


foosball.controller 'GameCtrl', ($scope, $http, $routeParams, GameData) ->
  $scope.data = GameData.query(id: $routeParams.gameid)

  $scope.confirmscore = (type) ->
    #TODO: Actually use the type info, need to expand fb_score model
    postme = new Object()
    postme.pos = $scope.guy
    postme.fb_game_id = $routeParams.gameid
    postme.fb_player_id = localStorage.getItem("playerid")
    $http(method: "POST", url: "/game/score", data: postme
    ).success((data, status, headers, config) ->
      $scope.result = data
    ).error (data, status, headers, config) ->
      $scope.result = "Error posting score"
    $scope.endscore()

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
