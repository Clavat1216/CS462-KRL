ruleset manage_fleet {
  meta {
    name "manage_fleet"
    description <<
Fleet manager`
>>
    author "Joe Lyon"
    logging on
    sharing on
    provides users
 
  }
  global {
    long_trip = 100;

    vehicles = function(){
      //TODO - return vehicles
      long_trip;
    }
  }

  rule create_vehicle{
    select when car new_vehicle
    pre{
      child_name = event:attr("name");
      attr = {}
                              .put(["Prototype_rids"],"b507747x4.prod") // ; separated rulesets the child needs installed at creation
                              .put(["name"],child_name) // name for child_name
                              .put(["parent_eci"],parent_eci) // eci for child to subscribe
                              ;
    }
    {
      noop();
    }
    always{
      raise wrangler event "child_creation"
      attributes attr.klog("attributes: ");
      log("create child for " + child);
    }
  }

  rule autoAccept {
    select when wrangler inbound_pending_subscription_added 
    pre{
      attributes = event:attrs().klog("subcription :");
      }
      {
      noop();
      }
    always{
      raise wrangler event 'pending_subscription_approval'
          attributes attributes;        
          log("auto accepted subcription.");
    }
  }

  rule delete_vehicle {
    select when car unneeded_vehicle
    pre{
      vehicle_name = event:attr("name");

    }
    {
      noop();
    }
    always{
      log("removed vehicle");
    }
  }
}



