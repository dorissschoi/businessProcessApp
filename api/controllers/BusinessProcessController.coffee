Promise = require 'bluebird'
fs = require 'fs'
actionUtil = require 'sails/lib/hooks/blueprints/actionUtil'
create = require 'sails/lib/hooks/blueprints/actions/create'

getDeploymentDetails = (procDef) ->
	sails.models.businessprocess
		.find({deploymentId: procDef.deploymentId})
		.then (rst) ->
			activiti.req 'get', sails.config.activiti.url.deployment procDef.deploymentId
				.then (result) ->
					if rst.length > 0
						rst[0].deploymentDetails = result.body
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
				activiti.defList obj.deploymentId
			.then (task) ->
				sails.log.debug "Del process def: #{JSON.stringify task.body.data[0].id}"
				activiti.existIns task.body.data[0].id
			.then (cnt) ->
				if cnt.body.total ==0
					Model.destroy(pk)
						.then (delRecord) ->
							sails.log.debug "deploymentId: #{delRecord[0].deploymentId}"
							activiti.delDeployment delRecord[0].deploymentId
							res.ok delRecord
				else
					res.serverError	"Process definition contain running instance"		
			.catch (err) ->
				sails.log.error err
    	
		
	deploy: (req, res) ->
		fileOpts = 
			saveAs: req.file('file')._files[0].stream.filename
			dirname: require('path').resolve(sails.config.appPath, 'uploads')
						 
		req.file('file').upload fileOpts, (err, files) ->
			if err
				return res.serverError(err)
			data = 
				file: { file: files[0].fd, content_type: 'multipart/form-data' }
			activiti.deployXML "#{sails.config.activiti.url.deployment ''}", data
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
		activiti.req "get", "#{sails.config.activiti.url.processdeflist}?category=http://activiti.org/test&start=#{data.skip}"
			.then (processdefList) ->
				Promise.all _.map processdefList.body.data, getDeploymentDetails
			.then (result) ->
				val =
					count:		result.length
					results:	result
				res.ok(val)
			.catch res.serverError	
			
	getXML: (req, res) ->
		data = actionUtil.parseValues(req)
		activiti.req 'get', "#{sails.config.activiti.url.deployment data.deploymentId}/resources"
			.then (processdefList) ->
				result = _.findWhere(processdefList.body,{type: 'processDefinition'})
				activiti.getXML "#{sails.config.activiti.url.deployment data.deploymentId}/resourcedata/#{result.id}"
			.then (stream) ->
				res.ok(stream.raw)
			.catch res.serverError	