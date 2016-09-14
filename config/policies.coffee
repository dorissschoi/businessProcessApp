
module.exports = 
	policies:
		BusinessProcessController:
			'*':		false
			find:		['isAuth']	
			findOne:	['isAuth']			
			create: 	['isAuth']
			update: 	['isAuth']
			destroy: 	['isAuth']
			'deploy':	['isAuth']
			getXML:		['isAuth']
		UserController:
			'*':		false
			find:		true
			findOne:	['isAuth', 'user/me']
