@isTest
private class LeadTriggerHandler_Test {
    
    @isTest
    static void testBotScriptChangeToEj90() {
        Lead testLead = new Lead(
            FirstName = 'John',
            LastName = 'Doe',
            Phone = '123-456-7890',
            Email = 'john.doe@example.com',
            Company = 'Test Company'
        );
        insert testLead;
        
        Test.startTest();
        
        testLead.Bot_Script__c = 'ej90';
        update testLead;
        
        Test.stopTest();
        
       
        Lead updatedLead = [SELECT Bot_Script__c FROM Lead WHERE Id = :testLead.Id];
        System.assertEquals('ej90', updatedLead.Bot_Script__c);
    }
    
    @isTest
    static void testBotScriptChangeToOtherValue() {
        Lead testLead = new Lead(
            FirstName = 'Jane',
            LastName = 'Smith',
            Phone = '098-765-4321',
            Email = 'jane.smith@example.com',
            Company = 'Another Company'
        );
        insert testLead;
        
        Test.startTest();
        
        testLead.Bot_Script__c = 'ej100';
        update testLead;
        
        Test.stopTest();
        
        Lead updatedLead = [SELECT Bot_Script__c FROM Lead WHERE Id = :testLead.Id];
        System.assertEquals('ej100', updatedLead.Bot_Script__c);
    }
}
