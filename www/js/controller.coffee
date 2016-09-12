env = require './env.coffee'

require './model.coffee'

angular.module 'starter.controller', [ 'ionic', 'http-auth-interceptor', 'ngCordova',  'starter.model', 'platform']

	.controller 'MenuCtrl', ($scope) ->
		$scope.env = env
		$scope.navigator = navigator

	.controller 'BusinessProcessListCtrl', ($rootScope, $stateParams, $scope, collection, $location, resources) ->
		_.extend $scope,
			
			collection: collection
		
	.controller 'BusinessProcessCtrl', ($rootScope, $scope, model, $location, Upload) ->
		_.extend $scope,
			model: model
			
			putfile: ($file) ->
				if $file and $file.length != 0
					opts = 
						url: 'api/businessProcess/deploy'
						data:
							file: $file

					Upload.upload(opts)
						.then (resp) ->
							console.log 'Success ' + resp.config.data.file.name + 'uploaded. Response: ' + resp.data
					$location.url "/businessProcess/list"
						
