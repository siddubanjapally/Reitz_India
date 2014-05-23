(angular.module 'reitz')
.controller 'createResistantCoefficientsCtrl', ($scope,ReitzResources,$cookieStore) ->
  if $cookieStore.get('id') is undefined
    $location.path '#/login'
  $scope.FanAssemblies=[
    { label: 'Inlet Sound Silencer', value: 0, pId: 10 },
    { label: 'Inlet Box', value: 1 , pId: 11},
    { label: 'Other Inlet parts', value: 2 , pId: 12},
    { label: 'Outlet Silencer', value: 3 , pId: 13},
    { label: 'Other Outlet Parts', value: 4 , pId: 14}
  ];
  $scope.getFanAssembliesName = $scope.FanAssemblies[0]
  coefficients = ReitzResources.multiunitsdata.query()
  $scope.addCofficients = (val, ob) ->
    data = {
      'Name': ob.label,
      'DisplayText':val,
      'Value':val,
      'ParentId':ob.pId,
      'Type':1,
      'ParentDetails': null
    }
    if _.find(coefficients,{ParentId:ob.pId,Value:val,Type:1})
      $scope.errorModeExists = true
      $timeout (->
        # Loadind done here - Show message for 3 more seconds.
        $timeout (->
          $scope.errorModeExists = false
        ), 300
      ), 300
      $scope.data = null
    else
      ReitzResources.multiunitsdata.create(data).$promise.then (values)->
        coefficients.push(values)
        $scope.errorMode = true
        $timeout (->
          # Loadind done here - Show message for 3 more seconds.
          $timeout (->
            $scope.errorMode = false
          ), 300
        ), 300
        $scope.data = null