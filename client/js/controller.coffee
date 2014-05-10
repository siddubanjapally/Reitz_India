(angular.module 'reitz')
.controller('chartCtrl',($scope,$location,$rootScope,$modal,$routeParams,$timeout,ngTableParams,$filter,$http,projectservice,chartService,ReitzResources)->
    $scope.state = $routeParams['state']
    if localStorage.username is undefined
      $location.path '#/login'
    #$scope.ImpScl = chartService.ImpellerScantllingsValues
    $scope.ImpScl = ReitzResources.ImpellerScantllingValues.query()
#    $scope.inletBoxSizes =  chartService.InletBoxSizes
    ReitzResources.getInletBoxWeitghts (weights)->
      $scope.inletBoxSizes = weights

    projectservice.checkingOperatingPont(projectservice.data)
    $scope.postdata = projectservice.data
    $scope.result = []
    $scope.loading = true
    checkDia= (newdia,olddia)->
      if newdia then newdia else olddia

#findshaftdia is added to find shaft dia at hub using object of fan and weight by Naitik
    findShaftDia = (result,w)->
      weight = getWeight(w) # search and get weight from graph(whatever weights we are having in database

      # to find mean hub value and return result as near as possible
      hub1 = _.find result,{ImpellerWeight:weight.one}
      hub2 = _.find result,{ImpellerWeight:weight.two}
      if hub1 isnt undefined and hub2 isnt undefined
        hub=(hub1.Hub+hub2.Hub)/2
        if hub-(hub - (hub % 10)) < 5
          return hub - (hub % 10)
        else
          return hub - (hub % 10) + 10
      else
        return 0

#findshaftdia is added to find shaft dia at bearing , its totally depends on shaft dia at hub by Naitik
    calShaftBrg = (shafthub) ->
      if $scope.postdata.MaterialDriveControls.Width is '1'
        sb = Math.round(shafthub * 0.65)
      else
        sb = Math.round(shafthub * 0.45)
      if sb - (sb - (sb % 10)) < 5
        return sb - (sb % 10)
      else
        return sb - (sb % 10) + 10

#to search and get weight from graph(availible in database)
    getWeight = (val)->
      val = Math.round(val)
      val = val - (val % 100)
      src = chartService.totalWeight
      for i,key in src
        if val < src[key]

          if val is 200
            return {
            one: src[0],
            two: src[0]
            }
          if val is src[key-1]
            return {
            one: src[key-1],
            two: src[key-1]
            }
          else
            return {
            one: src[key],
            two: src[key-1]
            }

#to search and get bearing span from graph(available in database)
    getBearingSpan = (bearingSpan)->
      bearingSpan=Math.round(bearingSpan)
      min = bearingSpan - (bearingSpan % 100)
      max = min + 100
      if bearingSpan-min <= 50 then min else max

#to search and find Graph from database, depends on that only calculate shaftHub, shaftBrg
    calRpm = (fanSpeed) ->
      fanSpeed = Math.round(fanSpeed)
      fanSpeeds = chartService.fanSpeeds
      for value,i in fanSpeeds
        if fanSpeed <= fanSpeeds[i]
          if i is 0 or fanSpeed is fanSpeeds[i]
            return fanSpeeds[i]
          else
            if fanSpeed < (fanSpeeds[i-1]+fanSpeeds[i])/2
              return fanSpeeds[i-1]
            else
              return fanSpeeds[i]

#to calculate Weight forging, depends on shaftdia at hub value and current bearing span
    calWeightForging = (sftdia, bs) ->
      dia = Math.pow sftdia/1000,2
      return Math.round dia * (bs + 500) * 7.85 * (3.143 / 4)

    $scope.getRievent = (rivent,index)->
      $scope.getRow rivent,index
      $timeout(()->
      if rivent.shafthub is 0
        rivent.shafthub = rivent.old_shafthub
        rivent.shaftbrg = rivent.old_shaftbrg
        chartService.reportdata = rivent
        chartService.inputdata = $scope.postdata
      else
        chartService.reportdata = rivent
        chartService.inputdata = $scope.postdata
      ,400)
#      modalInstance = $modal.open({
#        modalTemplate: '<div class="modal modal-dialog modal-content" ng-transclude></div>',
#        templateUrl: 'views/report.html',
#        width:'custom-width',
#        backdrop: 'static',
#        controller:'ReportController'
#      })
      $timeout(( ()-> modalInstance = $modal.open({
        modalTemplate: '<div class="modal modal-dialog modal-content" ng-transclude></div>',
        templateUrl: 'report.html',
        width:'custom-width',
        backdrop: 'static',
        controller:'ReportController'
      })),500)

    $scope.getRow = (data,index) ->
#      console.log 'get_row'
      currentrow = $scope.tableParams.data[index]
#      console.log currentrow
#      ReitzResources.fanseries.get({id:Math.floor(data.Series)}).$promise.then (result)->
#        $scope.fanseries = result
#        Weight_factor = $scope.fanseries.ImpellerScantllingsFactors[0].WeightFactor
#        data.oldGD2 =  4.2*(data.BackPlate + data.ShroudPlate  + data.Blades ) * Math.pow(((data.OuterBladeDiameter/1000)* Weight_factor),2)
#        $scope.seriesBackplate = $scope.seriesShroudplate = $scope.seriesBlade   = _.find $scope.fanseries.ImpellerScantllings,{Size:data.NominalSize}
#        $scope.single_double_width = _.find $scope.fanseries.CentrifugalFanSeries,{NominalSize:data.NominalSize}

      if +$scope.postdata.MaterialDriveControls.Width is 1
        if $scope.postdata.MaterialDriveControls.FanType is 'KBA'
          currentrow.Hub = Math.round(currentrow.Hub * 1.5)
          currentrow.Total =currentrow.BackPlate+currentrow.ShroudPlate+currentrow.Blades+currentrow.Hub
#          console.log currentrow
      else
#              currentrow.BackPlate = currentrow.BackPlate
        currentrow.ShroudPlate *= 2
        currentrow.Blades *= 2
        currentrow.Hub *= 2
        currentrow.Total =currentrow.BackPlate+currentrow.ShroudPlate+currentrow.Blades+currentrow.Hub
#        console.log currentrow
      $scope.inletweight = _.find $scope.inletBoxSizes,{NominalSize:data.NominalSize,Width:+$scope.postdata.MaterialDriveControls.Width}

      if $scope.inletweight isnt undefined
        $scope.inletBoxSize = $scope.inletweight.InletBoxSizes.split('x')
        currentrow.inletBoxSize1 = +$scope.inletBoxSize[0]
        currentrow.inletBoxSize2 = +$scope.inletBoxSize[1]
      else
        currentrow.inletBoxSize1 = 0
        currentrow.inletBoxSize2 = 0

      ReitzResources.fanseries.get({id:Math.floor(data.Series)}).$promise.then (result)->
        $scope.fanseries = result
        Weight_factor = $scope.fanseries.ImpellerScantllingsFactors[0].WeightFactor
        data.oldGD2 =  4.2*(data.BackPlate + data.ShroudPlate  + data.Blades ) * Math.pow(((data.OuterBladeDiameter/1000)* Weight_factor),2)
        $scope.seriesBackplate = $scope.seriesShroudplate = $scope.seriesBlade   = _.find $scope.fanseries.ImpellerScantllings,{Size:data.NominalSize}
        $scope.single_double_width = _.find $scope.fanseries.CentrifugalFanSeries,{NominalSize:data.NominalSize}

        $scope.seriesBackplate = $scope.seriesShroudplate = $scope.seriesBlade   = _.find $scope.fanseries.ImpellerScantllings,{Size:data.NominalSize}
        if $scope.postdata.MaterialDriveControls.Width is '1'
          currentrow.A = $scope.single_double_width.A
          currentrow.B = $scope.single_double_width.B
          currentrow.bearingSpan = currentrow.B + (currentrow.inletBoxSize1)*0.75 + 500 + 50
        else
          currentrow.A = $scope.single_double_width.A
          currentrow.B = $scope.single_double_width.B * 1.8
          currentrow.bearingSpan = currentrow.B + (currentrow.inletBoxSize1*2)*0.75 + 500 + 50
      $timeout(( ()->
        getRpm = calRpm currentrow.FanSpeed
        ReitzResources.shaftDiaHub.query({rpm:getRpm,range1:getBearingSpan(currentrow.bearingSpan)}).$promise.then (result)->
          if result.length is 0 then console.log ' Graph Not Found in Database . . . !'
          currentrow.old_shafthub = findShaftDia result,currentrow.Total
          currentrow.old_shaftbrg = calShaftBrg  currentrow.old_shafthub
          currentrow.old_wtForging = calWeightForging  currentrow.old_shafthub, currentrow.bearingSpan
        return
      ),500)
      $scope.row = data

    $scope.update = (data,selectedItem,index) ->
      currentrow = $scope.tableParams.data[index]
      $scope.item = selectedItem
      $scope.inletBoxSize = $scope.item.InletBoxSizes.split('x')
      currentrow.inletBoxSize1 = +$scope.inletBoxSize[0]
      currentrow.inletBoxSize2 = +$scope.inletBoxSize[1]
      if $scope.postdata.MaterialDriveControls.Width is '1'
        currentrow.bearingSpan = currentrow.B + (currentrow.inletBoxSize1)*0.75 + 500 + 50
      else
        currentrow.bearingSpan = currentrow.B + (currentrow.inletBoxSize1 * 2)*0.75 + 500 + 50
      if $scope.newFanSpeed isnt undefined
        getRpm = $scope.newFanSpeed
      else
        getRpm = calRpm currentrow.FanSpeed
      ReitzResources.shaftDiaHub.query({rpm:getRpm,range1:getBearingSpan(currentrow.bearingSpan)}).$promise.then (result)->
        if result.length is 0 then console.log ' Graph Not Found in Database . . . !'
        currentrow.shafthub = findShaftDia result,currentrow.Total1
        currentrow.shaftbrg = calShaftBrg  currentrow.shafthub
        currentrow.wtForging = calWeightForging  currentrow.shafthub, currentrow.bearingSpan

    $scope.changeDia =(data,index)->
      $scope.newFanSpeed = data.FanSpeed
      currentrow = $scope.tableParams.data[index]
#      console.log $scope.row.FanSpeed
#      console.log data.FanSpeed
#      console.log $scope.row.OuterBladeDiameter
      currentrow.OuterBladeDiameter1 =Math.ceil (($scope.row.FanSpeed )/data.FanSpeed)*$scope.row.OuterBladeDiameter
      $scope.selectedBackPlate $scope.seriesBackplate,index
      $scope.selectedShroudPlate $scope.seriesShroudplate,index
      $scope.selectedBlade $scope.seriesBlade,index

    $scope.selectedBackPlate = (data,index)->
      currentrow = $scope.tableParams.data[index]
      blace_factor = $scope.fanseries.ImpellerScantllingsFactors[0].BackplateFactor
      Weight_factor = $scope.fanseries.ImpellerScantllingsFactors[0].WeightFactor
      #hubfactor = $scope.fanseries.ImpellerScantllingsFactors[0].HubFactor
      hubfactor = 2.5
      dia = Math.round(Math.pow(((checkDia($scope.row.OuterBladeDiameter1,$scope.row.OuterBladeDiameter))/1000),2)*1000)/1000
      currentrow.backPlate1 = (parseFloat(data.Backplate_mm) * parseFloat(blace_factor) * dia)
      currentrow.hub1 = (parseFloat(data.Backplate_mm) * parseFloat(hubfactor) * dia)
      $scope.row.Total1 =currentrow.backPlate1+currentrow.hub1
      if +$scope.postdata.MaterialDriveControls.Width is 1
        currentrow.backPlate1 = currentrow.backPlate1
        if $scope.postdata.MaterialDriveControls.FanType is 'KBA'
          currentrow.hub1 = Math.round(currentrow.hub1 * 1.5)
          $scope.row.Total1 =currentrow.backPlate1+currentrow.hub1+currentrow.shroudPlate1+currentrow.blades1+currentrow.liner+currentrow.wearPlate
      else
        currentrow.hub1 = Math.round(currentrow.hub1 * 2)
        #        currentrow.backPlate1 = Math.round(currentrow.backPlate1 * 2)
        $scope.row.Total1 =currentrow.backPlate1+currentrow.hub1+currentrow.shroudPlate1+currentrow.blades1+currentrow.liner+currentrow.wearPlate
      #.........New Shaft dia hub and shaft brg calculation
      if $scope.newFanSpeed isnt undefined
        getRpm = $scope.newFanSpeed
      else
        getRpm = calRpm currentrow.FanSpeed
      ReitzResources.shaftDiaHub.query({rpm:getRpm,range1:getBearingSpan(currentrow.bearingSpan)}).$promise.then (result)->
        if result.length is 0 then console.log ' Graph Not Found in Database . . . !'
        currentrow.shafthub = findShaftDia result,currentrow.Total1
        currentrow.shaftbrg = calShaftBrg  currentrow.shafthub
        currentrow.wtForging = calWeightForging  currentrow.shafthub, currentrow.bearingSpan

      _.assign currentrow,{Backplate_mm:data.Backplate_mm}
      currentrow.newGD2 = 4.2*(currentrow.backPlate1+currentrow.hub1+currentrow.shroudPlate1+currentrow.blades1)*Math.pow(((checkDia($scope.row.OuterBladeDiameter1,$scope.row.OuterBladeDiameter)/1000)*Weight_factor),2)

    $scope.selectedShroudPlate = (data,index)->
      currentrow = $scope.tableParams.data[index]
      factor = $scope.fanseries.ImpellerScantllingsFactors[0].ShroudFactor
      Weight_factor = $scope.fanseries.ImpellerScantllingsFactors[0].WeightFactor
      dia = Math.round(Math.pow(((checkDia($scope.row.OuterBladeDiameter1,$scope.row.OuterBladeDiameter))/1000),2)*1000)/1000
      currentrow.shroudPlate1 = (parseFloat(data.Shroud_mm) * parseFloat(factor) * dia)
      _.assign currentrow,{Shroud_mm:data.Shroud_mm}
      currentrow.newGD2 = 4.2*(currentrow.backPlate1+currentrow.hub1+currentrow.shroudPlate1+currentrow.blades1)*Math.pow(((checkDia($scope.row.OuterBladeDiameter1,$scope.row.OuterBladeDiameter)/1000)*Weight_factor),2)
      $scope.row.Total1 =currentrow.backPlate1+currentrow.hub1+currentrow.shroudPlate1
      if +$scope.postdata.MaterialDriveControls.Width is 2
        currentrow.shroudPlate1 = Math.round(currentrow.shroudPlate1 * 2)
        $scope.row.Total1 =currentrow.backPlate1+currentrow.hub1+currentrow.shroudPlate1+currentrow.blades1+currentrow.liner+currentrow.wearPlate
      #.........New Shaft dia hub and shaft brg calculation
      if $scope.newFanSpeed isnt undefined
        getRpm = $scope.newFanSpeed
      else
        getRpm = calRpm currentrow.FanSpeed
      ReitzResources.shaftDiaHub.query({rpm:getRpm,range1:getBearingSpan(currentrow.bearingSpan)}).$promise.then (result)->
        if result.length is 0 then console.log ' Graph Not Found in Database . . . !'
        currentrow.shafthub = findShaftDia result,currentrow.Total1
        currentrow.shaftbrg = calShaftBrg  currentrow.shafthub
        currentrow.wtForging = calWeightForging  currentrow.shafthub, currentrow.bearingSpan
    #    This is for updating bladeplate value based on selected bladeplate

    $scope.selectedBlade = (data,index)->
      currentrow = $scope.tableParams.data[index]
      factor = $scope.fanseries.ImpellerScantllingsFactors[0].BladeFactor
      Weight_factor = $scope.fanseries.ImpellerScantllingsFactors[0].WeightFactor
      dia = Math.round(Math.pow(((checkDia($scope.row.OuterBladeDiameter1,$scope.row.OuterBladeDiameter))/1000),2)*1000)/1000
      currentrow.blades1 = (parseFloat(data.Blade_mm) * parseFloat(factor) * dia)
#      console.log currentrow
      _.assign currentrow,{Blade_mm:data.Blade_mm}
      currentrow.newGD2 = 4.2*(currentrow.backPlate1+currentrow.hub1+currentrow.shroudPlate1+currentrow.blades1)*Math.pow(((checkDia($scope.row.OuterBladeDiameter1,$scope.row.OuterBladeDiameter)/1000)*Weight_factor),2)
      $scope.row.Total1 =currentrow.backPlate1+currentrow.hub1+currentrow.shroudPlate1+currentrow.blades1
      if +$scope.postdata.MaterialDriveControls.Width is 2
        currentrow.blades1 = Math.round(currentrow.blades1 * 2)
        $scope.row.Total1 =currentrow.backPlate1+currentrow.hub1+currentrow.shroudPlate1+currentrow.blades1+currentrow.liner+currentrow.wearPlate
#        console.log currentrow
      #.........New Shaft dia hub and shaft brg calculation
      if $scope.newFanSpeed isnt undefined
        getRpm = $scope.newFanSpeed
      else
        getRpm = calRpm currentrow.FanSpeed
      ReitzResources.shaftDiaHub.query({rpm:getRpm,range1:getBearingSpan(currentrow.bearingSpan)}).$promise.then (result)->
        if result.length is 0 then console.log ' Graph Not Found in Database . . . !'
        currentrow.shafthub = findShaftDia result,currentrow.Total1
        currentrow.shaftbrg = calShaftBrg  currentrow.shafthub
        currentrow.wtForging = calWeightForging  currentrow.shafthub, currentrow.bearingSpan

    $scope.calculateLiner =(linear,percentage,index)->
      currentrow = $scope.tableParams.data[index]
      Weight_factor = $scope.fanseries.ImpellerScantllingsFactors[0].WeightFactor
      factor = $scope.fanseries.ImpellerScantllingsFactors[0].BladeFactor
      dia = Math.round(Math.pow(((checkDia($scope.row.OuterBladeDiameter1,$scope.row.OuterBladeDiameter))/1000),2)*1000)/1000
      if percentage isnt undefined and linear isnt undefined
        currentrow.liner =factor * linear *dia* percentage
        $scope.row.Total1 =currentrow.backPlate1+currentrow.hub1+currentrow.shroudPlate1+currentrow.blades1+currentrow.liner+currentrow.wearPlate
        currentrow.newGD2 = 4.2*$scope.row.Total *Math.pow(((checkDia($scope.row.OuterBladeDiameter1,$scope.row.OuterBladeDiameter)/1000)*Weight_factor),2)
      #.........New Shaft dia hub and shaft brg calculation
      if $scope.newFanSpeed isnt undefined
        getRpm = $scope.newFanSpeed
      else
        getRpm = calRpm currentrow.FanSpeed
      ReitzResources.shaftDiaHub.query({rpm:getRpm,range1:getBearingSpan(currentrow.bearingSpan)}).$promise.then (result)->
        if result.length is 0 then console.log ' Graph Not Found in Database . . . !'
        currentrow.shafthub = findShaftDia result,currentrow.Total1
        currentrow.shaftbrg = calShaftBrg  currentrow.shafthub
        currentrow.wtForging = calWeightForging  currentrow.shafthub, currentrow.bearingSpan

    $scope.calculateWearPlate =(Id,od,linear,index)->
      currentrow = $scope.tableParams.data[index]
      Weight_factor = $scope.fanseries.ImpellerScantllingsFactors[0].WeightFactor
      if od isnt undefined and Id isnt undefined
        currentrow.wearPlate =(Math.pow(Id,2) - Math.pow(od,2)) *linear * 7.85* 3.14/4
        $scope.row.Total1 =currentrow.backPlate1+currentrow.hub1+currentrow.shroudPlate1+currentrow.blades1+currentrow.liner+currentrow.wearPlate
        currentrow.newGD2 = 4.2*$scope.row.Total*Math.pow(((checkDia($scope.row.OuterBladeDiameter1,$scope.row.OuterBladeDiameter)/1000)*Weight_factor),2)
      #.........New Shaft dia hub and shaft brg calculation
      if $scope.newFanSpeed isnt undefined
        getRpm = $scope.newFanSpeed
      else
        getRpm = calRpm currentrow.FanSpeed
      ReitzResources.shaftDiaHub.query({rpm:getRpm,range1:getBearingSpan(currentrow.bearingSpan)}).$promise.then (result)->
        if result.length is 0 then console.log ' Graph Not Found in Database . . . !'
        currentrow.shafthub = findShaftDia result,currentrow.Total1
        currentrow.shaftbrg = calShaftBrg  currentrow.shafthub
        currentrow.wtForging = calWeightForging  currentrow.shafthub, currentrow.bearingSpan

    $scope.saveProjectInfo = () ->
      projectInfo = projectservice.data
#      if !projectservice.data.MaterialDriveControls.NoiseDataRequired
#        projectInfo.Noises = {}
#        console.log projectInfo
#      console.log projectInfo
      ReitzResources.fanproject.create(projectInfo).$promise.then (result)->
        console.log 'inserted successfully', result

    generateChart = (result)->
      chartData =
        series : []
        speed : []
        efficiency : []
        shaftPower : []
        nomenclature:[]
        nominalsize : []
      _.map(_.range(10),(i)->
        chartData.series.push result[i].Series
        chartData.speed.push +result[i].FanSpeed.toFixed(2)
        chartData.efficiency.push result[i].Efficiency
        chartData.shaftPower.push result[i].FanShaftPower
        chartData.nominalsize.push result[i].NominalSize
        chartData.nomenclature.push result[i].Nomenclature
      )
      $scope.renderChart = {
        barChart:
          chart:
            type: 'column',width:800
          title:
            text: 'Ri-vent'
          xAxis:
            categories: chartData.series
          yAxis:
#            categories:[chartData.Efficiency,chartData.speed]
            title:
              text: 'Speed'
          series: [{name:"Speed",data: chartData.speed,color:'orange'},{name:"Efficiency",data:chartData.efficiency,color:'#2f7ed8'},{name:"NominalSize",data:chartData.nominalsize,color:'green'}]
          legend:
            enabled: true
          plotOptions:
            column:
              dataLabels:
                enabled: true
      }

    tableData =()->
      $scope.tableParams = new ngTableParams({
        page:1,
        count:10,
        filter: {
          Series: ''
        },
        sorting:{
          Efficiency:'desc'
        }
      },{
        counts:[],
        total:0,
        getData :( ($defer,params)->
          fanspeed =params.filter().FanSpeed
          console.log params.filter()
          filteredData = if params.filter() then $filter('filter')($scope.result, _.omit(params.filter(),'FanSpeed')) else $scope.result
          fanData = (filteredData,fanspeed)->
            f=fanspeed.split(',')

            if f[1] isnt undefined
              _.filter(filteredData,(fan)->
                if +f[0]<+fan.FanSpeed<+f[1]
                  return fan
              )
            else
              console.log f
              $filter('filter')(filteredData,{FanSpeed:f[0]})

          if fanspeed
            rangeData=fanData(filteredData,fanspeed)
            orderedData = if params.sorting() then $filter('orderBy')(rangeData,params.orderBy()) else $scope.result
            params.total(orderedData.length)
            $defer.resolve(orderedData.slice((params.page() - 1) * params.count(), params.page() * params.count()))
          else
            orderedData = if params.sorting() then $filter('orderBy')(filteredData,params.orderBy()) else $scope.result
            params.total(orderedData.length)
            $defer.resolve(orderedData.slice((params.page() - 1) * params.count(), params.page() * params.count()))

        ),
        $scope: $scope
      })
    #console.log JSON.stringify(projectservice.createJson($scope.postdata))
    ReitzResources.fanresultpost.create(JSON.stringify(projectservice.createJson($scope.postdata))).$promise.then (result)->
      if !_.isEmpty(result)
        result = _.sortBy(result,'Efficiency').reverse()
        result = _.map result,(item)->
          item.FanSpeed = item.FanSpeed + 1.8
          _.assign item,{backPlate1 : 0,shroudPlate1 : 0,blades1 : 0,hub1 : 0,OuterBladeDiameter1:0 ,inletBoxSize1:0,inletBoxSize2:0 ,oldGD2: 0, newGD2:0,A:0,B:0,bearingSpan:0,liner: 0,wearPlate :0,shafthub:0,shaftbrg:0,Total1:0, old_shafthub:0, old_shaftbrg:0,old_wtForging:0,wtForging:0}
        $scope.result = result
#        console.log result[0]
        tableData()
        generateChart(result)
        $scope.loading = false
      else
        $scope.loading = false
  )
.directive('highchart',()->
    return {
    restrict :'E',
    template:'<div></div>',
    render:true,
    link:(scope,element,attr)->
      scope.$watch (-> attr.chart), ->
        return  unless attr.chart
        charts = JSON.parse(attr.chart)
        $(element[0]).highcharts charts
    }
  )

