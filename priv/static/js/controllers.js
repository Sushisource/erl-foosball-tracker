function PlayerCtrl($scope, FoosballData) {
    //$scope.nodes = FoosballData.query({model: 'player'});
};

function EciNavBarCtrl($scope) {
    $scope.navitems = [
        {name: "home", link: "#/"},
        {name: "workflows", link: "#/workflows"},
        {name: "nodes", link: "#/nodes"}];
};