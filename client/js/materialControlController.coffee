(angular.module 'reitz')
.controller 'materialControlController',($scope,$route,$cookieStore,$location,$routeParams,$rootScope,projectservice,ReitzResources,chartService)->
    $scope.state = $routeParams['state']
    if $cookieStore.get('id') is undefined
      $location.path '#/login'
    $scope.data = projectservice.data

    $scope.$watch 'data.MaterialDriveControls.MechanicalDesignTemperature > 350',( (value)->
      if value then $scope.data.MaterialDriveControls.StandardImpellerMaterial = false else $scope.data.MaterialDriveControls.StandardImpellerMaterial = true
    ),true
    $scope.$watch 'data.MaterialDriveControls.Drive ',( (value)->
      if value is "K"
        $scope.data.MaterialDriveControls.direct = true
        $scope.data.MaterialDriveControls.IECStandardMotor = false
      else
        $scope.data.MaterialDriveControls.direct = false
        $scope.data.MaterialDriveControls.IECStandardMotor = true
    ),true
    $scope.$watch 'data.MaterialDriveControls.Control ',( (value)->
      if value is "2"
        $scope.data.MaterialDriveControls.IVCPosition = true
      else
        $scope.data.MaterialDriveControls.IVCPosition = false
    ), true

    $scope.resultview = () ->
      chartService.postdata = $scope.data
      $rootScope.navEnable =true
      $location.path '/' + $scope.state + '/chartview'
#      if $location.path() is '/new/materialControl'
#        $location.path '/new/chartview'
#      else
#        $location.path '/edit/chartview'
