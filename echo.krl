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
  }

  rule hello {
    select when echo hello
    send_directive("say") with
      something = "Hello World";
  }

  rule message {
    select when echo message
    pre{
      input = event:attr("input").defaultsTo("","no name passed.");
    }
    {
      send_directive("say") with
          something = input;
    }
  }
}