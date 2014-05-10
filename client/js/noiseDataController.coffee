(angular.module 'reitz')
.controller 'noiseDataController',($scope,$route,$location,$routeParams,$rootScope,projectservice,ReitzResources,chartService)->
    $scope.state = $routeParams['state']
    if localStorage.username is undefined
      $location.path '#/login'
    $scope.data = projectservice.data

#    $scope.materialControl = () ->
#      if $location.path() is '/new/noiseData'
#        $location.path '/new/materialControl'
#      else
#        $location.path '/edit/materialControl'

    $scope.createProject = (data) ->
      chartService.postdata = $scope.data
      $rootScope.navEnable =true
      $location.path '/' + $scope.state + '/chartview'
#      if $location.path() is '/new/noiseData'
#        $location.path '/new/chartview'
#      else
#        $location.path '/edit/chartview'

