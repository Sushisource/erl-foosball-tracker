function JoinGameCtrl($scope, $location, FoosballData) {
    //First detect if we need to login, and redirect if we do.
    var name = localStorage.getItem("playername");
    if(name === null)
    {
        name = "no name";
        $location.path("/login");
    }
    $scope.games = FoosballData.query({model: 'fb_game',
                                       args:'filter=inprog equals true'});
    $scope.playername = name;
};

function GameCtrl($scope, GameData) {
    $scope.data = GameData.query({id:'fb_game-1'});
}

function LoginCtrl($scope, $location) {
    $scope.hi = "hi";
    $scope.login = function() {
        localStorage.setItem("playername", $scope.uname)
        $location.path("/");
    }
}
