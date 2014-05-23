(angular.module 'reitz')
.factory 'ReitzResources',($resource,$http)->
    fanproject: $resource('http://202.153.45.8/ReitzService/api/FanProject/',{},{
      query:{method:'GET',isArray:true}
      create:{method:'POST'}
    })
    fanseries:$resource 'http://202.153.45.8/ReitzService/api/FanSeries/:id',{},{
      query:{method:'GET'}
    }
    multiunitsdata: $resource 'http://202.153.45.8/ReitzService/api/MultiDisplayControlData/',{},{
      query:{method:'GET',isArray:true}
      create:{method:'POST'}
    }
    fanresultpost: $resource 'http://sikkimgazettes.technoidentity.com/api/Values',{},{
      query:{method:'GET',isArray:true}
      create:{method:'POST',isArray:true}
    }
    shaftDiaHub:$resource ' http://202.153.45.8/ReitzService/api/RpmType/:rpm/:range1',{},{
      query:{method:'GET',isArray:true}
    }
    ImpellerScantllingValues:$resource ' http://202.153.45.8/ReitzService/api/ImpellerScantllingValues',{},{
      query:{method:'GET',isArray:true}

    }
    createUser:$resource 'http://192.168.0.177/ReitzService/api/Account/Register',{},{
      query:{method:'GET',isArray:true}
      create:{method:'POST'}
    }
    getInletBoxWeitghts: (cb)->
      $http.get("http://202.153.45.8/ReitzService/GrossWeightOfInletBoxes").success((data)->
        cb(data)).error (error)->
          console.log error
    #http://202.153.45.8/ReitzService/GrossWeightOfInletBoxes
