Promise = require 'bluebird'
actionUtil = require 'sails/lib/hooks/blueprints/actionUtil'
activiticlient = require 'activiti-client'

module.exports =
	find: (req, res) ->
		data = actionUtil.parseValues(req)
		activiticlient.instance.historyProclist data.skip
			.then (rst) ->
				res.ok(rst)
			.catch res.serverError
				
	destroy: (req, res) ->
		pk = actionUtil.requirePk req
		activiticlient.instance.delhistoryProc pk
			.then (rst) ->
				if rst.statusCode == 404
					res.notFound() 
				else
					res.ok()
			.catch res.serverError
		