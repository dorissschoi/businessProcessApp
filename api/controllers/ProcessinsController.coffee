Promise = require 'bluebird'
actionUtil = require 'sails/lib/hooks/blueprints/actionUtil'

module.exports =
	find: (req, res) ->
		data = actionUtil.parseValues(req)
		activiti.req "get", "#{sails.config.activiti.url.processinshistory}?includeProcessVariables=true&finished=true&start=#{data.skip}"
			.then (task) ->
				val =
					count:		task.body.total
					results:	task.body.data
				sails.log.debug "val: #{JSON.stringify val}"	
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
		