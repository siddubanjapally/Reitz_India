(angular.module 'reitz')
.controller 'createImpellerScantllingsCtrl', ($scope,$location,$cookieStore,chartService,$http,ReitzResources) ->
    if $cookieStore.get('id') is undefined
      $location.path '#/login'
    scantillings = ReitzResources.ImpellerScantllingValues.query()
    $scope.addImpleller=(data)->
      obj = {
        Backplate_mm: +data,
        Blade_mm:+data,
        Shroud_mm:+data
      }
      if _.find(scantillings,obj)
        $scope.errorModeExists = true
        $timeout (->
          # Loadind done here - Show message for 3 more seconds.
          $timeout (->
            $scope.errorModeExists = false
          ), 300
        ), 300
        $scope.data = null
      else
        $http.post('http://202.153.45.8/ReitzService/api/ImpellerScantllingValues', obj).success((val)->
          scantillings.push(val)
          $scope.errorMode = true
          $timeout (->
            # Loadind done here - Show message for 3 more seconds.
            $timeout (->
              #$scope.showMessage = false
              $scope.errorMode = false
            ), 300
          ), 300
          $scope.data = null
        )