ruleset track_trips_2 {
  meta {
    name "track_trips_2"
    description <<
Trip tracker
>>
    author "Joe Lyon"
    logging on
    sharing on
    provides users
 
  }
  global {
    long_trip = 100;
  }

  rule process_trip {
    select when car new_trip
    pre{
      miles = event:attr("mileage").defaultsTo(0 ,"no mileage passed in.");
    }
    {
      send_directive("trip") with
        trip_length = miles;
    }
    always {
      raise explicit event trip_processed with 
        mileage = miles;
    }
  }

  rule find_long_trips {
    select when explicit trip_processed
    pre{
      miles = event:attr("mileage").defaultsTo(0, "no mileage passed in.");
    }
    if ( miles > long_trip ) then {
      noop();
    }
    fired {
      log "Long: " + miles;
      raise explicit event found_long_trip with
        mileage = miles;
    }
  }
}