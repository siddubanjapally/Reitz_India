(angular.module 'reitz')
.controller 'createUserCtrl', ($scope,$location,$rootScope,$http,$timeout, userService) ->
    if localStorage.username is undefined
      $location.path '#/login'
    $scope.userList = userService.user_employer
    $scope.createUser = ()->
      if $scope.data.username != undefined && $scope.data.password != undefined && $scope.data.confirmPassword != undefined
        user = {
          id: _.max(userService.user_employer, (user) -> user.id ).id + 1,
          username: $scope.data.username,
          password: $scope.data.password,
          role: 'employer'
        }
        userService.user_employer.push user
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