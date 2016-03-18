ruleset echo {
  meta {
    name "echo"
    description <<
A simple echo server
>>
    author "Joe Lyon"
    logging on
    sharing on
    provides users
 
  }
  global {
    hello = function(obj) {
      msg = "Hello " + obj
      msg
    };

    users = function(){
        users = ent:name;
        users
    };
    name = function(id){
        all_users = users();
        first = all_users{[id, "name", "first"]}.defaultsTo("HAL", "could not find user. ");
        last = all_users{[id, "name" , "last"]}.defaultsTo("9000", "could not find user. ");
        name = first + " " + last; 
        name;
    };

    user_by_name = function(full_name){
      all_users = users();
      filtered_users = all_users.filter( function(user_id, val){
        constructed_name = val{["name","first"]} + " " + val{["name","last"]};
        (constructed_name eq full_name);
        });
      user = filtered_users.head().klog("matching user: "); // default to default user from previous steps. 
      user
    };
  }

  rule hello {
    select when echo hello
    send_directive("say") with
      something = "Hello World";
  }

  rule message {
    select when echo message
    pre{
      input = event:attr("input").klog("our pass in Id: ");
    }
    {
      send_directive("say") with
          something = input;
    }
  }
}