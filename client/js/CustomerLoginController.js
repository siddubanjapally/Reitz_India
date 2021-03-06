// Generated by CoffeeScript 1.6.3
(function() {
  (angular.module('reitz')).controller('CustomerLoginController', function($scope, $rootScope, $location, $http, userService, $cookieStore) {
    $scope.logout = function() {
      return $cookieStore.remove('id');
    };
    if ($location.path() === '/login') {
      $scope.logout();
    }
    return $scope.customerViews = function(login) {
      return $http.post("http://192.168.0.177/ReitzService/api/Account/Login", {
        UserName: login.username,
        Password: login.password
      }).success(function(data) {
        console.log(data);
        if (data.user.Roles.length === 0) {
          $scope.errorMode = true;
        }
        if (data.user.Roles[0].RoleId === '2') {
          console.log(data);
          $scope.errorMode = false;
          userService.isActive = data;
          $cookieStore.put('id', data.token);
          return $location.path('/home');
        } else if (data.user.Roles[0].RoleId === '1') {
          console.log(data);
          $scope.errorMode = false;
          userService.isActive = data;
          $cookieStore.put('id', data.token);
          return $location.path('/home');
        }
      }).error(function(status) {
        return $scope.errorMode = true;
      });
    };
  });

}).call(this);

/*
//@ sourceMappingURL=CustomerLoginController.map
*/
