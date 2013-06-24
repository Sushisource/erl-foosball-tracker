function JoinGameCtrl($scope, FoosballData) {
    $scope.games = FoosballData.query({model: 'fb_game', args:'inprog=true'});
};

function GameCtrl($scope, FoosballData) {
    $scope.game = FoosballData.query(
        {model: 'fb_game', id:'fb_game-1'},
        //Get the first item, since we're only concerned about one
        function(){$scope.game = $scope.game[0]}
    );
}
