function JoinGameCtrl($scope, FoosballData) {
    $scope.games = [1,2,"cat"];
};

function GameCtrl($scope, FoosballData) {
}

function EciNavBarCtrl($scope) {
    $scope.navitems = [
        {name: "home", link: "#/"},
        {name: "workflows", link: "#/workflows"},
        {name: "nodes", link: "#/nodes"}];
};