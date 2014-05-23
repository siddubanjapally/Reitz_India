// Generated by CoffeeScript 1.6.3
(function() {
  (angular.module('reitz')).controller('CustomerHomeController', function($scope, $cookieStore, $rootScope, $routeParams, $filter, $location, projectservice, ReitzResources) {
    $scope.state = $routeParams['state'];
    if ($cookieStore.get('id') === void 0) {
      $location.path('#/login');
    }
    return $scope.gotoNewProject = function() {
      $rootScope.navEnable = false;
      projectservice.data = {
        VpOrig: [],
        dptOrig: [],
        countVariables: {
          VpCount: 0,
          DptCount: 0
        },
        Date: $filter("date")(Date.now(), 'yyyy-MM-dd'),
        Proposal_OrderNo: '',
        GasOperatingPoint: {
          T: '',
          P1: 0,
          F: 0,
          Dpt: '',
          Vp: '',
          Ro: ''
        },
        GasOperatingPoints: [
          {
            T: '',
            P1: 0,
            F: 0,
            Dpt: '',
            Vp: '',
            Ro: ''
          }
        ],
        FanAssemblies: {
          InletSoundSilencer: '0',
          EvaseOutlet_InletAreaRatio: '0',
          InletBox: '0',
          OutletSilencer: '0',
          OutletOtherParts: '0',
          InletOtherParts: '0',
          Pressure_Difference: '0'
        },
        GasDatas: {
          BarometricPressure_Elevation: 0.0,
          GasDustload: 0,
          VpUnit: '60',
          DptUnit: '10',
          VpUnits: 'M3/S',
          DptUnits: 'PA'
        },
        MaterialDriveControls: {
          DesignType: null,
          Width: '1',
          BackBlades: false,
          StandardImpellerMaterial: true,
          IECStandardMotor: false,
          NominalMotorSpeed: null,
          MotorSpeed: 0,
          MotorPower: 0,
          NoiseDataRequired: 0,
          MaterialYieldStrength: 0,
          IVCPosition: false,
          Drive: 'K',
          MaterialName: '',
          MaterialDensity: 0,
          direct: true
        },
        Noises: {
          Design: 0,
          FanLocation: 1,
          HousingMaterial: 0,
          RoomAbsorptionArea: '0',
          HousingMetalPlateThickness: '0',
          DistanceBetweenStiffners: 0,
          BackgroundNoiseCorrection: '0'
        }
      };
      projectservice.FanCoeffients = ReitzResources.multiunitsdata.query();
      $location.url('new/project');
      return console.log(projectservice.data);
    };
  }).controller('navCtrl', function($scope, $location, userService) {
    if (userService.isActive.user !== void 0) {
      console.log(userService.isActive.user.UserName);
      $scope.user = userService.isActive.user;
      if (userService.isActive.user.Roles[0].RoleId === '2') {
        $scope.user = userService.isActive;
        $scope.admin_role = true;
        $scope.user = userService.isActive.user.UserName;
      } else if (userService.isActive.user.Roles[0].RoleId === '1') {
        $scope.admin_role = false;
        $scope.user = userService.isActive.user.UserName;
      }
    }
    $scope.isActive = function(route) {
      var path;
      path = '#' + $location.path();
      return route === $location.path();
    };
    $scope.isNewProject = function() {
      var path;
      path = '#' + $location.path();
      return ['#/new/project', '#/new/operatingPoint', '#/new/fanAssembling', '#/new/materialControl', '#/new/noiseData', '#/new/chartview'].indexOf(path) > -1;
    };
    $scope.isEditProject = function() {
      var path;
      path = '#' + $location.path();
      return ['#/projectslist', '#/edit/project', '#/edit/operatingPoint', '#/edit/fanAssembling', '#/edit/materialControl', '#/edit/noiseData', '#/edit/chartview'].indexOf(path) > -1;
    };
    return $scope.isSetting = function() {
      var path;
      path = '#' + $location.path();
      return ['#/createuser', '#/createResistantCoefficients', '#/createImpellerScantllings'].indexOf(path) > -1;
    };
  });

}).call(this);

/*
//@ sourceMappingURL=CustomerHomeController.map
*/
