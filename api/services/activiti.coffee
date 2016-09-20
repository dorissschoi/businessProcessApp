Promise = require 'bluebird'
		
module.exports =

	req: (method, url, data, opts) ->
		if _.isUndefined opts
			opts = 
				headers:
					Authorization:	"Basic " + new Buffer("#{sails.config.activiti.username}:#{sails.config.activiti.password}").toString("base64")
					'Content-Type': 'application/json'
				json: true

		sails.services.rest[method] {}, url, opts, data

	#curl -X GET  "/repository/deployments/52521/resourcedata/cccar.bpmn20.xml"
	getXML: (url) ->
		opts = 
			headers:
				Authorization:	"Basic " + new Buffer("#{sails.config.activiti.username}:#{sails.config.activiti.password}").toString("base64")
			parse: 'XML'
		
		sails.log.info "getXML url: #{url}"		
		@req "get", url, {}, opts
		
	deployXML: (url, data) ->
		opts = 
			headers:
				Authorization:	"Basic " + new Buffer("#{sails.config.activiti.username}:#{sails.config.activiti.password}").toString("base64")
				'Content-Type': 'multipart/form-data'
			multipart: true
					
		@req "post", url, data, opts
			.then (res) ->
				if res.statusCode != 201  
					sails.log.error JSON.stringify res.body 
