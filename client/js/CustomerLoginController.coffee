(angular.module 'reitz')
.controller 'CustomerLoginController',($scope,$rootScope,$location,$http, userService)->
    $scope.logout = () ->
      localStorage.removeItem('username')
    if $location.path() is '/login'
      $scope.logout()

    $scope.customerViews = (login)->
      if login.username is userService.user_admin.username && login.password is userService.user_admin.password && userService.user_admin.role is 'admin'
        $scope.errorMode = false
        userService.isActive = userService.user_admin
        localStorage.username = login.username
        $location.path '/home'

      else _.filter userService.user_employer, (user)-> if user.username is login.username && user.password is login.password && user.role is 'employer'
        $scope.errorMode = false
        userService.isActive = user
        localStorage.username = login.username
        $location.path '/home'
      else
        $scope.errorMode = true
        $scope.userlogin = ''
#      if login.username is userService.user_admin.username && login.password is userService.user_admin.password && userService.user_admin.role is 'admin'
#        userService.isActive =userService.user_admin
#        $location.path '/home'
#      else _.filter userService.user_employer, (user)-> if user.username is login.username && user.password is login.password && user.role is 'employer'
#        console.log 'employee success'
#        userService.isActive =userService.user_employer
#        $location.path '/home'
#      else
#        $scope.userlogin = ''
#        $rootScope.errorMode = true