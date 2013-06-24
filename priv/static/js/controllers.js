function JoinGameCtrl($scope, FoosballData) {
    $scope.games = FoosballData.query({model: 'fb_game',
                                       args:'filter=inprog equals true'});
};

function GameCtrl($scope, GameData) {
    $scope.data = GameData.query({id:'fb_game-1'});
}
