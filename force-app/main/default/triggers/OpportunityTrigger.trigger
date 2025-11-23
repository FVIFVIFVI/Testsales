trigger OpportunityTrigger on Opportunity (after insert, after update) {
    if (Trigger.isAfter) { 
        OpportunityTriggerHandler.rollupOpportunityAmount(Trigger.new);
    }
}