trigger LeadTrigger on Lead (after update) {
    if (Trigger.isAfter) {
        for (Lead newLead : Trigger.new) {
            Lead oldLead = Trigger.oldMap.get(newLead.Id);
            if (oldLead.Bot_Script__c != newLead.Bot_Script__c && newLead.Bot_Script__c == 'ej90') {
                LeadTriggerHandler.handleBotScriptChange(newLead);
                break; 
            }
        }
    }
}