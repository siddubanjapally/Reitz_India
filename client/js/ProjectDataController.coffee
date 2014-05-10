(angular.module 'reitz')
.controller 'ProjectDataController',($scope,$route,$routeParams,$location,$rootScope,projectservice)->
    $scope.state = $routeParams['state']
    if localStorage.username is undefined
      $location.path '#/login'
    $scope.data = projectservice.data
#    $scope.operatingPoint = () ->
#      if $location.path() is '/new/project'
#        $location.path '/new/operatingPoint'
#      else
#        $location.path '/edit/operatingPoint'




