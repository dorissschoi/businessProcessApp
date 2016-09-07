module.exports =
	tableName:	'users'
	schema:		true
	autoPK:		false
	attributes:
		url:
			type: 		'string'
			required: 	true
			
		username:
			type: 		'string'
			required: 	true
			primaryKey: true
			
		email:
			type:		'string' 
			required:	true

		#check if user is authorized to edit the specified todo
		isCreator: (todo) ->
			sails.services.user.isCreator(@, todo)

		#check if user is authorized to edit the specified todo
		isOwner: (todo) ->
			sails.services.user.isOwner(@, todo)			
