
module.exports = 
	policies:
		BusinessProcessController:
			'*':		false
			find:		['isAuth']	
			findOne:	['isAuth']			
			deploy:		['isAuth']
			getXML:		['isAuth']
			destroy: 	['isAuth', 'canDestroy']
		UserController:
			'*':		false
			find:		true
			findOne:	['isAuth', 'user/me']
		ProcessinsController:
			'*':		false
			find:		['isAuth']	
			findOne:	['isAuth']			
			destroy: 	['isAuth']
