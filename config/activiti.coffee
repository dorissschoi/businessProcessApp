serverurl = "http://activiti:8080/activiti-rest/service"

module.exports.activiti =
	
	url:
		processinshistory: "#{serverurl}/history/historic-process-instances"
		processinslist: "#{serverurl}/runtime/process-instances"
		processdeflist: "#{serverurl}/repository/process-definitions"
		runninglist: "#{serverurl}/runtime/tasks"
		queryinslist: "#{serverurl}/query/process-instances"
		deployment: (id) ->
			"#{serverurl}/repository/deployments/#{id}"
			
	username:	'kermit'
	password:	'kermit'
