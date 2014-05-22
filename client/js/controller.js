// Generated by CoffeeScript 1.6.3
(function() {
  (angular.module('reitz')).controller('chartCtrl', function($scope, $location, $rootScope, $modal, $routeParams, $timeout, ngTableParams, $filter, $http, projectservice, chartService, ReitzResources) {
    var calRpm, calShaftBrg, calWeightForging, changelinerandwearplate, checkDia, findShaftDia, generateChart, getBearingSpan, getWeight, getWeight1, newDiaCalculation, tableData;
    $scope.state = $routeParams['state'];
    if (localStorage.username === void 0) {
      $location.path('#/login');
    }
    $scope.ImpScl = ReitzResources.ImpellerScantllingValues.query();
    ReitzResources.getInletBoxWeitghts(function(weights) {
      return $scope.inletBoxSizes = weights;
    });
    projectservice.checkingOperatingPont(projectservice.data);
    $scope.postdata = projectservice.data;
    $scope.result = [];
    $scope.loading = true;
    checkDia = function(newdia, olddia) {
      if (newdia) {
        return newdia;
      } else {
        return olddia;
      }
    };
    findShaftDia = function(result, w) {
      var hub, hub1, hub2, weight;
      if (result[0].Rpm === 2500 || result[0].Rpm === 3500) {
        weight = getWeight1(w);
      } else {
        weight = getWeight(w);
      }
      hub1 = _.find(result, {
        ImpellerWeight: weight.one
      });
      hub2 = _.find(result, {
        ImpellerWeight: weight.two
      });
      if (hub1 !== void 0 && hub2 !== void 0) {
        hub = (hub1.Hub + hub2.Hub) / 2;
        if (hub - (hub - (hub % 10)) < 5) {
          return hub - (hub % 10);
        } else {
          return hub - (hub % 10) + 10;
        }
      } else {
        return 0;
      }
    };
    calShaftBrg = function(shafthub) {
      var sb;
      if ($scope.postdata.MaterialDriveControls.Width === '1') {
        sb = Math.round(shafthub * 0.65);
      } else {
        sb = Math.round(shafthub * 0.45);
      }
      if (sb - (sb - (sb % 10)) < 5) {
        return sb - (sb % 10);
      } else {
        return sb - (sb % 10) + 10;
      }
    };
    getWeight = function(val) {
      var i, key, src, _i, _len;
      val = Math.round(val);
      val = val - (val % 100);
      src = chartService.totalWeight;
      for (key = _i = 0, _len = src.length; _i < _len; key = ++_i) {
        i = src[key];
        if (val < src[key]) {
          if (val === 200) {
            return {
              one: src[0],
              two: src[0]
            };
          }
          if (val === src[key - 1]) {
            return {
              one: src[key - 1],
              two: src[key - 1]
            };
          } else {
            return {
              one: src[key],
              two: src[key - 1]
            };
          }
        }
      }
    };
    getWeight1 = function(val) {
      var i, key, src, _i, _len;
      val = Math.round(val);
      src = chartService.totalWeight1;
      for (key = _i = 0, _len = src.length; _i < _len; key = ++_i) {
        i = src[key];
        if (val < src[key]) {
          if (val <= 25) {
            return {
              one: src[0],
              two: src[0]
            };
          }
          if (val === src[key - 1]) {
            return {
              one: src[key - 1],
              two: src[key - 1]
            };
          } else {
            return {
              one: src[key],
              two: src[key - 1]
            };
          }
        }
      }
    };
    getBearingSpan = function(bearingSpan) {
      var max, min;
      bearingSpan = Math.round(bearingSpan);
      min = bearingSpan - (bearingSpan % 100);
      max = min + 100;
      if (bearingSpan - min <= 50) {
        return min;
      } else {
        return max;
      }
    };
    calRpm = function(fanSpeed) {
      var fanSpeeds, i, value, _i, _len;
      fanSpeed = Math.round(fanSpeed);
      fanSpeeds = chartService.fanSpeeds;
      for (i = _i = 0, _len = fanSpeeds.length; _i < _len; i = ++_i) {
        value = fanSpeeds[i];
        if (fanSpeed <= fanSpeeds[i]) {
          if (i === 0 || fanSpeed === fanSpeeds[i]) {
            return fanSpeeds[i];
          } else {
            if (fanSpeed < (fanSpeeds[i - 1] + fanSpeeds[i]) / 2) {
              return fanSpeeds[i - 1];
            } else {
              return fanSpeeds[i];
            }
          }
        }
      }
    };
    calWeightForging = function(sftdia, bs) {
      var dia;
      dia = Math.pow(sftdia / 1000, 2);
      return Math.round(dia * (bs + 500) * 7.85 * (3.143 / 4));
    };
    $scope.linersRequired = false;
    $scope.getRievent = function(rivent, index) {
      chartService.reportdata = rivent;
      chartService.inputdata = $scope.postdata;
      return $timeout((function() {
        var modalInstance;
        return modalInstance = $modal.open({
          modalTemplate: '<div class="modal modal-dialog modal-content" ng-transclude></div>',
          templateUrl: 'report.html',
          width: 'custom-width',
          backdrop: 'static',
          controller: 'ReportController'
        });
      }), 500);
    };
    $scope.showreportimg = false;
    newDiaCalculation = function(newobj) {
      return Math.round(Math.pow((checkDia(newobj.OuterBladeDiameter1, newobj.OuterBladeDiameter)) / 1000, 2) * 1000) / 1000;
    };
    $scope.getRow = function(data, index, element) {
      var currentrow;
      console.log(element);
      currentrow = $scope.tableParams.data[index];
      if (+$scope.postdata.MaterialDriveControls.Width === 1) {
        currentrow.Total = Math.round(currentrow.BackPlate + currentrow.ShroudPlate + currentrow.Blades + currentrow.Hub);
        if ($scope.postdata.MaterialDriveControls.FanType === 'KBA') {
          currentrow.Hub = Math.round(currentrow.Hub * 1.5);
          currentrow.Total = Math.round(currentrow.BackPlate + currentrow.ShroudPlate + currentrow.Blades + currentrow.Hub);
        }
      } else {
        $scope.linersRequired = true;
        currentrow.ShroudPlate = Math.round(currentrow.ShroudPlate * 2);
        currentrow.Blades = Math.round(currentrow.Blades * 2);
        currentrow.Hub = Math.round(currentrow.Hub * 2);
        currentrow.Total = Math.round(currentrow.BackPlate + currentrow.ShroudPlate + currentrow.Blades + currentrow.Hub);
      }
      $scope.inletweight = _.find($scope.inletBoxSizes, {
        NominalSize: data.NominalSize,
        Width: +$scope.postdata.MaterialDriveControls.Width
      });
      if ($scope.inletweight !== void 0) {
        $scope.inletBoxSize = $scope.inletweight.InletBoxSizes.split('x');
        currentrow.inletBoxSize1 = +$scope.inletBoxSize[0];
        currentrow.inletBoxSize2 = +$scope.inletBoxSize[1];
      } else {
        currentrow.inletBoxSize1 = 0;
        currentrow.inletBoxSize2 = 0;
      }
      ReitzResources.fanseries.get({
        id: Math.floor(data.Series)
      }).$promise.then(function(result) {
        var Weight_factor;
        $scope.fanseries = result;
        Weight_factor = $scope.fanseries.ImpellerScantllingsFactors[0].WeightFactor;
        data.oldGD2 = Math.round(4.2 * (data.BackPlate + data.ShroudPlate + data.Blades) * Math.pow((data.OuterBladeDiameter / 1000) * Weight_factor, 2));
        $scope.seriesBackplate = $scope.seriesShroudplate = $scope.seriesBlade = _.find($scope.fanseries.ImpellerScantllings, {
          Size: data.NominalSize
        });
        $scope.single_double_width = _.find($scope.fanseries.CentrifugalFanSeries, {
          NominalSize: data.NominalSize
        });
        $scope.seriesBackplate = $scope.seriesShroudplate = $scope.seriesBlade = _.find($scope.fanseries.ImpellerScantllings, {
          Size: data.NominalSize
        });
        if ($scope.postdata.MaterialDriveControls.Width === '1') {
          currentrow.A = $scope.single_double_width.A;
          currentrow.B = $scope.single_double_width.B;
          return currentrow.bearingSpan = Math.round(currentrow.B + currentrow.inletBoxSize1 * 0.75 + 500 + 50);
        } else {
          currentrow.A = $scope.single_double_width.A;
          currentrow.B = $scope.single_double_width.B * 1.8;
          return currentrow.bearingSpan = Math.round(currentrow.B + (currentrow.inletBoxSize1 * 2) * 0.75 + 500 + 50);
        }
      });
      $timeout((function() {
        var getRpm;
        getRpm = calRpm(currentrow.FanSpeed);
        ReitzResources.shaftDiaHub.query({
          rpm: getRpm,
          range1: getBearingSpan(currentrow.bearingSpan)
        }).$promise.then(function(result) {
          if (result.length === 0) {
            console.log(' Graph Not Found in Database . . . !');
          }
          currentrow.old_shafthub = Math.round(findShaftDia(result, currentrow.Total));
          currentrow.old_shaftbrg = Math.round(calShaftBrg(currentrow.old_shafthub));
          return currentrow.old_wtForging = Math.round(calWeightForging(currentrow.old_shafthub, currentrow.bearingSpan));
        });
      }), 500);
      return $scope.row = data;
    };
    $scope.update = function(data, selectedItem, index) {
      var currentrow, getRpm;
      currentrow = $scope.tableParams.data[index];
      $scope.item = selectedItem;
      $scope.inletBoxSize = $scope.item.InletBoxSizes.split('x');
      currentrow.inletBoxSize1 = +$scope.inletBoxSize[0];
      currentrow.inletBoxSize2 = +$scope.inletBoxSize[1];
      if ($scope.postdata.MaterialDriveControls.Width === '1') {
        currentrow.bearingSpan = Math.round(currentrow.B + currentrow.inletBoxSize1 * 0.75 + 500 + 50);
      } else {
        currentrow.bearingSpan = Math.round(currentrow.B + (currentrow.inletBoxSize1 * 2) * 0.75 + 500 + 50);
      }
      if ($scope.newFanSpeed !== void 0) {
        getRpm = $scope.newFanSpeed;
      } else {
        getRpm = calRpm(currentrow.FanSpeed);
      }
      return ReitzResources.shaftDiaHub.query({
        rpm: getRpm,
        range1: getBearingSpan(currentrow.bearingSpan)
      }).$promise.then(function(result) {
        if (result.length === 0) {
          console.log(' Graph Not Found in Database . . . !');
        }
        currentrow.shafthub = Math.round(findShaftDia(result, currentrow.Total1));
        currentrow.shaftbrg = Math.round(calShaftBrg(currentrow.shafthub));
        return currentrow.wtForging = Math.round(calWeightForging(currentrow.shafthub, currentrow.bearingSpan));
      });
    };
    $scope.changeDia = function(data, index) {
      var currentrow;
      $scope.newFanSpeed = data.FanSpeed;
      currentrow = $scope.tableParams.data[index];
      currentrow.OuterBladeDiameter1 = Math.ceil(($scope.row.FanSpeed / data.FanSpeed) * $scope.row.OuterBladeDiameter);
      $scope.selectedBackPlate($scope.seriesBackplate, index);
      $scope.selectedShroudPlate($scope.seriesShroudplate, index);
      return $scope.selectedBlade($scope.seriesBlade, index);
    };
    $scope.selectedBackPlate = function(data, index) {
      var Weight_factor, blace_factor, currentrow, dia, getRpm, hubfactor;
      currentrow = $scope.tableParams.data[index];
      blace_factor = $scope.fanseries.ImpellerScantllingsFactors[0].BackplateFactor;
      Weight_factor = $scope.fanseries.ImpellerScantllingsFactors[0].WeightFactor;
      hubfactor = 2.5;
      dia = newDiaCalculation($scope.row);
      currentrow.backPlate1 = Math.round(parseFloat(data.Backplate_mm) * parseFloat(blace_factor) * dia);
      currentrow.hub1 = Math.round(parseFloat(data.Backplate_mm) * parseFloat(hubfactor) * dia);
      $scope.row.Total1 = Math.round(currentrow.backPlate1 + currentrow.hub1);
      if (+$scope.postdata.MaterialDriveControls.Width === 1) {
        currentrow.backPlate1 = Math.round(currentrow.backPlate1);
        if ($scope.postdata.MaterialDriveControls.FanType === 'KBA') {
          currentrow.hub1 = Math.round(currentrow.hub1 * 1.5);
          $scope.row.Total1 = Math.round(currentrow.backPlate1 + currentrow.hub1 + currentrow.shroudPlate1 + currentrow.blades1 + currentrow.liner + currentrow.wearPlate);
        }
      } else {
        currentrow.hub1 = Math.round(currentrow.hub1 * 2);
        $scope.row.Total1 = Math.round(currentrow.backPlate1 + currentrow.hub1 + currentrow.shroudPlate1 + currentrow.blades1 + currentrow.liner + currentrow.wearPlate);
      }
      if ($scope.newFanSpeed !== void 0) {
        getRpm = $scope.newFanSpeed;
      } else {
        getRpm = calRpm(currentrow.FanSpeed);
      }
      ReitzResources.shaftDiaHub.query({
        rpm: getRpm,
        range1: getBearingSpan(currentrow.bearingSpan)
      }).$promise.then(function(result) {
        if (result.length === 0) {
          console.log(' Graph Not Found in Database . . . !');
        }
        currentrow.shafthub = Math.round(findShaftDia(result, currentrow.Total1));
        currentrow.shaftbrg = Math.round(calShaftBrg(currentrow.shafthub));
        return currentrow.wtForging = Math.round(calWeightForging(currentrow.shafthub, currentrow.bearingSpan));
      });
      _.assign(currentrow, {
        Backplate_mm: data.Backplate_mm
      });
      return currentrow.newGD2 = Math.round(4.2 * (currentrow.backPlate1 + currentrow.hub1 + currentrow.shroudPlate1 + currentrow.blades1) * Math.pow((checkDia($scope.row.OuterBladeDiameter1, $scope.row.OuterBladeDiameter) / 1000) * Weight_factor, 2));
    };
    $scope.selectedShroudPlate = function(data, index) {
      var Weight_factor, currentrow, dia, factor, getRpm;
      currentrow = $scope.tableParams.data[index];
      factor = $scope.fanseries.ImpellerScantllingsFactors[0].ShroudFactor;
      Weight_factor = $scope.fanseries.ImpellerScantllingsFactors[0].WeightFactor;
      dia = newDiaCalculation($scope.row);
      currentrow.shroudPlate1 = Math.round(parseFloat(data.Shroud_mm) * parseFloat(factor) * dia);
      _.assign(currentrow, {
        Shroud_mm: data.Shroud_mm
      });
      currentrow.newGD2 = Math.round(4.2 * (currentrow.backPlate1 + currentrow.hub1 + currentrow.shroudPlate1 + currentrow.blades1) * Math.pow((checkDia($scope.row.OuterBladeDiameter1, $scope.row.OuterBladeDiameter) / 1000) * Weight_factor, 2));
      $scope.row.Total1 = Math.round(currentrow.backPlate1 + currentrow.hub1 + currentrow.shroudPlate1);
      if (+$scope.postdata.MaterialDriveControls.Width === 2) {
        currentrow.shroudPlate1 = Math.round(currentrow.shroudPlate1 * 2);
        $scope.row.Total1 = Math.round(currentrow.backPlate1 + currentrow.hub1 + currentrow.shroudPlate1 + currentrow.blades1 + currentrow.liner + currentrow.wearPlate);
      }
      if ($scope.newFanSpeed !== void 0) {
        getRpm = $scope.newFanSpeed;
      } else {
        getRpm = calRpm(currentrow.FanSpeed);
      }
      return ReitzResources.shaftDiaHub.query({
        rpm: getRpm,
        range1: getBearingSpan(currentrow.bearingSpan)
      }).$promise.then(function(result) {
        if (result.length === 0) {
          console.log(' Graph Not Found in Database . . . !');
        }
        currentrow.shafthub = Math.round(findShaftDia(result, currentrow.Total1));
        currentrow.shaftbrg = Math.round(calShaftBrg(currentrow.shafthub));
        return currentrow.wtForging = Math.round(calWeightForging(currentrow.shafthub, currentrow.bearingSpan));
      });
    };
    $scope.selectedBlade = function(data, index) {
      var Weight_factor, currentrow, dia, factor, getRpm;
      currentrow = $scope.tableParams.data[index];
      factor = $scope.fanseries.ImpellerScantllingsFactors[0].BladeFactor;
      Weight_factor = $scope.fanseries.ImpellerScantllingsFactors[0].WeightFactor;
      dia = newDiaCalculation($scope.row);
      currentrow.blades1 = Math.round(parseFloat(data.Blade_mm) * parseFloat(factor) * dia);
      _.assign(currentrow, {
        Blade_mm: data.Blade_mm
      });
      currentrow.newGD2 = Math.round(4.2 * (currentrow.backPlate1 + currentrow.hub1 + currentrow.shroudPlate1 + currentrow.blades1) * Math.pow((checkDia($scope.row.OuterBladeDiameter1, $scope.row.OuterBladeDiameter) / 1000) * Weight_factor, 2));
      $scope.row.Total1 = Math.round(currentrow.backPlate1 + currentrow.hub1 + currentrow.shroudPlate1 + currentrow.blades1);
      if (+$scope.postdata.MaterialDriveControls.Width === 2) {
        currentrow.blades1 = Math.round(currentrow.blades1 * 2);
        $scope.row.Total1 = Math.round(currentrow.backPlate1 + currentrow.hub1 + currentrow.shroudPlate1 + currentrow.blades1 + currentrow.liner + currentrow.wearPlate);
      }
      if ($scope.newFanSpeed !== void 0) {
        getRpm = $scope.newFanSpeed;
      } else {
        getRpm = calRpm(currentrow.FanSpeed);
      }
      return ReitzResources.shaftDiaHub.query({
        rpm: getRpm,
        range1: getBearingSpan(currentrow.bearingSpan)
      }).$promise.then(function(result) {
        if (result.length === 0) {
          console.log(' Graph Not Found in Database . . . !');
        }
        currentrow.shafthub = Math.round(findShaftDia(result, currentrow.Total1));
        currentrow.shaftbrg = Math.round(calShaftBrg(currentrow.shafthub));
        return currentrow.wtForging = Math.round(calWeightForging(currentrow.shafthub, currentrow.bearingSpan));
      });
    };
    changelinerandwearplate = function(currentrow, Weight_factor) {
      if (currentrow.Total1 === 0) {
        $scope.row.Total = Math.round(currentrow.BackPlate + currentrow.Hub + currentrow.ShroudPlate + currentrow.Blades + currentrow.liner + currentrow.wearPlate);
        currentrow.oldGD2 = Math.round(4.2 * $scope.row.Total * Math.pow((checkDia($scope.row.OuterBladeDiameter1, $scope.row.OuterBladeDiameter) / 1000) * Weight_factor, 2));
        return currentrow;
      } else {
        $scope.row.Total1 = Math.round(currentrow.backPlate1 + currentrow.hub1 + currentrow.shroudPlate1 + currentrow.blades1 + currentrow.liner + currentrow.wearPlate);
        currentrow.newGD2 = Math.round(4.2 * $scope.row.Total1 * Math.pow((checkDia($scope.row.OuterBladeDiameter1, $scope.row.OuterBladeDiameter) / 1000) * Weight_factor, 2));
        return currentrow;
      }
    };
    $scope.calculateLiner = function(linear, percentage, index) {
      var Weight_factor, currentrow, dia, factor, getRpm;
      currentrow = $scope.tableParams.data[index];
      Weight_factor = $scope.fanseries.ImpellerScantllingsFactors[0].WeightFactor;
      factor = $scope.fanseries.ImpellerScantllingsFactors[0].BladeFactor;
      dia = newDiaCalculation($scope.row);
      if (percentage !== void 0 && linear !== void 0) {
        currentrow.liner = Math.round(factor * linear * dia * percentage);
        currentrow = changelinerandwearplate(currentrow, Weight_factor);
      }
      if ($scope.newFanSpeed !== void 0) {
        getRpm = $scope.newFanSpeed;
      } else {
        getRpm = calRpm(currentrow.FanSpeed);
      }
      return ReitzResources.shaftDiaHub.query({
        rpm: getRpm,
        range1: getBearingSpan(currentrow.bearingSpan)
      }).$promise.then(function(result) {
        if (result.length === 0) {
          console.log(' Graph Not Found in Database . . . !');
        }
        currentrow.shafthub = Math.round(findShaftDia(result, currentrow.Total1));
        currentrow.shaftbrg = Math.round(calShaftBrg(currentrow.shafthub));
        return currentrow.wtForging = Math.round(calWeightForging(currentrow.shafthub, currentrow.bearingSpan));
      });
    };
    $scope.calculateWearPlate = function(Id, od, linear, index) {
      var Weight_factor, currentrow, getRpm;
      currentrow = $scope.tableParams.data[index];
      Weight_factor = $scope.fanseries.ImpellerScantllingsFactors[0].WeightFactor;
      if (od !== void 0 && Id !== void 0) {
        currentrow.wearPlate = Math.round((Math.pow(Id, 2) - Math.pow(od, 2)) * linear * 7.85 * 3.14 / 4);
        currentrow = changelinerandwearplate(currentrow, Weight_factor);
      }
      if ($scope.newFanSpeed !== void 0) {
        getRpm = $scope.newFanSpeed;
      } else {
        getRpm = calRpm(currentrow.FanSpeed);
      }
      return ReitzResources.shaftDiaHub.query({
        rpm: getRpm,
        range1: getBearingSpan(currentrow.bearingSpan)
      }).$promise.then(function(result) {
        if (result.length === 0) {
          console.log(' Graph Not Found in Database . . . !');
        }
        currentrow.shafthub = Math.round(findShaftDia(result, currentrow.Total1));
        currentrow.shaftbrg = Math.round(calShaftBrg(currentrow.shafthub));
        return currentrow.wtForging = Math.round(calWeightForging(currentrow.shafthub, currentrow.bearingSpan));
      });
    };
    $scope.saveProjectInfo = function() {
      var projectInfo;
      projectInfo = projectservice.data;
      return ReitzResources.fanproject.create(projectInfo).$promise.then(function(result) {
        return console.log('inserted successfully', result);
      });
    };
    generateChart = function(result) {
      var chartData;
      chartData = {
        series: [],
        speed: [],
        efficiency: [],
        shaftPower: [],
        nomenclature: [],
        nominalsize: []
      };
      _.map(_.range(10), function(i) {
        chartData.series.push(result[i].Series);
        chartData.speed.push(+result[i].FanSpeed.toFixed(2));
        chartData.efficiency.push(result[i].Efficiency);
        chartData.shaftPower.push(result[i].FanShaftPower);
        chartData.nominalsize.push(result[i].NominalSize);
        return chartData.nomenclature.push(result[i].Nomenclature);
      });
      return $scope.renderChart = {
        barChart: {
          chart: {
            type: 'column',
            width: 800
          },
          title: {
            text: 'Ri-vent'
          },
          xAxis: {
            categories: chartData.nomenclature
          },
          yAxis: {
            title: {
              text: 'Speed'
            }
          },
          series: [
            {
              name: "Speed",
              data: chartData.speed,
              color: 'orange'
            }, {
              name: "Efficiency",
              data: chartData.efficiency,
              color: '#2f7ed8'
            }, {
              name: "NominalSize",
              data: chartData.nominalsize,
              color: 'green'
            }
          ],
          legend: {
            enabled: true
          },
          plotOptions: {
            column: {
              dataLabels: {
                enabled: true
              }
            }
          }
        }
      };
    };
    tableData = function() {
      return $scope.tableParams = new ngTableParams({
        filter: {
          Series: ''
        },
        sorting: {
          Efficiency: 'desc'
        }
      }, {
        counts: [],
        getData: (function($defer, params) {
          var filteredData, filterobj, orderedData, rangekeys, tabledataRange;
          filteredData = params.filter() ? $filter('filter')($scope.result, _.omit(params.filter(), ['FanSpeed', 'Nomenclature', 'NominalSize', 'Efficiency', 'OuterBladeDiameter', 'FanShaftPower'])) : $scope.result;
          filterobj = params.filter();
          rangekeys = _.keys(filterobj);
          filterobj = _.omit(filterobj, function(value) {
            return value === "" || value === void 0;
          });
          rangekeys = _.keys(filterobj);
          tabledataRange = function(fanData, filtervalue, filterkey) {
            var a, n, obj;
            if (filtervalue.search('-') !== -1) {
              n = filtervalue.split('-');
              if (n[1] !== void 0) {
                return _.filter(fanData, function(fan) {
                  var _ref;
                  if ((+n[0] <= (_ref = +fan[filterkey]) && _ref <= +n[1])) {
                    return fan;
                  }
                });
              }
            } else if (filtervalue.search(',') !== -1) {
              n = filtervalue.split(',');
              if (n[1] !== void 0) {
                n = filtervalue.split(',');
                a = [];
                _.map(_.range(0, n.length), function(i) {
                  var obj;
                  obj = {};
                  obj[filterkey] = n[i];
                  return a = _.union(a, $filter('filter')(fanData, obj));
                });
                return a;
              }
            } else {
              obj = {};
              obj[filterkey] = filtervalue;
              return $filter('filter')(filteredData, obj);
            }
          };
          if (rangekeys.length) {
            _.map(_.range(rangekeys.length), function(i) {
              filteredData = tabledataRange(filteredData, filterobj[rangekeys[i]], rangekeys[i]);
              return console.log(filteredData);
            });
            orderedData = params.sorting() ? $filter('orderBy')(filteredData, params.orderBy()) : $scope.result;
            return $defer.resolve(orderedData);
          } else {
            orderedData = params.sorting() ? $filter('orderBy')(filteredData, params.orderBy()) : $scope.result;
            return $defer.resolve(orderedData);
          }
        }),
        $scope: $scope
      });
    };
    return ReitzResources.fanresultpost.create(JSON.stringify(projectservice.createJson($scope.postdata))).$promise.then(function(result) {
      if (!_.isEmpty(result)) {
        result = _.sortBy(result, 'Efficiency').reverse();
        result = _.map(result, function(item) {
          item.BackPlate = Math.round(item.BackPlate);
          item.ShroudPlate = Math.round(item.ShroudPlate);
          item.Blades = Math.round(item.Blades);
          item.Hub = Math.round(item.Hub);
          item.FanSpeed = Math.round((item.FanSpeed + 1.8) * 10) / 10;
          item.Efficiency = Math.round(item.Efficiency * 10) / 10;
          item.FanShaftPower = Math.round(item.FanShaftPower * 10) / 10;
          return _.assign(item, {
            backPlate1: 0,
            shroudPlate1: 0,
            blades1: 0,
            hub1: 0,
            OuterBladeDiameter1: 0,
            inletBoxSize1: 0,
            inletBoxSize2: 0,
            oldGD2: 0,
            newGD2: 0,
            A: 0,
            B: 0,
            bearingSpan: 0,
            liner: 0,
            wearPlate: 0,
            shafthub: 0,
            shaftbrg: 0,
            Total1: 0,
            old_shafthub: 0,
            old_shaftbrg: 0,
            old_wtForging: 0,
            wtForging: 0
          });
        });
        $scope.result = result;
        tableData();
        generateChart(result);
        return $scope.loading = false;
      } else {
        return $scope.loading = false;
      }
    });
  }).directive('highchart', function() {
    return {
      restrict: 'E',
      template: '<div></div>',
      render: true,
      link: function(scope, element, attr) {
        return scope.$watch((function() {
          return attr.chart;
        }), function() {
          var charts;
          if (!attr.chart) {
            return;
          }
          charts = JSON.parse(attr.chart);
          return $(element[0]).highcharts(charts);
        });
      }
    };
  });

}).call(this);

/*
//@ sourceMappingURL=controller.map
*/
