ruleset hello_world {
	meta {
		name "Hello World"
		description <<
A frist ruleset for the Quickstart
>>
	author "Joe Lyon"
	logging on
	sharing on
	provides hello

	}
	global {
		hello = function(obj) {
			msg = "Hello " + obj
			msg
		};

	}
	rule hello_world {
		select when echo hello
		send_direcetive("say") with
			something = "Hello World";
	}
}
