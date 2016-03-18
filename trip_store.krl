ruleset trip_store {
  meta {
    name "trip_store"
    description <<
Trip tracker
>>
    author "Joe Lyon"
    logging on
    sharing on
    provides trips, long_trips, short_trips
 
  }
  global {
    trips = function(){
      t = "";
      t;
    };
    
    long_trips = function(){
      lt = "";
      lt;
    };

    short_trips = function(){
      st = "";
      st;
    };
  }

  rule collect_trips {
    select when explicit trip_processed
    pre{
      timestamp = time:now();
      miles = event:attr("mileage").defaultsTo(0 ,"no mileage passed in.");
      init = {"_0":{"trip":0}};
    }
    always{
      // Add trip to trips entity variable
      set ent:trips init if not ent:trips{["_0"]};
      set ent:trips{[timestamp, "trip"]} miles;
    }
  }

  rule collect_long_trips {
    select when explicit found_long_trip
    pre{
      timestamp = time:now();
      miles = event:attr("mileage").defaultsTo(0, "no mileage passed in.");
      init = {"_0":{"trip":0}};
    }
    always{
      set ent:long_trips init if not ent:long_trips{["_0"]};
      set ent:long_trips{[timestamp, "trip"]} miles;
    }
  }

  rule clear_trips {
    select when car trip_reset
    always{
      set ent:trips [];
      set ent:long_trips [];
    }
  }
}