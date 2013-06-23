var services = angular.module('foosballServices', ['ngResource']);

services.factory('FoosballData', function($resource){
        return $resource('data/:model/:uid', {}, {
            query: {method:'GET', params:{model: '', uid:''}, isArray:true}
})});
