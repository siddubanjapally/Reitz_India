(angular.module 'reitz')
.controller 'createUserCtrl', ($scope,$location,$rootScope,$cookieStore,$http,$timeout, userService, ReitzResources) ->
    if $cookieStore.get('id') is undefined
      $location.path '#/login'
    $scope.userList = userService.user_employer
    $scope.data ={
    role: "Employer"}
    $scope.createUser = ()->
      if $scope.data.username != undefined && $scope.data.password != undefined && $scope.data.confirmPassword != undefined
        user = {
#          id: _.max(userService.user_employer, (user) -> user.id ).id + 1,
          UserName: $scope.data.username,
          PassWord: $scope.data.password,
          confirmPassword:$scope.data.confirmPassword,
          Roles: [$scope.data.role]
        }
        console.log user
        ReitzResources.createUser.create(angular.toJson user)
#        userService.user_employer.push user
        $scope.errorMode = true
        $timeout (->
          # Loadind done here - Show message for 3 more seconds.
          $timeout (->
            $scope.errorMode = false
          ), 300
        ), 300
        $scope.data = null
      else
        console.log 'Please fill the details'

.directive "passwordVerify", ->
    require: "ngModel"
    scope:
      passwordVerify: "="

    link: (scope, element, attrs, ctrl) ->
      scope.$watch (->
        combined = undefined
        combined = scope.passwordVerify + "_" + ctrl.$viewValue  if scope.passwordVerify or ctrl.$viewValue
        combined
      ), (value) ->
        if value
          ctrl.$parsers.unshift (viewValue) ->
            origin = scope.passwordVerify
            if origin isnt viewValue
              ctrl.$setValidity "passwordVerify", false
              `undefined`
            else
              ctrl.$setValidity "passwordVerify", true
              viewValue
        return
      return