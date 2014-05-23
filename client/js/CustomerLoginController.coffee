(angular.module 'reitz')
.controller 'CustomerLoginController',($scope,$rootScope,$location,$http, userService,$cookieStore)->
  $scope.logout = () ->
    $cookieStore.remove('id')
  if $location.path() is '/login'
    $scope.logout()

  $scope.customerViews = (login)->
    $http.post("http://192.168.0.177/ReitzService/api/Account/Login",
      UserName: login.username
      Password: login.password
    ).success((data) ->
      console.log data
      if data.user.Roles.length is 0
        $scope.errorMode = true
      if data.user.Roles[0].RoleId is '2'
        console.log data
        $scope.errorMode = false
        userService.isActive = data
        $cookieStore.put('id',data.token)
        $location.path '/home'
      else if data.user.Roles[0].RoleId is '1'
        console.log data
        $scope.errorMode = false
        userService.isActive = data
        $cookieStore.put('id',data.token)
        $location.path '/home'

    ).error (status) ->
      $scope.errorMode = true


#    if login.username is userService.user_admin.username && login.password is userService.user_admin.password && userService.user_admin.role is 'admin'
#      $scope.errorMode = false
#      userService.isActive = userService.user_admin
#      localStorage.username = login.username
#      $location.path '/home'
#
#    else _.filter userService.user_employer, (user)-> if user.username is login.username && user.password is login.password && user.role is 'employer'
#      $scope.errorMode = false
#      userService.isActive = user
#      localStorage.username = login.username
#      $location.path '/home'
#    else
#      $scope.errorMode = true
#      $scope.userlogin = ''



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