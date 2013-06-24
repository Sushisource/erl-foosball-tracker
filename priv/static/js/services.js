var services = angular.module('foosballServices', ['ngResource']);

services.factory('FoosballData', function($resource){
        return $resource('data/:model/:id?:args', {}, {
            query: {method:'GET', params:{model: '', id:'', args:''},
                    isArray:true}
        })
});
