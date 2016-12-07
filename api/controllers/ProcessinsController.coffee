Promise = require 'bluebird'
actionUtil = require 'sails/lib/hooks/blueprints/actionUtil'

module.exports =
	find: (req, res) ->
		data = actionUtil.parseValues(req)
		activiti.instance.listHistory data.skip
			.then (rst) ->
				res.ok(rst)
			.catch res.serverError
				
	destroy: (req, res) ->
		pk = actionUtil.requirePk req
		activiti.instance.deleteHistory pk
			.then (rst) ->
				if rst.statusCode == 404
					res.notFound() 
				else
					res.ok()
			.catch res.serverError
		