(angular.module 'reitz',['ngRoute','ngResource','ngTable','ui.bootstrap'])
.config ($routeProvider,$locationProvider,$httpProvider) ->
    $routeProvider
    .when('/login',{
          templateUrl: 'views/customer/customerlogin.html',
          controller: 'CustomerLoginController'})
    .when('/home',{
          templateUrl: 'views/customer/customerhome.html',
          controller: 'CustomerHomeController'})
    .when('/:state/project',{
          templateUrl: 'views/customer/Project_Data.html',
          controller: 'ProjectDataController'})
    .when('/:state/operatingPoint',{
          templateUrl: 'views/customer/operatingpoints.html',
          controller: 'OperatingPointsController'})
    .when('/:state/fanAssembling',{
          templateUrl: 'views/customer/Fan_Assembling.html',
          controller: 'fanAssemblingController'})
    .when('/:state/materialControl',{
          templateUrl: 'views/customer/Material_Control.html',
          controller: 'materialControlController'})
    .when('/:state/noiseData',{
          templateUrl: 'views/customer/Noises_Data.html',
          controller: 'noiseDataController'})
    .when '/:state/chartview',
        templateUrl: 'views/customer/resultview.html'
        controller: 'chartCtrl'
    .when('/:state/projectslist',{
          templateUrl: 'views/customer/projectslist.html',
          controller: 'CustomerProjectsListController'})
    .when('/:state/project',{
          templateUrl: 'views/customer/Project_Data.html',
          controller: 'ProjectDataController'})
    .when('/:state/operatingPoint',{
          templateUrl: 'views/customer/operatingpoints.html',
          controller: 'OperatingPointsController'})
    .when('/:state/fanAssembling',{
          templateUrl: 'views/customer/Fan_Assembling.html',
          controller: 'fanAssemblingController'})
    .when('/:state/materialControl',{
          templateUrl: 'views/customer/Material_Control.html',
          controller: 'materialControlController'})
    .when('/:state/noiseData',{
          templateUrl: 'views/customer/Noises_Data.html',
          controller: 'noiseDataController'})
    .when '/:state/chartview',
        templateUrl: 'views/customer/resultview.html'
        controller: 'chartCtrl'
    .when '/reportview',
        templateUrl: 'views/customer/Reportview.html'
        controller: 'ReportController'
    .when '/createuser',
        templateUrl:'views/customer/createUser.html'
        controller:'createUserCtrl'
    .when '/createResistantCoefficients',
        templateUrl: 'views/customer/createResistantCoefficients.html',
        controller: 'createResistantCoefficientsCtrl'
    .when '/createImpellerScantllings',
        templateUrl: 'views/customer/createImpellerScantllings.html',
        controller: 'createImpellerScantllingsCtrl'
    .otherwise redirectTo: '/login'
    ### $locationProvider.html5Mode true
    $locationProvider.hashPrefix('!')###
    $httpProvider.defaults.useXDomain = true
    delete $httpProvider.defaults.headers.common['X-Requested-With']
