ruleset track_trips {
  meta {
    name "track_trips"
    description <<
Trip tracker
>>
    author "Joe Lyon"
    logging on
    sharing on
    provides users
 
  }
  global {
  }

  rule process_trip {
    select when echo message
    pre{
      mileage = event:attr("mileage").defaultsTo(0 ,"no mileage passed in.");
    }
    send_directive("trip") with
      trip_length = mileage;
  }
}