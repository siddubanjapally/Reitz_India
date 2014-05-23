// Generated by CoffeeScript 1.6.3
(function() {
  (angular.module('reitz')).controller('ReportController', function($scope, $modalInstance, $window, chartService, projectservice, $location, $timeout) {
    var data, fanProject, gsop;
    $timeout((function() {
      return $('#reportViewer1 a[href="#"]').attr('href', "#" + $location.path());
    }), 5000);
    data = chartService.inputdata;
    gsop = _.map(chartService.inputdata.GasOperatingPoints, function(item) {
      return {
        "T": item.T,
        "P1": item.P,
        "Vi": item.Vi,
        "Vp": item.Vp,
        "Dpt": item.Dpt,
        "Ro": item.Ro
      };
    });
    fanProject = {
      "Proposal_OrderNo": data.Proposal_OrderNo,
      "GasDatas": [
        {
          "VpUnit": data.GasDatas.VpUnit,
          "DptUnit": data.GasDatas.DptUnit,
          "GasOperatingPoints": gsop
        }
      ],
      "MaterialDriveControls": [
        {
          "Width": data.MaterialDriveControls.Width,
          "Control": data.MaterialDriveControls.Control
        }
      ],
      "Date": data.Date,
      "Engineer": data.Engineer,
      "ProjectName": data.ProjectName,
      "fanType": data.MaterialDriveControls.Width,
      "fanImage": data.MaterialDriveControls.FanType,
      "InletSoundSilencer": data.FanAssemblies.InletSoundSilencer,
      'EvaseOutlet_InletAreaRatio': data.FanAssemblies.EvaseOutlet_InletAreaRatio,
      'InletBox': data.FanAssemblies.InletBox,
      'OutletSilencer': data.FanAssemblies.OutletSilencer,
      'OutletOtherParts': data.FanAssemblies.OutletOtherParts,
      'InletOtherParts': data.FanAssemblies.InletOtherParts,
      'PressureDifference': data.FanAssemblies.PressureDifference,
      'MechanicalDesignTemperature': data.MaterialDriveControls.MechanicalDesignTemperature,
      'Drive': data.MaterialDriveControls.Drive,
      'InletOutletDuct': data.MaterialDriveControls.InletOutletDuct,
      'StandardImpellerMaterial': data.MaterialDriveControls.StandardImpellerMaterial,
      "MaterialName": data.MaterialDriveControls.MaterialName,
      "MaterialDensity": data.MaterialDriveControls.MaterialDensity,
      "MaterialYieldStrength": data.MaterialDriveControls.MaterialYieldStrength,
      "IECStandardMotor": data.MaterialDriveControls.IECStandardMotor,
      "NoiseDataRequired": data.MaterialDriveControls.NoiseDataRequired,
      "FanLocation": data.Noises.FanLocation,
      "RoomAbsorptionArea": data.Noises.RoomAbsorptionArea,
      "BackgroundNoiseCorrection": data.Noises.BackgroundNoiseCorrection,
      "HousingMetalPlateThickness": data.Noises.HousingMetalPlateThickness,
      "DistanceBetweenStiffners": data.Noises.DistanceBetweenStiffners,
      "HousingMaterial": data.Noises.HousingMaterial
    };
    if (data.MaterialDriveControls.NominalMotorSpeed === null) {
      _.assign(fanProject, {
        "NominalMotorSpeed": 0
      });
    } else {
      _.assign(fanProject, {
        "NominalMotorSpeed": data.MaterialDriveControls.NominalMotorSpeed
      });
    }
    $window.fanProject = angular.toJson(fanProject);
    $window.fanResult = angular.toJson(chartService.reportdata);
    return $scope.cancel = function() {
      return $modalInstance.dismiss('cancel');
    };
  });

}).call(this);

/*
//@ sourceMappingURL=ReportController.map
*/
