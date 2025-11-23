public with sharing class LeadTriggerHandler {
    public static void handleBotScriptChange(Lead changedLead){
        if (changedLead.Bot_Script__c == 'ej90') {
            sendLeadDataToEndpoint(changedLead.Id);
        }

    }
    
    @future(callout=true)
    public static void sendLeadDataToEndpoint(Id leadId) {
        Lead lead = [SELECT FirstName, LastName, Phone, Email FROM Lead WHERE Id = :leadId LIMIT 1];
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://httpbin.org/post'); 
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        
        String body = JSON.serialize(new Map<String, Object>{
            'firstName' => lead.FirstName,
            'lastName' => lead.LastName,
            'phone' => lead.Phone,
            'email' => lead.Email
        });
        request.setBody(body);
        
        try {
            HttpResponse response = http.send(request);
            System.debug('Response: ' + response.getBody());
        } catch (Exception e) {
            System.debug('Callout error: ' + e.getMessage());
        }
    }
    }
