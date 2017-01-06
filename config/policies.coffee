
module.exports = 
	policies:
		BusinessProcessController:
			'*':		false
			find:		['isAuth']	
			findOne:	['isAuth']			
			create:		['isAuth']
			getXML:		['isAuth']
			destroy: 	['isAuth']
			update:		['isAuth']
		UserController:
			'*':		false
			find:		true
			findOne:	['isAuth', 'user/me']
		ProcessinsController:
			'*':		false
			find:		['isAuth']	
			findOne:	['isAuth']			
			destroy: 	['isAuth']
			history: 	['isAuth']
		WorkflowTaskController:
			'*':		false
			find:		['isAuth']
			findOne:	['isAuth']	