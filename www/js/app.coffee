env = require './env.coffee'

angular.module 'starter', ['ngFancySelect', 'ionic', 'util.auth', 'starter.controller', 'starter.model', 'http-auth-interceptor', 'ngTagEditor', 'ActiveRecord', 'ngTouch', 'ngAnimate', 'pascalprecht.translate', 'locale']
	
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
	
		$stateProvider.state 'app.createTodo',
			url: "/businessprocess/create"
			cache: false
			views:
				'menuContent':
					templateUrl: "templates/businessProcess/create.html"
					controller: 'BusinessProcessCtrl'
			resolve:
				resources: 'resources'
				model: (resources) ->
					ret = new resources.BusinessProcess()				
	
		$stateProvider.state 'app.editTodo',
			url: "/businessprocess/edit/:id"
			cache: false
			views:
				'menuContent':
					templateUrl: "templates/businessProcess/edit.html"
					controller: 'BusinessProcessCtrl'
			resolve:
				id: ($stateParams) ->
					$stateParams.id
				resources: 'resources'
				me: (resources) ->
					resources.User.me().$fetch()
				model: (resources, id) ->
					ret = new resources.BusinessProcess({id: id})
					ret.$fetch()			
		
		$stateProvider.state 'app.list',
			url: "/businessprocess/list"
			cache: false
			views:
				'menuContent':
					templateUrl: "templates/businessProcess/list.html"
					controller: 'BusinessProcessListCtrl'
			resolve:
				resources: 'resources'	
				collection: (resources, ownedBy, sortBy, progress) ->
					ret = new resources.BusinessProcessList()
					ret.$fetch({params: {progress: progress, ownedBy: ownedBy, sort: sortBy}})
						
		$urlRouterProvider.otherwise('/businessprocess/list')
		