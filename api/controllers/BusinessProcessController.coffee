Promise = require 'bluebird'
actionUtil = require 'sails/lib/hooks/blueprints/actionUtil'
create = require 'sails/lib/hooks/blueprints/actions/create'
			
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
				
					