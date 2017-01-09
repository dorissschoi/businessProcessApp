Promise = require 'bluebird'
fs = require 'fs'
actionUtil = require 'sails/lib/hooks/blueprints/actionUtil'
create = require 'sails/lib/hooks/blueprints/actions/create'


getDeploymentUser = (procDef) ->
	sails.models.businessprocess
		.find({deploymentId: procDef.deploymentId})
		.then (rst) ->
			if rst.length > 0
				rst[0].definition = procDef 
			return rst[0]
		.catch (err) ->
			sails.log.error err
						
module.exports = 
	destroy: (req, res) ->
		pk = actionUtil.requirePk req
		Model = actionUtil.parseModel req
		
		Model
			.findOne pk
			.populateAll()
			.then (obj) ->
				activiti.definition.findbyDepId obj.deploymentId
			.then (task) ->
				sails.log.debug "Del process def: #{JSON.stringify task.body.data[0].id}"
				activiti.instance.haveTask task.body.data[0].id
			.then (cnt) ->
				if cnt.body.total ==0
					Model.destroy(pk)
						.then (delRecord) ->
							sails.log.debug "deploymentId: #{delRecord[0].deploymentId}"
							activiti.definition.delete delRecord[0].deploymentId
							res.ok delRecord
				else
					res.serverError	"Process definition contain running instance"		
			.catch (err) ->
				sails.log.error err
    	
		
	create: (req, res) ->
		fileOpts = 
			saveAs: req.file('file')._files[0].stream.filename
			dirname: require('path').resolve(sails.config.appPath, 'uploads')
						 
		req.file('file').upload fileOpts, (err, files) ->
			if err
				return res.serverError(err)

			sails.log.debug "upload file: #{files[0].fd}"
			activiti.definition.create files[0].fd
				.then (rst) ->
					if rst.statusCode == 201  
						fs.unlinkSync "#{files[0].fd}"
						data =
							deploymentId:	rst.body.id
							deploymentTime:	rst.body.deploymentTime
							filename:		rst.body.name
							createdBy:		req.user.username
						sails.models.businessprocess.create(data)
							.then (newInstance) ->
								res.ok newInstance
					else
						res.serverError(rst.body)
				.catch res.serverError
				
	find: (req, res) ->
		data = actionUtil.parseValues(req)
		activiti.definition.list data.skip
			.then (processdefList) ->
				Promise.all _.map processdefList.results, getDeploymentUser
				.then (result) ->
					val =
						count:		processdefList.count
						results:	result
					res.ok(val)
			.catch res.serverError	
			
	getXML: (req, res) ->
		data = actionUtil.parseValues(req)
		activiti.definition.getXML data.deploymentId
			.then (stream) ->
				res.ok(stream)
			.catch res.serverError

	update: (req, res) ->
		data = actionUtil.parseValues(req)
		sails.log.debug "update process def: #{JSON.stringify data.definition}"
		input =
			"action": "suspend"
			"includeProcessInstances": "false"
		activiti.definition.suspend data.definition.id, input
			.then (rst) ->	
				sails.log.debug "update : #{JSON.stringify rst.body}"
				res.ok(rst.statusCode)
					
			.catch res.serverError
					
	