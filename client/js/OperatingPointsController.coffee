(->
  (angular.module("reitz")).controller "OperatingPointsController", ($scope, $route, $location, $routeParams, $rootScope,$timeout, projectservice, ReitzResources, chartService) ->
    $scope.state = $routeParams["state"]
    $location.path "#/login"  if localStorage.username is undefined
    $scope.data = projectservice.data
    $scope.opbtn = true
<<<<<<< HEAD
    $scope.$watch "data.GasOperatingPoint.T", ((value) ->
      $scope.data.GasOperatingPoint.Vi = projectservice.density(value)
    ), true
    $scope.chb =
      At: true
      Ro: false
    $scope.$watch "data.GasOperatingPoint.Atcheck", ((value) ->
=======
    $scope.$watch 'data.GasOperatingPoint.T',( (value)->
      $scope.data.GasOperatingPoint.Vi = projectservice.density(value)
    ), true

    $scope.chb ={At:true,Ro:false}

    $scope.$watch 'data.GasOperatingPoint.Atcheck',( (value)->
>>>>>>> 5f2d75b56567dfec2019ed03bad383fb80bd518e
      if value
        console.log value
        $scope.chb.At = false
        $scope.chb.Ro = true
        $scope.data.GasOperatingPoint.Alt = null
#        op.Alt = null
      else
        console.log value
        $scope.chb.At = true
        $scope.chb.Ro = false
    ), true

    $scope.addOperatingPoint = ->
      $scope.data.GasOperatingPoints.push
        T: ""
        F: 0
        P1: 0
        Dpt: ""
        Vp: ""
        Ro: ""

    $scope.deleteGasOperatingPoint = (index) ->
      if $scope.data.GasOperatingPoints.length isnt 1
        $scope.data.GasOperatingPoints.splice index, 1
        projectservice.data.VpOrig.splice index, 1
        projectservice.data.dptOrig.splice index, 1
        $scope.lastOP = $scope.data.GasOperatingPoints.length + 1
        $scope.opbtn = true

<<<<<<< HEAD
    $scope.showGoPoints = (op, index) ->
=======
    $scope.deleteGasOperatingPoint = ()->
      _.remove $scope.data.GasOperatingPoints, (ob)->
        ob is $scope.currentObj
      $scope.data.GasOperatingPoint = $scope.data.GasOperatingPoints[$scope.data.GasOperatingPoints.length-1]
      if $scope.data.GasOperatingPoints.length is 0
        $scope.data.GasOperatingPoint = {T:'',F:0,P1:0,Dpt:'',Vp:'',Ro:''}
      $scope.opbtn = true
      return
    $scope.showGoPoints = (op,index)->
>>>>>>> 5f2d75b56567dfec2019ed03bad383fb80bd518e
      $scope.currentObj = op
      $scope.opbtn = false
      $scope.indexSet = index
      $scope.data.GasOperatingPoint = op

    $scope.updateGoPoint = (index) ->
      _($scope.data.GasOperatingPoints).forEach (op)->
        if op.Atcheck is true
          $scope.data.GasOperatingPoints[index].Atcheck = true
      $scope.data.GasOperatingPoint = $scope.data.GasOperatingPoints[index]
      for op in $scope.data.GasOperatingPoints
        if op.$index is index
          $scope.data.GasOperatingPoints[index] = this.op

    $scope.calculateDensity = ->
      Alt = undefined
      T = undefined
      condition = undefined
      operate = undefined
      console.log "from density"
      condition = $scope.data.GasDatas.DptUnits
      operate = $scope.data.GasOperatingPoint.Dpt
      Alt = $scope.data.GasOperatingPoint.Alt
      T = $scope.data.GasOperatingPoint.T
<<<<<<< HEAD
      $scope.data.GasOperatingPoint.Ro = projectservice.calculateDensity(condition, operate, Alt, T)
=======
      $scope.data.GasOperatingPoint.Ro = projectservice.calculateDensity(condition,operate,Alt,T)
>>>>>>> 5f2d75b56567dfec2019ed03bad383fb80bd518e

    $scope.normaldesityValidate = ->
      value = undefined
      value = $scope.data.GasOperatingPoint.Ro.split(".")
      $scope.data.GasOperatingPoint.Ro = 0 + "." + value[1]  if value[0] is "" and value[1] isnt undefined

    $scope.convert = (data) ->
      if data.countVariables.VpCount is 0
        data.VpOrig = angular.copy $scope.data.GasOperatingPoints
        ++data.countVariables.VpCount
#      else if data.countVariables.VpCount isnt 0
#        console.log data.VpOrig
      else if data.VpOrig.length < $scope.data.GasOperatingPoints.length
        data.VpOrig = data.VpOrig.concat(angular.copy($scope.data.GasOperatingPoints.slice(data.VpOrig.length)))

      if data.GasDatas.VpUnits is "M3/S" or data.GasDatas.VpUnits is "NM3/S"
        _($scope.data.GasOperatingPoints).forEach (op, index) ->
            op.Vp = data.VpOrig[index].Vp
      else if data.GasDatas.VpUnits is "M3/M" or data.GasDatas.VpUnits is "NM3/M"
        console.log data.VpOrig
        _($scope.data.GasOperatingPoints).forEach (op, index) ->
          op.Vp = data.VpOrig[index].Vp * 60
      else if data.GasDatas.VpUnits is "M3/H" or data.GasDatas.VpUnits is "NM3/H"
        _($scope.data.GasOperatingPoints).forEach (op, index) ->
          op.Vp = data.VpOrig[index].Vp * 3600

    $scope.DPTConvert = (data) ->
      if data.countVariables.DptCount is 0
        data.dptOrig = angular.copy $scope.data.GasOperatingPoints
        ++data.countVariables.DptCount
#      else if data.countVariables.VpCount isnt 0
#        console.log data.countVariables, data.dptOrig
      else if data.dptOrig.length < $scope.data.GasOperatingPoints.length
        data.dptOrig = data.dptOrig.concat(angular.copy($scope.data.GasOperatingPoints.slice(data.dptOrig.length)))

      if data.GasDatas.DptUnits is "PA"
        _($scope.data.GasOperatingPoints).forEach (op, index) ->
          op.Dpt = data.dptOrig[index].Dpt
      else if data.GasDatas.DptUnits is "MMwg"
        _($scope.data.GasOperatingPoints).forEach (op, index) ->
          op.Dpt = data.dptOrig[index].Dpt * 9.81
      else if data.GasDatas.DptUnits is "Mbar"
        _($scope.data.GasOperatingPoints).forEach (op, index) ->
          op.Dpt = 10 * data.dptOrig[index].Dpt * 10
      else if data.GasDatas.DptUnits is "Dapa"
        _($scope.data.GasOperatingPoints).forEach (op, index) ->
          op.Dpt = data.dptOrig[index].Dpt * 10

  return
).call this
