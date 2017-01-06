env = require './env.coffee'

require './model.coffee'

angular.module 'starter.controller', [ 'ionic', 'http-auth-interceptor', 'ngCordova',  'starter.model', 'platform']

	.controller 'MenuCtrl', ($scope) ->
		$scope.env = env
		$scope.navigator = navigator

	.controller 'BusinessProcessListCtrl', ($rootScope, $stateParams, $scope, collection, $location, resources, $ionicModal, $filter, FileSaver, Blob) ->
		_.extend $scope,
			
			collection: collection
			
			delete: (item) ->
				collection.remove item

			suspend: (item) ->
				item.suspended = true
				item.$save()
					.then ->
						collection.$refetch()
					.catch (err) ->
						alert {data:{error: "Suspend error."}}	
													
			getFile: (item) ->
				bpModel = new resources.BusinessProcess id: item.deploymentId
				bpModel.$fetch()
					.then (data)->
						downloadtime = $filter("date")(new Date(), "HHmmss")
						src = new Buffer(data).toString('utf8')
						f = new Blob([src], { type: "text/plain;charset=utf-8"})
						FileSaver.saveAs(f, "BusinessProcess#{downloadtime}.bpmn20.xml",true)
						
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
						url: 'api/businessProcess'
						data:
							file: $file

					Upload.upload(opts)
						.then (resp) ->
							$location.url "/businessProcess/list"
						.catch (err) ->
							alert {data:{error: "Upload file error."}}
								
	.controller 'TaskCtrl', ($rootScope, $scope, $location, collection, resources) ->
		_.extend $scope,
			collection: collection
			resources: resources
				
	.controller 'ListProcessinsCtrl', ($rootScope, $stateParams, $scope, collection, $location, resources) ->
		_.extend $scope,
			
			collection: collection
				
			loadMore: ->
				collection.$fetch()
					.then ->
						$scope.$broadcast('scroll.infiniteScrollComplete')
					.catch alert
			
			detail: (item) ->
				$location.url "/workflowtask/#{item.id}"
				
	.controller 'ListProcessinsHistoryCtrl', ($rootScope, $stateParams, $scope, collection, $location, resources) ->
		_.extend $scope,
			
			collection: collection
	
			delete: (item) ->
				collection.remove item
			
			loadMore: ->
				collection.$fetch()
					.then ->
						$scope.$broadcast('scroll.infiniteScrollComplete')
					.catch alert							