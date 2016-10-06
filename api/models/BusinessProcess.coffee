 # BusinessProcess.coffee
 #
 # @description :: TODO: You might write a short summary of how this model works and what it represents here.
 # @docs        :: http://sailsjs.org/documentation/concepts/models-and-orm/models

				
module.exports =
	tableName:		'businessprocess'
  
	schema: 		true
  
	attributes:

		deploymentId:
			type: 		'string'
			required:	true

		deploymentTime:
			type: 'datetime'
  
		filename:
			type: 		'string'
			required:	true
			
		createdBy:
			type:	'string'	