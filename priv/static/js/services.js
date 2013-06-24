var services = angular.module('foosballServices', ['ngResource']);

services.factory('FoosballData', function($resource){
        return $resource('data/:model?:args/:uid', {}, {
            query: {method:'GET', params:{model: '', uid:'', args:''},
                    isArray:true}
})});
