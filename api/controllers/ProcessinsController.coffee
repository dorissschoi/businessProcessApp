Promise = require 'bluebird'
actionUtil = require 'sails/lib/hooks/blueprints/actionUtil'

getTaskDetail = (record) ->	
	activiti.req "get", "#{sails.config.activiti.url.processdeflist}/#{record.processDefinitionId}"
		.then (task) ->
			_.extend record,
				name: task.body.name	
				key: task.body.key
				version: task.body.version
			return record
				
module.exports =
	find: (req, res) ->
		data = actionUtil.parseValues(req)
		activiti.req "get", "#{sails.config.activiti.url.processinshistory}?includeProcessVariables=true&finished=true&start=#{data.skip}"
			.then (task) ->
				Promise.all  _.map task.body.data, getTaskDetail
			.then (result) ->		
				val =
					count:		result.length
					results:	result
				res.ok(val)
			.catch res.serverError
				
	destroy: (req, res) ->
		pk = actionUtil.requirePk req
		
		sails.log.debug "remove url: #{sails.config.activiti.url.processinshistory}/#{pk}"
		activiti.req "delete", "#{sails.config.activiti.url.processinshistory}/#{pk}"
			.then (rst) ->
				if rst.statusCode == 404
					res.notFound() 
				else
					res.ok()
			.catch res.serverError
		