// Generated by CoffeeScript 1.6.3
(function() {
  (angular.module('reitz')).controller('ProjectDataController', function($scope, $route, $cookieStore, $routeParams, $location, $rootScope, projectservice) {
    $scope.state = $routeParams['state'];
    if ($cookieStore.get('id') === void 0) {
      $location.path('#/login');
    }
    return $scope.data = projectservice.data;
  });

}).call(this);

/*
//@ sourceMappingURL=ProjectDataController.map
*/
