@isTest
private class OpportunityTriggerHandler_Test {
    
    @isTest
    static void testRollupOpportunityAmount() {
        
        Account testAccount = new Account(Name = 'Test Account for Rollup');
        insert testAccount;
        
        List<Opportunity> opps = new List<Opportunity>();
        opps.add(new Opportunity(
            Name = 'Opp 1', 
            StageName = 'Prospecting', 
            CloseDate = Date.today().addDays(30),
            Amount = 100.00,
            AccountId = testAccount.Id
        ));
        opps.add(new Opportunity(
            Name = 'Opp 2', 
            StageName = 'Prospecting', 
            CloseDate = Date.today().addDays(30),
            Amount = 200.00,
            AccountId = testAccount.Id
        ));
        
        Test.startTest();
        
        insert opps;
        
        opps[0].Amount = 150.00;
        
        update opps;
        
        Test.stopTest();
        
        Account updatedAccount = [SELECT Total_Opportunities__c FROM Account WHERE Id = :testAccount.Id LIMIT 1];
        
        System.assertEquals(350.00, updatedAccount.Total_Opportunities__c, 'Total Amount should be 350.00');
    }
}