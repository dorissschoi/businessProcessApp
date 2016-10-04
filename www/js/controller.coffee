env = require './env.coffee'

require './model.coffee'

angular.module 'starter.controller', [ 'ionic', 'http-auth-interceptor', 'ngCordova',  'starter.model', 'platform']

	.controller 'MenuCtrl', ($scope) ->
		$scope.env = env
		$scope.navigator = navigator

	.controller 'BusinessProcessListCtrl', ($rootScope, $stateParams, $scope, collection, $location, resources, $ionicModal, $filter) ->
		_.extend $scope,
			
			collection: collection
			
			getFile: (item) ->
				bpModel = new resources.BusinessProcess id: item.deploymentId
				bpModel.$fetch()
					.then (data)->
						$scope.myBlobObject=new Blob([src], { type: "text/xml"})
						
						downloadtime = $filter("date")(new Date(), "HHmmss")
						src = new Buffer(data).toString('utf8')
						url = URL.createObjectURL(new Blob([src], { type: "text/xml"}))
						a = document.createElement('a')
						a.href = url
						a.download = "BusinessProcess#{downloadtime}.xml"
						a.target = '_blank'
						a.click()
						
			loadMore: ->
				collection.$fetch()
					.then ->
						$scope.$broadcast('scroll.infiniteScrollComplete')
					.catch alert
							
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
							$location.url "/businessProcess/list"