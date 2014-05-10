(angular.module 'reitz')
.factory 'userService', ($rootScope) ->

    user_admin = {
      role: 'admin',
      username: 'admin',
      password: '123'
    }
    user_employer =[ {
      role: 'employer',
      username: 'employee',
      password: '123'
    }]
    isActive={}
    return{
      user_admin: user_admin,
      user_employer: user_employer,
      isActive:isActive
    }
