module.exports = 
	routes:
	
		'POST /api/businessProcess/deploy':
			controller:		'BusinessProcessController'
			action:			'deploy'
			
		'GET /api/businessProcess/:deploymentId':
			controller:		'BusinessProcessController'
			action:			'getXML'
		