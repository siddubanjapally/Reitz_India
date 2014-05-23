// Generated by CoffeeScript 1.6.3
(function() {
  (function() {
    (angular.module("reitz")).controller("OperatingPointsController", function($scope, $cookieStore, $route, $location, $routeParams, $rootScope, $timeout, projectservice, ReitzResources, chartService) {
      $scope.state = $routeParams["state"];
      if ($cookieStore.get('id') === void 0) {
        $location.path("#/login");
      }
      $scope.data = projectservice.data;
      $scope.opbtn = true;
      $scope.$watch("data.GasOperatingPoint.T", (function(value) {
        return $scope.data.GasOperatingPoint.Vi = projectservice.density(value);
      }), true);
      $scope.chb = {
        At: true,
        Ro: false
      };
      $scope.chb = {
        At: true,
        Ro: false
      };
      $scope.$watch('data.GasOperatingPoint.Atcheck', (function(value) {
        if (value) {
          console.log(value);
          $scope.chb.At = false;
          $scope.chb.Ro = true;
          return $scope.data.GasOperatingPoint.Alt = null;
        } else {
          console.log(value);
          $scope.chb.At = true;
          return $scope.chb.Ro = false;
        }
      }), true);
      $scope.addOperatingPoint = function() {
        return $scope.data.GasOperatingPoints.push({
          T: "",
          F: 0,
          P1: 0,
          Dpt: "",
          Vp: "",
          Ro: ""
        });
      };
      $scope.deleteGasOperatingPoint = function(index) {
        if ($scope.data.GasOperatingPoints.length !== 1) {
          $scope.data.GasOperatingPoints.splice(index, 1);
          projectservice.data.VpOrig.splice(index, 1);
          projectservice.data.dptOrig.splice(index, 1);
          $scope.lastOP = $scope.data.GasOperatingPoints.length + 1;
          return $scope.opbtn = true;
        }
      };
      $scope.showGoPoints = function(op, index) {
        $scope.currentObj = op;
        $scope.opbtn = false;
        $scope.indexSet = index;
        return $scope.data.GasOperatingPoint = op;
      };
      $scope.updateGoPoint = function(index) {
        var op, _i, _len, _ref, _results;
        _($scope.data.GasOperatingPoints).forEach(function(op) {
          if (op.Atcheck === true) {
            return $scope.data.GasOperatingPoints[index].Atcheck = true;
          }
        });
        $scope.data.GasOperatingPoint = $scope.data.GasOperatingPoints[index];
        _ref = $scope.data.GasOperatingPoints;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          op = _ref[_i];
          if (op.$index === index) {
            _results.push($scope.data.GasOperatingPoints[index] = this.op);
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      };
      $scope.calculateDensity = function() {
        var Alt, T, condition, operate;
        Alt = void 0;
        T = void 0;
        condition = void 0;
        operate = void 0;
        console.log("from density");
        condition = $scope.data.GasDatas.DptUnits;
        operate = $scope.data.GasOperatingPoint.Dpt;
        Alt = $scope.data.GasOperatingPoint.Alt;
        T = $scope.data.GasOperatingPoint.T;
        $scope.data.GasOperatingPoint.Ro = projectservice.calculateDensity(condition, operate, Alt, T);
        return $scope.data.GasOperatingPoint.Ro = projectservice.calculateDensity(condition, operate, Alt, T);
      };
      $scope.normaldesityValidate = function() {
        var value;
        value = void 0;
        value = $scope.data.GasOperatingPoint.Ro.split(".");
        if (value[0] === "" && value[1] !== void 0) {
          return $scope.data.GasOperatingPoint.Ro = 0 + "." + value[1];
        }
      };
      $scope.convert = function(data) {
        if (data.countVariables.VpCount === 0) {
          data.VpOrig = angular.copy($scope.data.GasOperatingPoints);
          ++data.countVariables.VpCount;
        } else if (data.VpOrig.length < $scope.data.GasOperatingPoints.length) {
          data.VpOrig = data.VpOrig.concat(angular.copy($scope.data.GasOperatingPoints.slice(data.VpOrig.length)));
        }
        if (data.GasDatas.VpUnits === "M3/S" || data.GasDatas.VpUnits === "NM3/S") {
          return _($scope.data.GasOperatingPoints).forEach(function(op, index) {
            return op.Vp = data.VpOrig[index].Vp;
          });
        } else if (data.GasDatas.VpUnits === "M3/M" || data.GasDatas.VpUnits === "NM3/M") {
          console.log(data.VpOrig);
          return _($scope.data.GasOperatingPoints).forEach(function(op, index) {
            return op.Vp = data.VpOrig[index].Vp * 60;
          });
        } else if (data.GasDatas.VpUnits === "M3/H" || data.GasDatas.VpUnits === "NM3/H") {
          return _($scope.data.GasOperatingPoints).forEach(function(op, index) {
            return op.Vp = data.VpOrig[index].Vp * 3600;
          });
        }
      };
      return $scope.DPTConvert = function(data) {
        if (data.countVariables.DptCount === 0) {
          data.dptOrig = angular.copy($scope.data.GasOperatingPoints);
          ++data.countVariables.DptCount;
        } else if (data.dptOrig.length < $scope.data.GasOperatingPoints.length) {
          data.dptOrig = data.dptOrig.concat(angular.copy($scope.data.GasOperatingPoints.slice(data.dptOrig.length)));
        }
        if (data.GasDatas.DptUnits === "PA") {
          return _($scope.data.GasOperatingPoints).forEach(function(op, index) {
            return op.Dpt = data.dptOrig[index].Dpt;
          });
        } else if (data.GasDatas.DptUnits === "MMwg") {
          return _($scope.data.GasOperatingPoints).forEach(function(op, index) {
            return op.Dpt = data.dptOrig[index].Dpt * 9.81;
          });
        } else if (data.GasDatas.DptUnits === "Mbar") {
          return _($scope.data.GasOperatingPoints).forEach(function(op, index) {
            return op.Dpt = 10 * data.dptOrig[index].Dpt * 10;
          });
        } else if (data.GasDatas.DptUnits === "Dapa") {
          return _($scope.data.GasOperatingPoints).forEach(function(op, index) {
            return op.Dpt = data.dptOrig[index].Dpt * 10;
          });
        }
      };
    });
  }).call(this);

}).call(this);

/*
//@ sourceMappingURL=OperatingPointsController.map
*/
