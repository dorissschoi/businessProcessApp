Promise = require 'bluebird'
fs = require 'fs'
actionUtil = require 'sails/lib/hooks/blueprints/actionUtil'
create = require 'sails/lib/hooks/blueprints/actions/create'

getDeploymentDetails = (procDef) ->
	activiti.req 'get', sails.config.activiti.url.deployment procDef.deploymentId
		.then (result) ->
			procDef.deploymentDetails = result.body
			return procDef
		.catch (err) ->
			sails.log.error err
						
module.exports = 
		
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
					sails.log.info "Del file: #{files[0].fd}"
					fs.unlinkSync "#{files[0].fd}"
							
					data =
						deploymentId:	rst.body.id
						deploymentTime:	rst.body.deploymentTime
						filename:		rst.body.name
						createdBy:		req.user.username
					sails.models.businessprocess.create(data)
						.then (newInstance) ->
							res.ok newInstance

				.catch res.serverError
				
	find: (req, res) ->
		data = actionUtil.parseValues(req)
		activiti.req "get", "#{sails.config.activiti.url.processdeflist}&start=#{data.skip}"
			.then (processdefList) ->
				Promise.all _.map processdefList.body.data, getDeploymentDetails
					.then (result) ->
						val =
							count:		processdefList.body.total
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