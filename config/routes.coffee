module.exports = 
	routes:
	
		'GET /api/businessProcess/:deploymentId':
			controller:		'BusinessProcessController'
			action:			'getXML'

		'GET /api/processinsHistory':
			controller:		'ProcessinsController'
			action:			'history'
