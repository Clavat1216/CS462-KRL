ruleset track_trips {
  meta {
    name "echo"
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
      mileage = event:attr("mileage").klog("our trip mileage: ");
    }
    send_directive("trip") with
      trip_length = mileage;
  }
}