(angular.module 'reitz')
.controller 'fanAssemblingController',($scope,$route,$location,$routeParams,$rootScope,projectservice,ReitzResources,chartService)->
    $scope.state = $routeParams['state']
    if localStorage.username is undefined
      $location.path '#/login'
    $scope.data = projectservice.data
#    $scope.inletSilencer = ReitzResources.multiunitsdata.query()
    $scope.inletSilencer = projectservice.FanCoeffients
    $scope.lines = {
      faninlet: false,
      fanoutlet: false,
      onlyfan:false,
      onlyinlet:false
    }
    $scope.$watch 'data.FanAssemblies.Pressure_Difference',( (value)->
      if value is '1'
        $scope.lines.fanoutlet = true
        $scope.lines.faninlet = false
        $scope.lines.onlyinlet = true
        $scope.lines.onlyfan = false
      else if value is '2'
        $scope.lines.faninlet = true
        $scope.lines.fanoutlet = false
        $scope.lines.onlyfan = false
      else if value is '3'
        $scope.lines.fanoutlet = true
        $scope.lines.faninlet = true
        $scope.lines.onlyfan = true
      else
        $scope.lines.fanoutlet = false
        $scope.lines.faninlet = false
        $scope.lines.onlyinlet = false
        $scope.lines.onlyfan = false),true

#    $scope.operatingPoint = () ->
#      if $location.path() is '/new/fanAssembling'
#        $location.path '/new/operatingPoint'
#      else
#        $location.path '/edit/operatingPoint'
#
#    $scope.materialControl = () ->
#      if $location.path() is '/new/fanAssembling'
#        $location.path '/new/materialControl'
#      else
#        $location.path '/edit/materialControl'

    $scope.inletSound_validate = ->
      value = $scope.data.FanAssemblies.InletSoundSilencer.split('.')
      if value[0] is '' and value[1] isnt undefined
        $scope.data.FanAssemblies.InletSoundSilencer = 0 + '.' + value[1]

    $scope.inletBox_validate = ->
      value = $scope.data.FanAssemblies.InletBox.split('.')
      if value[0] is '' and value[1] isnt undefined
        $scope.data.FanAssemblies.InletBox = 0 + '.' + value[1]
    $scope.otherInlet_validate = ->
      value = $scope.data.FanAssemblies.InletOtherParts.split('.')
      if value[0] is '' and value[1] isnt undefined
        $scope.data.FanAssemblies.InletOtherParts = 0 + '.' + value[1]


    $scope.outletSilencer = ->
      value = $scope.data.FanAssemblies.OutletSilencer.split('.')
      if value[0] is '' and value[1] isnt undefined
        $scope.data.FanAssemblies.OutletSilencer = 0 + '.' + value[1]
.directive 'combobox',()->
    return {
    restrict:'A'
    link:(scope,element,attrs)->
      scope.$watch(attrs.ngModel,(val)->
        element.combobox()
      ,true)
    }