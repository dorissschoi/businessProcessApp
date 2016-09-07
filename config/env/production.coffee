agent = require 'https-proxy-agent'

module.exports =
	hookTimeout:	400000
	
	port:			1337

	oauth2:
		verifyURL:			"https://mob.myvnc.com/org/oauth2/verify/"
		tokenURL:			"https://mob.myvnc.com/org/oauth2/token/"
		scope:				["https://mob.myvnc.com/org/users"]
		
	http:
		opts:
			agent:	new agent("http://proxy1.scig.gov.hk:8080")

	promise:
		timeout:	10000 # ms

	models:
		connection: 'mongo'
		migrate:	'alter'
	
	connections:
		mongo:
			adapter:	'sails-mongo'
			driver:		'mongodb'
			host:		'localhost'
			port:		27017
			user:		''
			password:	''
			database:	'todosails'	
		
	im:
		url: 		"https://mob.myvnc.com/im.app/api/msg"
		client:
			id:		''
			secret: ''
		user:
			id: 	''
			secret: ''
		scope:  	[ "https://mob.myvnc.com/org/users", "https://mob.myvnc.com/mobile"]
		txt:		"one new task"
		digesttxt:	"Overdue task"
		xmpp:
			domain:	'mob.myvnc.com'
		adminjid:	""
		sendmsg:	true #dev not send 
	
	log:
		level: 'silly'
		
			