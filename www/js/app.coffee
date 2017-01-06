env = require './env.coffee'

angular.module 'starter', ['ngFancySelect', 'ionic', 'util.auth', 'starter.controller', 'starter.model', 'http-auth-interceptor', 'ngTagEditor', 'ActiveRecord', 'ngFileUpload', 'ngFileSaver', 'ngTouch', 'ngAnimate', 'pascalprecht.translate', 'locale']
	
	.run (authService) ->
		authService.login env.oauth2.opts
	        
	.run ($rootScope, platform, $ionicPlatform, $location, $http) ->
		$ionicPlatform.ready ->
			if (window.cordova && window.cordova.plugins.Keyboard)
				cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true)
			if (window.StatusBar)
				StatusBar.styleDefault()

	.run ($rootScope, $ionicModal) ->
		$rootScope.$on 'activitiImg', (event, inImg) ->
			_.extend $rootScope,
				imgUrl: inImg
			
			$ionicModal.fromTemplateUrl 'templates/modal.html', scope: $rootScope
				.then (modal) ->
					modal.show()
					$rootScope.modal = modal
																
	.config ($stateProvider, $urlRouterProvider, $translateProvider) ->
	
		$stateProvider.state 'app',
			url: ""
			abstract: true
			templateUrl: "templates/menu.html"
	
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
		
		$stateProvider.state 'app.history',
			url: "/processins/history"
			cache: false
			views:
				'menuContent':
					templateUrl: "templates/processins/historyList.html"
					controller: 'ListProcessinsHistoryCtrl'
			resolve:
				resources: 'resources'	
				collection: (resources) ->
					ret = new resources.ProcessinsHistoryList()
					ret.$fetch()

		$stateProvider.state 'app.insList',
			url: "/processins/insList"
			cache: false
			views:
				'menuContent':
					templateUrl: "templates/processins/list.html"
					controller: 'ListProcessinsCtrl'
			resolve:
				resources: 'resources'	
				collection: (resources) ->
					ret = new resources.ProcessinsList()
					ret.$fetch()

		$stateProvider.state 'app.listTask',
			url: "/workflowtask/:id"
			cache: false
			views:
				'menuContent':
					templateUrl: "templates/workflowtask/list.html"
					controller: 'TaskCtrl'
			resolve:
				id: ($stateParams) ->
					$stateParams.id
				resources: 'resources'
				collection: (resources, id) ->
					ret = new resources.WorkflowTaskList 
					ret.$fetch params: {procInsId: id, sort: 'createdAt DESC'}
																			
		$urlRouterProvider.otherwise('/businessProcess/list')
