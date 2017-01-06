Promise = require 'bluebird'
actionUtil = require 'sails/lib/hooks/blueprints/actionUtil'


module.exports =
	find: (req, res) ->
		data = actionUtil.parseValues(req)
		activiti.task.listHistory data.procInsId, data.skip  
			.then (rst) ->
				_.each rst.results, (record) ->
					#console.log "record: #{JSON.stringify record}"
					record.owner = _.findWhere(record.variables, {name: "taskownedBy"})
					
				res.ok(rst)
			.catch res.serverError
	