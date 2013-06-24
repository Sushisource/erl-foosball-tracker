function JoinGameCtrl($scope, FoosballData) {
    $scope.games = FoosballData.query({model: 'fb_game', args:'inprog=true'});
};

function GameCtrl($scope, FoosballData) {
}
