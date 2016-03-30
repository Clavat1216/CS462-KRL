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
  }

  rule create_vehicle{
    select when car new_vehicle
    pre{
      child_name = event:attr("name");
      attr = {}
                              .put(["Prototype_rids"],"<child rid as a string>") // ; separated rulesets the child needs installed at creation
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
}