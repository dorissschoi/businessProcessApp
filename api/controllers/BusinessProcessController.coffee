Promise = require 'bluebird'
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
						 
		req.file('file').upload fileOpts, (err, files) ->
			if err
				return res.serverError(err)

			data = 
				file: { file: files[0].fd, content_type: 'multipart/form-data' }
			
			activiti.deployXML "#{sails.config.activiti.url.deployment ''}", data
				.then (rst) ->
					res.ok(rst)
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

	getDiagram: (req, res) ->
		data = actionUtil.parseValues(req)
		activiti.req 'get', "#{sails.config.activiti.url.deployment data.deploymentId}/resources"
			.then (processdefList) ->
				result = _.findWhere(processdefList.body,{type: 'resource'})
				activiti.getProcDefDiagram "#{sails.config.activiti.url.deployment data.deploymentId}/resourcedata/#{result.id}"
					.then (stream) ->
						res.ok(stream.raw)
			.catch res.serverError	
			
	getXML: (req, res) ->
		data = actionUtil.parseValues(req)
		activiti.req 'get', "#{sails.config.activiti.url.deployment data.deploymentId}/resources"
			.then (processdefList) ->
				result = _.findWhere(processdefList.body,{type: 'processDefinition'})
				activiti.getXML result.contentUrl
					.then (stream) ->
						res.ok(stream.raw)
			.catch res.serverError	