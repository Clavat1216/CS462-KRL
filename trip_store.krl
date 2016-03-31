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
      t = ent:trips;
      t;
    };
    
    long_trips = function(){
      lt = ent:long_trips;
      lt;
    };

    short_trips = function(){
      st = ent:trips;
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

  rule childToParent {
    select when wrangler init_events
    pre {
       // find parant 
       // place  "use module  b507199x5 alias wrangler_api" in meta block!!
       parent_results = wrangler_api:parent();
       parent = parent_results{'parent'};
       parent_eci = parent[0]; // eci is the first element in tuple 
       attrs = {}.put(["name"],"Family")
                      .put(["name_space"],"Tutorial_Subscriptions")
                      .put(["my_role"],"Child")
                      .put(["your_role"],"Parent")
                      .put(["target_eci"],parent_eci.klog("target Eci: "))
                      .put(["channel_type"],"Pico_Tutorial")
                      .put(["attrs"],"success")
                      ;
    }
    {
     noop();
    }
    always {
      raise wrangler event "subscription"
      attributes attrs;
    }
  }
}