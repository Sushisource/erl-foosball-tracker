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

function LoginCtrl($scope, $location, $http) {
    $scope.forcename = function() {
        localStorage.setItem("playername", $scope.uname)
        $location.path("/");
    }
    $scope.login = function() {
        // send note to server
        $http({method: 'POST', url: '/login', data: 'loginName=' + $scope.uname}).
            success(function(data, status, headers, config){
                var already_exists = data.response;
                if(already_exists === true) {
                    $scope.result = "Username already taken, try another";
                    $scope.iswear = true;
                } else {
                    $scope.forcename();
                }
            }).
            error(function(data, status, headers, config) {
                $scope.result = "Error logging in"
            });
    }
}
