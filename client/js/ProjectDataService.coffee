(angular.module 'reitz')
.factory 'projectservice',($rootScope)->
    calculateVp = (condition)->
      switch condition
        when "M3/S" then x = parseFloat(1)
        when "M3/M" then x = parseFloat(60)
        when "M3/H" then x = parseFloat(3600)
        when "NM3/S" then x = parseFloat(1)
        when "NM3/M" then x = parseFloat(60)
        when "NM3/H" then x = parseFloat(3600)
    CalcNormalDensity = (condition)->
      switch condition
        when "PA" then x= parseFloat(1)
        when "MMwg" then  x=  parseFloat(0.101)
        when "Mbar" then x=  parseFloat(0.01)
        when "Dapa" then  x= parseFloat(10)
    Density  = (condition,operate)->
      switch condition
        when "PA" then x= parseInt(operate)
        when "MMwg" then  x=  parseInt(operate) * 9.81
        when "Mbar" then x=  parseInt(operate)/0.01
        when "Dapa" then  x= parseInt(operate)/10
    CalculateDensity  = (condition,operate,Alt,T)->
      staticPressure = parseFloat(Density(condition,operate))/ 9.81
      baroPres = 760*(Math.E^(-0.000125*parseInt(Alt)))
      (1.293*(273/(273+parseInt(T)))*(baroPres-(0.0737*staticPressure))/760).toFixed(5)
    postdata =  {}
    FanCoeffients = []
    editdata =  null
    genrateId =  ->
      id = 0
      ()->
         ++id
    data = {
      Proposal_OrderNo:''
      GasOperatingPoint :
        T: ''
        P1:0
        F:0
        Dpt:''
        Vp:''
        Ro:''
      FanAssemblies:
        InletSoundSilencer: '0'
        EvaseOutlet_InletAreaRatio: '0'
        InletBox: '0'
        OutletSilencer: '0'
        OutletOtherParts: '0'
        InletOtherParts:'0'
        Pressure_Difference:'0'
      GasDatas:
        BarometricPressure_Elevation: 0.0
        GasDustload: 0
        VpUnit: '1'
        DptUnit: '1'
        VpUnits : 'M3/S'
        DptUnits: 'PA'
      MaterialDriveControls:
        DesignType: null
        Width: '1'
        BackBlades:false
        StandardImpellerMaterial: true
        IECStandardMotor:false
        NominalMotorSpeed:null
        MotorSpeed:0
        MotorPower:0
        NoiseDataRequired: 0
        MaterialYieldStrength: 0
        IVCPosition:false
        Drive:'K'
        MaterialName: null
        MaterialDensity:0
        direct:true
      Noises:
        Design:0
        FanLocation: 1
        HousingMaterial:0
        RoomAbsorptionArea: '0'
        HousingMetalPlateThickness: '0'
        DistanceBetweenStiffners: 0
        BackgroundNoiseCorrection:'0'
      GasOperatingPoints:[]
    }
    entitykeyNew = (name)->
      $id: id().toString()
      EntitySetName: name
      EntityContainerName: "FanalytixEntities"
      EntityKeyValues: [
        Key: "Id"
        Type: "System.Guid"
        Value: this.guid()
      ]
    tempViscObject = [
      {temp:0,visc:17},{temp:30,visc:18.5},{temp:40,visc:19},
      {temp:50,visc:19.5},{temp:60,visc:19.9},{temp:70,visc:20.4},
      {temp:80,visc:20.8},{temp:90,visc:21.3},{temp:100,visc:21.7},
      {temp:110,visc:22.1},{temp:120,visc:22.5},{temp:130,visc:23},
      {temp:140,visc:23.4},{temp:150,visc:23.8},{temp:160,visc:24.2},
      {temp:180,visc:25},{temp:200,visc:25.6},{temp:220,visc:26.4},
      {temp:250,visc:27.6},{temp:280,visc:28.6},{temp:300,visc:29.3},
      {temp:320,visc:30},{temp:330,visc:30.3},{temp:340,visc:30.7},
      {temp:350,visc:31},{temp:360,visc:31.2},{temp:380,visc:32},
      {temp:400,visc:32.6},{temp:420,visc:33.2},{temp:450,visc:34},
      {temp:500,visc:35.5},{temp:550,visc:36.9},{temp:600,visc:38.3},{temp:650,visc:39.6}]
    density = (temp)->
      for i in [0...tempViscObject.length]
        if tempViscObject[i].temp is +temp
          return tempViscObject[i].visc + 'e-6'
        else if(tempViscObject[i].temp < +temp && +temp < tempViscObject[i+1].temp && +temp <= 650)
          return (( tempViscObject[i].visc  + tempViscObject[i+1].visc )/2 )+ 'e-6'

    guid = ->
        CHARS = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".split("")
        chars = CHARS
        uuid = new Array(36)
        rnd = 0
        r = undefined
        i = 0
        while i < 36
          if i is 8 or i is 13 or i is 18 or i is 23
            uuid[i] = "-"
          else if i is 14
            uuid[i] = "4"
          else
            rnd = 0x2000000 + (Math.random() * 0x1000000) | 0  if rnd <= 0x02
            r = rnd & 0xf
            rnd = rnd >> 4
            uuid[i] = chars[(if (i is 19) then (r & 0x3) | 0x8 else r)]
          i++
        uuid.join ""
    checkingOperatingPont = (data) ->
      i = 0
      if data.GasOperatingPoint.Ro isnt '' && data.GasOperatingPoint.Vp isnt '' &&data.GasOperatingPoint.T isnt '' && data.GasOperatingPoint.Dpt isnt ''
        if data.GasOperatingPoint.T isnt '0' &&  data.GasOperatingPoint.Ro isnt '0' && data.GasOperatingPoint.Vp isnt '0' && data.GasOperatingPoint.Dpt isnt '0'
          if data.GasOperatingPoints.length is 0
            data.GasOperatingPoints.push(data.GasOperatingPoint)
          else
            _.each data.GasOperatingPoints, (ob)->
              i+=1
              if i is data.GasOperatingPoints.length
                if ob.Ro isnt data.GasOperatingPoint.Ro && ob.Vp isnt data.GasOperatingPoint.Vp
                  data.GasOperatingPoints.push(data.GasOperatingPoint)
                  i=0
      data = data
    genearateJson =(data)->
      console.log data
    createJson  = (data) ->
      #data = checkingOperatingPont(data)
      if $rootScope.flag is 0
        id = genrateId()
        obj =
          $id: id().toString()
          Date: data.Date
          Engineer: data.Engineer
          ProjectName: data.ProjectName
          Proposal_OrderNo: data.Proposal_OrderNo
          LastUiFormCompleted: null
          Id: guid()
          FanAssemblies: [
            $id: id().toString()
            Id: guid()
            FanProjectId: guid()
            EvaseOutlet_InletAreaRatio: +data.FanAssemblies.EvaseOutlet_InletAreaRatio
            OutletSilencer: +data.FanAssemblies.OutletSilencer
            OutletOtherParts: +data.FanAssemblies.OutletOtherParts
            InletSoundSilencer: +data.FanAssemblies.InletSoundSilencer
            InletBox: +data.FanAssemblies.InletBox
            InletOtherParts: +data.FanAssemblies.InletOtherParts
            PressureDifference: +data.FanAssemblies.Pressure_Difference
            FanProject:
              $ref: "1"
            EntityKey:
              $id: id().toString()
              EntitySetName: "FanAssemblies"
              EntityContainerName: "FanalytixEntities"
              EntityKeyValues: [
                Key: "Id"
                Type: "System.Guid"
                Value: guid()
              ]
          ]
          FanTypes: []
          GasDatas: [
            $id: id().toString()
            BarometricPressure_Elevation: +data.GasDatas.BarometricPressure_Elevation
            GasDustload: data.GasDatas.GasDustload
            Id: guid()
            FanProjectId: guid()
            VpUnit: calculateVp(data.GasDatas.VpUnits) #data.GasDatas.VpUnit
            DptUnit: CalcNormalDensity(data.GasDatas.DptUnits) #data.GasDatas.DptUnit
            FanProject:
              $ref: "1"
            EntityKey:
              $id: id().toString()
              EntitySetName: "GasDatas"
              EntityContainerName: "FanalytixEntities"
              EntityKeyValues: [
                Key: "Id"
                Type: "System.Guid"
                Value:guid()
              ]
          ]

          UnitValueForInputFields: []
          MaterialDriveControls: [
            $id: id().toString()
            InletOutletDuct: +data.MaterialDriveControls.InletOutletDuct
            Width: +data.MaterialDriveControls.Width
            DesignType: data.MaterialDriveControls.DesignType
            BackBlades: data.MaterialDriveControls.BackBlades
            Control: +data.MaterialDriveControls.Control
            IVCPosition: data.MaterialDriveControls.IVCPosition
            MechanicalDesignTemperature: +data.MaterialDriveControls.MechanicalDesignTemperature
            StandardImpellerMaterial: data.MaterialDriveControls.StandardImpellerMaterial
            MaterialName: data.MaterialDriveControls.MaterialName
            MaterialDensity: +data.MaterialDriveControls.MaterialDensity || null
            MaterialYieldStrength: +data.MaterialDriveControls.MaterialYieldStrength
            IECStandardMotor: data.MaterialDriveControls.IECStandardMotor || false
            NominalMotorSpeed: +data.MaterialDriveControls.NominalMotorSpeed || null
            MotorSpeed: +data.MaterialDriveControls.MotorSpeed || null
            MotorPower: +data.MaterialDriveControls.MotorPower
            Id: guid()
            FanProjectId: guid()
            NoiseDataRequired: data.MaterialDriveControls.NoiseDataRequired
            Drive: data.MaterialDriveControls.Drive
            FanProject:
              $ref: "1"
            EntityKey:
              $id: id().toString()
              EntitySetName: "MaterialDriveControls"
              EntityContainerName: "FanalytixEntities"
              EntityKeyValues: [
                Key: "Id"
                Type: "System.Guid"
                Value: guid()
              ]
          ]
          EntityKey:
            $id: id().toString()
            EntitySetName: "FanProjects"
            EntityContainerName: "FanalytixEntities"
            EntityKeyValues: [
              Key: "Id"
              Type: "System.Guid"
              Value: guid()
            ]
        obj.GasDatas[0].GasOperatingPoints = []
        obj.Noises = []
        if data.MaterialDriveControls.NoiseDataRequired
          obj.Noises.push
            $id: id().toString()
            RoomAbsorptionArea: +data.Noises.RoomAbsorptionArea
            FanLocation: +data.Noises.FanLocation
            BackgroundNoiseCorrection: +data.Noises.BackgroundNoiseCorrection
            Design: +data.Noises.Design
            HousingMetalPlateThickness: +data.Noises.HousingMetalPlateThickness
            DistanceBetweenStiffners: data.Noises.DistanceBetweenStiffners
            HousingMaterial: data.Noises.HousingMaterial
            Id: guid()
            FanProjectId: guid()
            FanProject:
              $ref: "1"
            EntityKey:
              $id: id().toString()
              EntitySetName: "Noises"
              EntityContainerName: "FanalytixEntities"
              EntityKeyValues: [
                Key: "Id"
                Type: "System.Guid"
                Value: guid()
              ]
        _.map _.range(data.GasOperatingPoints.length),(i) ->
          obj.GasDatas[0].GasOperatingPoints.push
            $id: id().toString()
            T: +data.GasOperatingPoints[i].T
            Dpt: +data.GasOperatingPoints[i].Dpt
            P1: +data.GasOperatingPoints[i].P1
            F: +data.GasOperatingPoints[i].F
            Id: guid()
            GasDataId: guid()
            Ro: +data.GasOperatingPoints[i].Ro
            Vi: data.GasOperatingPoints[i].Vi
            Vp: parseFloat(data.GasOperatingPoints[i].Vp)
            GasData:
              $ref: "4"
            EntityKey:
              $id: id().toString()
              EntitySetName: "GasOperatingPoints"
              EntityContainerName: "FanalytixEntities"
              EntityKeyValues: [
                Key: "Id"
                Type: "System.Guid"
                Value: guid()
              ]
        obj
      else
        id = genrateId()
        obj =
          $id: id().toString()
          Date: data.Date
          Engineer: data.Engineer
          ProjectName: data.ProjectName
          Proposal_OrderNo: data.Proposal_OrderNo
          LastUiFormCompleted: null
          Id: data.Id
          FanAssemblies: [
            $id: id().toString()
            Id: data.FanAssemblies.Id
            FanProjectId: data.FanAssemblies.FanProjectId
            EvaseOutlet_InletAreaRatio: +data.FanAssemblies.EvaseOutlet_InletAreaRatio
            OutletSilencer: +data.FanAssemblies.OutletSilencer
            OutletOtherParts: +data.FanAssemblies.OutletOtherParts
            InletSoundSilencer: +data.FanAssemblies.InletSoundSilencer
            InletBox: +data.FanAssemblies.InletBox
            InletOtherParts: +data.FanAssemblies.InletOtherParts
            PressureDifference: +data.FanAssemblies.Pressure_Difference
            FanProject:
              $ref: "1"
            EntityKey:
              $id: id().toString()
              EntitySetName: "FanAssemblies"
              EntityContainerName: "FanalytixEntities"
              EntityKeyValues: [
                Key: "Id"
                Type: "System.Guid"
                Value: guid()
              ]
          ]
          FanTypes: []

          GasDatas: [
            $id:id().toString()
            BarometricPressure_Elevation: +data.GasDatas.BarometricPressure_Elevation
            GasDustload: data.GasDatas.GasDustload
            Id: data.GasDatas.Id
            FanProjectId: data.GasDatas.FanProjectId
            VpUnit: data.GasDatas.VpUnit
            DptUnit:data.GasDatas.DptUnit
            GasOperatingPoints: []
            FanProject:
              $ref: "1"
            EntityKey:
              $id: id().toString()
              EntitySetName: "GasDatas"
              EntityContainerName: "FanalytixEntities"
              EntityKeyValues: [
                Key: "Id"
                Type: "System.Guid"
                Value:guid()
              ]
          ]
          UnitValueForInputFields: []
          MaterialDriveControls: [
            $id: id().toString()
            InletOutletDuct: +data.MaterialDriveControls.InletOutletDuct
            Width: +data.MaterialDriveControls.Width
            DesignType: data.MaterialDriveControls.DesignType
            BackBlades: data.MaterialDriveControls.BackBlades
            Control: +data.MaterialDriveControls.Control
            IVCPosition: data.MaterialDriveControls.IVCPosition
            MechanicalDesignTemperature: +data.MaterialDriveControls.MechanicalDesignTemperature
            StandardImpellerMaterial: data.MaterialDriveControls.StandardImpellerMaterial
            MaterialName: data.MaterialDriveControls.MaterialName
            MaterialDensity: +data.MaterialDriveControls.MaterialDensity || null
            MaterialYieldStrength: +data.MaterialDriveControls.MaterialYieldStrength
            IECStandardMotor: data.MaterialDriveControls.IECStandardMotor || false
            NominalMotorSpeed: +data.MaterialDriveControls.NominalMotorSpeed || null
            MotorSpeed: +data.MaterialDriveControls.MotorSpeed || null
            MotorPower: +data.MaterialDriveControls.MotorPower
            Id: data.MaterialDriveControls.Id
            FanProjectId: data.MaterialDriveControls.FanProjectId
            NoiseDataRequired: data.MaterialDriveControls.NoiseDataRequired
            Drive: data.MaterialDriveControls.Drive
            FanProject:
              $ref: "1"
            EntityKey:
              $id: id().toString()
              EntitySetName: "MaterialDriveControls"
              EntityContainerName: "FanalytixEntities"
              EntityKeyValues: [
                Key: "Id"
                Type: "System.Guid"
                Value: guid()
              ]
          ]
          EntityKey:
            $id: id().toString()
            EntitySetName: "FanProjects"
            EntityContainerName: "FanalytixEntities"
            EntityKeyValues: [
              Key: "Id"
              Type: "System.Guid"
              Value: guid()
            ]
        obj.GasDatas[0].GasOperatingPoints = []
        obj.Noises =[]
        if data.MaterialDriveControls.NoiseDataRequired
          obj.Noises.push
            $id: id().toString()
            RoomAbsorptionArea: +data.Noises.RoomAbsorptionArea
            FanLocation: +data.Noises.FanLocation
            BackgroundNoiseCorrection: +data.Noises.BackgroundNoiseCorrection
            Design: +data.Noises.Design
            HousingMetalPlateThickness: +data.Noises.HousingMetalPlateThickness
            DistanceBetweenStiffners: +data.Noises.DistanceBetweenStiffners
            HousingMaterial: data.Noises.HousingMaterial
            Id: data.Noises.Id
            FanProjectId: data.Noises.FanProjectId
            FanProject:
              $ref: "1"
            EntityKey:
              $id: id().toString()
              EntitySetName: "Noises"
              EntityContainerName: "FanalytixEntities"
              EntityKeyValues: [
                Key: "Id"
                Type: "System.Guid"
                Value: guid()
              ]
        _.map _.range(data.GasOperatingPoints.length),(i) ->
          obj.GasDatas[0].GasOperatingPoints.push
            $id: id().toString()
            Dpt: +data.GasOperatingPoints[i].Dpt
            P1: +data.GasOperatingPoints[i].P1
            F: +data.GasOperatingPoints[i].F
            Id: data.GasOperatingPoints[i].Id
            GasDataId: data.GasOperatingPoints[i].GasDataId
            Ro: +data.GasOperatingPoints[i].Ro
            Vi: data.GasOperatingPoints[i].Vi
            Vp: parseFloat(data.GasOperatingPoints[i].Vp)
            GasData:
              $ref: "4"
            EntityKey:
              $id: id().toString()
              EntitySetName: "GasOperatingPoints"
              EntityContainerName: "FanalytixEntities"
              EntityKeyValues: [
                Key: "Id"
                Type: "System.Guid"
                Value: guid()
              ]
        obj
    return {
      createJson : createJson
      data:data
      density:density
      FanCoeffients:FanCoeffients
      checkingOperatingPont:checkingOperatingPont
      calculateDensity:CalculateDensity
    }

