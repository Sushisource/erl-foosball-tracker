var services = angular.module('foosballServices', ['ngResource']);

//General purpose service for just listing and querying data
services.factory('FoosballData', function($resource){
        return $resource('data/:model/:id?:args', {}, {
            query: {method:'GET', params:{model: '', id:'', args:''},
                    isArray:true}
        })
});

//Specifically for returning information about the Game page
services.factory('GameData', function($resource){
        return $resource('game/info/:id', {}, {
            query: {method:'GET', params:{id:''}}
        })
});
