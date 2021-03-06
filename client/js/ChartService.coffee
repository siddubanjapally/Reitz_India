(angular.module 'reitz')
.factory 'chartService',($http,$resource)->
    chartData = []
    serverData = []
    loading = false
    postdata = {}
    inputdata = {}
    editdata= {}
    ImpellerScantllingsValues=[
      {id:1, Backplate_mm:2.5,Blade_mm:2.5,Shroud_mm:2.5},
      {id:2, Backplate_mm:3.0,Blade_mm:3.0,Shroud_mm:3.0},
      {id:3, Backplate_mm:5.0,Blade_mm:5.0,Shroud_mm:5.0},
      {id:4, Backplate_mm:6.0,Blade_mm:6.0,Shroud_mm:6.0},
      {id:5, Backplate_mm:8.0,Blade_mm:8.0,Shroud_mm:8.0},
      {id:6, Backplate_mm:10.0,Blade_mm:10.0,Shroud_mm:10.0},
      {id:7, Backplate_mm:12.0,Blade_mm:12.0,Shroud_mm:12.0},
      {id:8, Backplate_mm:16.0,Blade_mm:16.0,Shroud_mm:16.0},
      {id:9, Backplate_mm:20.0,Blade_mm:20.0,Shroud_mm:20.0}
    ]
    InletBoxSizes = [{NominalSize:400,inletboxsize:'215 x 650 x 5',Width:1},
      {NominalSize:450,inletboxsize:	'247 x 735 x 5',Width:1},
      {NominalSize:500,inletboxsize:	'275 x 820 x 5',Width:1},
      {NominalSize:560,inletboxsize:'305 x 925 x 5',Width:1},
      {NominalSize:630,inletboxsize:'350 x 1040 x 5',Width:1},
      {NominalSize:710,inletboxsize:	'390 x 1160 x 6',Wdith:1},
      {NominalSize:800,inletboxsize:	'430 x 1300 x 6',Width:1},
      {NominalSize:900,inletboxsize:	'485 x 1455 x 6',Width:1},
      {NominalSize:1000,inletboxsize:'545 x 1635 x 6',Width:1},{NominalSize:1000,inletboxsize:'470 x 1885 x 6',Width:2},
      {NominalSize:1120,inletboxsize:	'610 x 1835 x 6',Width:1},{NominalSize:1120,inletboxsize:'530 x 2120 x 6',Width:2},
      {NominalSize:1250,inletboxsize:	'695 x 2080 x 6',Width:1},{NominalSize:1250,inletboxsize:'600 x 2400 x 6',Width:2},
      {NominalSize:1400,inletboxsize:'775 x 2325 x 6',Width:1},{NominalSize:1400,inletboxsize:	'670 x 2685 x 6',Width:2},
      {NominalSize:1600,inletboxsize:	'865 x 2600 x 6',Width:1},{NominalSize:1600,inletboxsize:'750 x 3000 x 6',Width:2},
      {NominalSize:1800,inletboxsize:	'970 x 2900 x 6',Width:1},{NominalSize:1800,inletboxsize:'840 x 3360 x 6',Width:2},
      {NominalSize:2000	,inletboxsize:'1080 x 3240 x 6',Width:1},{NominalSize:2000	,inletboxsize:'935 x 3740 x 6',Width:2}
      {NominalSize:2240,inletboxsize:	'1210 x 3630 x 6',Width:1},{NominalSize:2240,inletboxsize:'1050 x 4200 x 6',Wdith:2},
      {NominalSize:2500,inletboxsize:'1360 x 4080 x 6',Width:1},{NominalSize:2500,inletboxsize:'1180 x 4720 x 6',Width:2}
    ]
    totalWeight =[100,250,500,700,1000,1500,2000,2500,3500,5000,6500,7500,8500,10000,12500,15000,20000,25000]
    totalWeight1 =[25,50,75,100,150,200,250,300,350,400,500,600,650,750]
    fanSpeeds = [490, 590, 705, 740, 880, 980, 1175, 1470, 1760, 2500, 3500]
    return {
      chartData:chartData
      loading:loading
      postdata:postdata
      editdata:editdata
      inputdata:inputdata
      serverData:serverData
      fanSpeeds:fanSpeeds
      InletBoxSizes:InletBoxSizes
      totalWeight1:totalWeight1
      totalWeight:totalWeight
      ImpellerScantllingsValues:ImpellerScantllingsValues
    }