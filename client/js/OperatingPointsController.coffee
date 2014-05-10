(angular.module 'reitz')
.controller 'OperatingPointsController',($scope,$route,$location,$routeParams,$rootScope,projectservice,ReitzResources,chartService)->
    $scope.state = $routeParams['state']
    if localStorage.username is undefined
      $location.path '#/login'
    $scope.data = projectservice.data
    $scope.opbtn = true
    $scope.$watch 'data.GasOperatingPoint.T',( (value)->
      $scope.data.GasOperatingPoint.Vi = projectservice.density(value)
    ), true

    $scope.chb ={At:true,Ro:false}

    $scope.$watch 'data.GasOperatingPoint.Atcheck',( (value)->
      if value
        $scope.chb.At = false
        $scope.chb.Ro = true
        $scope.data.GasOperatingPoint.Alt = null
      else
        $scope.chb.At = true
        $scope.chb.Ro = false
        #$scope.data.GasOperatingPoint.Ro = null
    ),true

    $scope.addOperatingPoint = (dummy)->
      if dummy is undefined
        if $scope.data.GasOperatingPoints.length is 0
          if $scope.data.GasOperatingPoint.T is ''  && $scope.data.GasOperatingPoint.Ro is ''  && $scope.data.GasOperatingPoint.Vp is '' && $scope.data.GasOperatingPoint.Dpt is ''
            console.log 'Data Required '
          else
            if $scope.data.GasOperatingPoint.T isnt '0' &&  $scope.data.GasOperatingPoint.Ro isnt '0' && $scope.data.GasOperatingPoint.Vp isnt '0' && $scope.data.GasOperatingPoint.Dpt isnt '0'
              $scope.data.GasOperatingPoints.push($scope.data.GasOperatingPoint)
              $scope.data.GasOperatingPoint = {T:'',F:0,P1:0,Dpt:'',Vp:'',Ro:''}
            else
              console.log 'Data Required '
        else
          count = 0
          _.each $scope.data.GasOperatingPoints, (ob)->
            if ob.Ro is $scope.data.GasOperatingPoint.Ro && ob.Vp is $scope.data.GasOperatingPoint.Vp && ob.T is $scope.data.GasOperatingPoint.T
              count+=1
          if count is 0
            if $scope.data.GasOperatingPoint.T is '' && $scope.data.GasOperatingPoint.Ro is ''  && $scope.data.GasOperatingPoint.Vp is '' && $scope.data.GasOperatingPoint.Dpt is ''
              console.log 'Data Required '
            else
              if $scope.data.GasOperatingPoint.T isnt '0' &&  $scope.data.GasOperatingPoint.Ro isnt '0' && $scope.data.GasOperatingPoint.Vp isnt '0' && $scope.data.GasOperatingPoint.Dpt isnt '0'
                $scope.data.GasOperatingPoints.push($scope.data.GasOperatingPoint)
                $scope.data.GasOperatingPoint = {T:'',F:0,P1:0,Dpt:'',Vp:'',Ro:''}
              else
                console.log 'Data Required '
          else
            $scope.data.GasOperatingPoint = {T:'',F:0,P1:0,Dpt:'',Vp:'',Ro:''}
      else
        $scope.data.GasOperatingPoints[dummy]=$scope.data.GasOperatingPoint
        $scope.data.GasOperatingPoint = {T:'',F:0,P1:0,Dpt:'',Vp:'',Ro:''}

    $scope.deleteGasOperatingPoint = ()->
      _.remove $scope.data.GasOperatingPoints, (ob)->
        ob is $scope.currentObj
      $scope.data.GasOperatingPoint = $scope.data.GasOperatingPoints[$scope.data.GasOperatingPoints.length-1]
      if $scope.data.GasOperatingPoints.length is 0
        $scope.data.GasOperatingPoint = {T:'',F:0,P1:0,Dpt:'',Vp:'',Ro:''}
      $scope.opbtn = true
      return
    $scope.showGoPoints = (op,index)->
      $scope.currentObj = op
      $scope.opbtn = false
      $scope.indexSet=index
      $scope.data.GasOperatingPoint = op

    $scope.updateGoPoint = () ->
      $scope.opbtn = true
      $scope.addOperatingPoint($scope.indexSet)

    $scope.calculateDensity =()->
      condition = $scope.data.GasDatas.DptUnits
      operate = $scope.data.GasOperatingPoint.Dpt
      Alt = $scope.data.GasOperatingPoint.Alt
      T = $scope.data.GasOperatingPoint.T
      $scope.data.GasOperatingPoint.Ro = projectservice.calculateDensity(condition,operate,Alt,T)

    $scope.normaldesityValidate = ->
      value = $scope.data.GasOperatingPoint.Ro.split('.')
      if value[0] is '' and value[1] isnt undefined
        $scope.data.GasOperatingPoint.Ro = 0 + '.' + value[1]
    $scope.convert = (data) ->
      $scope.Vpvalue = data.GasOperatingPoint.Vp
      if data.GasDatas.VpUnits is 'M3/S'
        $scope.Vpvalue = data.GasOperatingPoint.Vp
      else if data.GasDatas.VpUnits is 'M3/M'
        $scope.Vpvalue = data.GasOperatingPoint.Vp*60
      else if data.GasDatas.VpUnits is 'M3/H'
        $scope.Vpvalue = data.GasOperatingPoint.Vp*3600
      else if data.GasDatas.VpUnits is 'NM3/S'
        $scope.Vpvalue = data.GasOperatingPoint.Vp
      else if data.GasDatas.VpUnits is 'NM3/M'
        $scope.Vpvalue = data.GasOperatingPoint.Vp*60
      else if data.GasDatas.VpUnits is 'NM3/H'
        $scope.Vpvalue = data.GasOperatingPoint.Vp*3600
    $scope.DPTConvert = (data) ->
      $scope.DPTValue = data.GasOperatingPoint.Dpt
      if data.GasDatas.DptUnits is 'PA'
        $scope.DPTValue = data.GasOperatingPoint.Dpt
      else if data.GasDatas.DptUnits is 'MMwg'
        $scope.DPTValue = 9.81 * data.GasOperatingPoint.Dpt
      else if data.GasDatas.DptUnits is 'Mbar'
        $scope.DPTValue = 10 * data.GasOperatingPoint.Dpt * 10
      else if data.GasDatas.DptUnits is 'Dapa'
        $scope.DPTValue = data.GasOperatingPoint.Dpt * 10

