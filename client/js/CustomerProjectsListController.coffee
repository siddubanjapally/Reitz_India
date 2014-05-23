(->
  app = undefined
  app = angular.module("reitz")

  app.controller "CustomerProjectsListController", ($scope, $location, $cookieStore,ReitzResources, projectservice, $filter, ngTableParams) ->
    if $cookieStore.get('id') is undefined
      $location.path '#/login'
    projectsList = () ->
      $scope.tableList = new ngTableParams({
        page:1,
        count:5,
      },{
        counts:[],
        total:0,
        getData :( ($defer,params)->
          filteredData = if params.filter() then $filter('filter')($scope.projectslist, params.filter()) else $scope.projectslist
          orderedData = if params.sorting() then $filter('orderBy')(filteredData,params.orderBy()) else $scope.projectslist
          params.total(orderedData.length)
          $defer.resolve(orderedData.slice((params.page() - 1) * params.count(), params.page() * params.count()))
        ),
        $scope: $scope
      })
    ReitzResources.fanproject.query().$promise.then (result) ->
      if !_.isEmpty(result)
        $scope.projectslist = result
        projectsList()

    $scope.sendData = (obj) ->
      obj.FanAssemblies.InletBox= obj.FanAssemblies.InletBox.toString()
      obj.FanAssemblies.InletOtherParts= obj.FanAssemblies.InletOtherParts.toString()
      obj.FanAssemblies.InletSoundSilencer= obj.FanAssemblies.InletSoundSilencer.toString()
      obj.FanAssemblies.OutletOtherParts= obj.FanAssemblies.OutletOtherParts.toString()
      obj.FanAssemblies.OutletSilencer= obj.FanAssemblies.OutletSilencer.toString()
      obj.FanAssemblies.Pressure_Difference= obj.FanAssemblies.Pressure_Difference.toString()
      obj.MaterialDriveControls.Width= obj.MaterialDriveControls.Width.toString()
      obj.GasOperatingPoint = obj.GasOperatingPoints[obj.GasOperatingPoints.length-1]
      projectservice.FanCoeffients = ReitzResources.multiunitsdata.query()
      projectservice.data = obj
      projectservice.data.countVariables = {
        VpCount:0
        DptCount:0
      }
#      projectservice.data.VpOrig =[]
#      projectservice.data.dptOrig =[]

      $location.url "/edit/project"

#    $scope.range = ->
#      i = undefined
#      rangeSize = undefined
#      ret = undefined
#      start = undefined
#      rangeSize = 5
#      ret = []
#      start = undefined
#      start = $scope.currentPage
#      start = $scope.pageCount() - rangeSize + 1  if start > $scope.pageCount() - rangeSize
#      i = start
#      while i < start + rangeSize
#        ret.push i
#        i++
#      ret

#    $scope.prevPage = ->
#      $scope.currentPage--  if $scope.currentPage > 0
#      return
#    $scope.prevPageDisabled = ->
#      (if $scope.currentPage is 0 then "disabled" else "")
#
#    $scope.pageCount = ->
#      Math.ceil($scope.projectslist.length / $scope.itemsPerPage) - 1
#
#    $scope.nextPage = ->
#      $scope.currentPage++  if $scope.currentPage < $scope.pageCount()
#      return
#
#    $scope.nextPageDisabled = ->
#      (if $scope.currentPage is $scope.pageCount() then "disabled" else "")
#
#    $scope.setPage = (n) ->
#      $scope.currentPage = n
#      return

  return
).call this

#
#//@ sourceMappingURL=CustomerProjectsListController.map
#