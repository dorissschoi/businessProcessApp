module.exports =
		
	isCreator: (user, todo) ->
		todo?.createdBy == user?.username
		
	isOwner: (user, todo) ->
		todo?.ownedBy == user?.username

	