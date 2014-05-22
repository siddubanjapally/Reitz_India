(angular.module 'reitz')
.controller 'ReportController',($scope,$modalInstance,$window,chartService,projectservice)->
    data = chartService.inputdata
    gsop = _.map chartService.inputdata.GasOperatingPoints,(item)->
      {"T":item.T,"P1":item.P,"Vi":item.Vi,"Vp":item.Vp,"Dpt":item.Dpt,"Ro":item.Ro}
    #"CustomerName":data.CustomerName,
    fanProject = {"Proposal_OrderNo":data.Proposal_OrderNo, "GasDatas":[{"VpUnit":data.GasDatas.VpUnit,"DptUnit":data.GasDatas.DptUnit,"GasOperatingPoints":gsop}],"MaterialDriveControls":[{"Width":data.MaterialDriveControls.Width,"Control":data.MaterialDriveControls.Control}],"Date":data.Date,"Engineer":data.Engineer,"ProjectName":data.ProjectName,"fanType":data.MaterialDriveControls.Width,"fanImage":data.MaterialDriveControls.FanType
    ,"InletSoundSilencer":data.FanAssemblies.InletSoundSilencer,'EvaseOutlet_InletAreaRatio':data.FanAssemblies.EvaseOutlet_InletAreaRatio
    ,'InletBox':data.FanAssemblies.InletBox,'OutletSilencer':data.FanAssemblies.OutletSilencer,'OutletOtherParts':data.FanAssemblies.OutletOtherParts,'InletOtherParts':data.FanAssemblies.InletOtherParts
    ,'PressureDifference':data.FanAssemblies.PressureDifference,'MechanicalDesignTemperature':data.MaterialDriveControls.MechanicalDesignTemperature
    ,'Drive':data.MaterialDriveControls.Drive,'InletOutletDuct':data.MaterialDriveControls.InletOutletDuct
    ,'StandardImpellerMaterial':data.MaterialDriveControls.StandardImpellerMaterial
    "MaterialName":data.MaterialDriveControls.MaterialName,"MaterialDensity":data.MaterialDriveControls.MaterialDensity,"MaterialYieldStrength":data.MaterialDriveControls.MaterialYieldStrength
    "IECStandardMotor":data.MaterialDriveControls.IECStandardMotor,"NoiseDataRequired":data.MaterialDriveControls.NoiseDataRequired
    ,"FanLocation":data.Noises.FanLocation,"RoomAbsorptionArea":data.Noises.RoomAbsorptionArea,"BackgroundNoiseCorrection":data.Noises.BackgroundNoiseCorrection
    ,"HousingMetalPlateThickness":data.Noises.HousingMetalPlateThickness,"DistanceBetweenStiffners":data.Noises.DistanceBetweenStiffners,"HousingMaterial":data.Noises.HousingMaterial
    }
    if data.MaterialDriveControls.NominalMotorSpeed is null
      _.assign fanProject,{"NominalMotorSpeed":0}
    else
      _.assign fanProject,{ "NominalMotorSpeed":data.MaterialDriveControls.NominalMotorSpeed}

#    if data.MaterialDriveControls.NoiseDataRequired
#      _.assign fanProject,angular.toJson({"NoiseDataRequired":data.MaterialDriveControls.NoiseDataRequired
#      ,"FanLocation":data.Noises.FanLocation,"RoomAbsorptionArea":data.Noises.RoomAbsorptionArea,"BackgroundNoiseCorrection":data.Noises.BackgroundNoiseCorrection
#      ,"HousingMetalPlateThickness":data.Noises.HousingMetalPlateThickness,"DistanceBetweenStiffners":data.Noises.DistanceBetweenStiffners,"HousingMaterial":data.Noises.HousingMaterial})

    $window.fanProject = angular.toJson(fanProject)
    $window.fanResult = angular.toJson(chartService.reportdata)

    $scope.cancel = ()->
      $modalInstance.dismiss('cancel')

