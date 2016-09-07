env = require './env.coffee'

require './model.coffee'

angular.module 'starter.controller', [ 'ionic', 'http-auth-interceptor', 'ngCordova',  'starter.model', 'platform', 'angular-contextual-date']

	.run (contextualDateService) -> 
		contextualDateService.config.hideFullDate = true

	.controller 'MenuCtrl', ($scope) ->
		$scope.env = env
		$scope.navigator = navigator

	.controller 'BusinessProcessListCtrl', ($rootScope, $stateParams, $scope, collection, $location, resources) ->
		_.extend $scope,
			progress: progress
			
			ownedBy: ownedBy
			
			sortBy: sortBy
			
			collection: collection
		
			edit: (item) ->
				$location.url "/todo/edit/#{item.id}"		
				
			delete: (item) ->
				collection.remove item
			
	.controller 'BusinessProcessCtrl', ($rootScope, $scope, model, $location, me) ->
		_.extend $scope,
			model: model

			selected: _.findWhere(userlist.models,{username: me.username})
			save: ->
				$scope.model.$save()
					.then ->
						$location.url "/todo/weekList?progress=0&ownedBy=me&sort=createdAt"
					.catch (err) ->
						alert {data:{error: "Not authorized to edit."}}					
				
	.filter 'todosFilter', ($ionicScrollDelegate)->
		(collection, search) ->
			if search
				return _.filter collection, (item) ->
					r = new RegExp(search, 'i')
					r.test(item.project) or r.test(item.task) or r.test(item.createdBy.username) or r.test(item.ownedBy.username)
			else
				return collection
				
