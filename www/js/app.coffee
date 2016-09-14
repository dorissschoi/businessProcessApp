env = require './env.coffee'

angular.module 'starter', ['ngFancySelect', 'ionic', 'util.auth', 'starter.controller', 'starter.model', 'http-auth-interceptor', 'ngTagEditor', 'ActiveRecord', 'ngFileUpload', 'ngTouch', 'ngAnimate', 'pascalprecht.translate', 'locale']
	
	.run (authService) ->
		authService.login env.oauth2.opts
	        
	.run ($rootScope, platform, $ionicPlatform, $location, $http) ->
		$ionicPlatform.ready ->
			if (window.cordova && window.cordova.plugins.Keyboard)
				cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true)
			if (window.StatusBar)
				StatusBar.styleDefault()
											
	.config ($stateProvider, $urlRouterProvider, $translateProvider) ->
	
		$stateProvider.state 'app',
			url: ""
			abstract: true
			templateUrl: "templates/menu.html"
	
		$stateProvider.state 'app.createBProc',
			url: "/businessProcess/create"
			cache: false
			views:
				'menuContent':
					templateUrl: "templates/businessProcess/create.html"
					controller: 'BusinessProcessCtrl'
			resolve:
				resources: 'resources'
				
				model: (resources) ->
					ret = new resources.BusinessProcess()				
	
			$stateProvider.state 'app.deploy',
			url: "/businessProcess/deploy"
			cache: false
			views:
				'menuContent':
					templateUrl: "templates/businessProcess/deploy.html"
					controller: 'BusinessProcessCtrl'
			resolve:
				resources: 'resources'
				
				model: (resources) ->
					ret = new resources.BusinessProcess()	
					
		$stateProvider.state 'app.edit',
			url: "/businessProcess/edit/:id"
			cache: false
			views:
				'menuContent':
					templateUrl: "templates/businessProcess/edit.html"
					controller: 'BusinessProcessCtrl'
			resolve:
				id: ($stateParams) ->
					$stateParams.id
				resources: 'resources'
				
				model: (resources, id) ->
					ret = new resources.BusinessProcess({id: id})
					ret.$fetch()			
		
		$stateProvider.state 'app.list',
			url: "/businessProcess/list"
			cache: false
			views:
				'menuContent':
					templateUrl: "templates/businessProcess/list.html"
					controller: 'BusinessProcessListCtrl'
			resolve:
				resources: 'resources'	
				collection: (resources) ->
					ret = new resources.BusinessProcessList()
					ret.$fetch()
						
		$urlRouterProvider.otherwise('/businessProcess/list')
