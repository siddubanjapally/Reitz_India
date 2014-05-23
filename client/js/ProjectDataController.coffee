(angular.module 'reitz')
.controller 'ProjectDataController',($scope,$route,$cookieStore,$routeParams,$location,$rootScope,projectservice)->
    $scope.state = $routeParams['state']
    if $cookieStore.get('id') is undefined
      $location.path '#/login'
    $scope.data = projectservice.data
#    $scope.operatingPoint = () ->
#      if $location.path() is '/new/project'
#        $location.path '/new/operatingPoint'
#      else
#        $location.path '/edit/operatingPoint'




