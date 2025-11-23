public with sharing class OpportunityTriggerHandler {
    public static void rollupOpportunityAmount(List<Opportunity> updatedOpportunities) {
        
        Set<Id> accountIds = new Set<Id>();
        for (Opportunity opp : updatedOpportunities) {
            if (opp.AccountId != null) {
                accountIds.add(opp.AccountId);
            }
        }
        
        if (accountIds.isEmpty()) {
            return;
        }

        List<AggregateResult> results = [
            SELECT AccountId, SUM(Amount) totalAmount 
            FROM Opportunity 
            WHERE AccountId IN :accountIds AND IsClosed = FALSE
            GROUP BY AccountId
        ];

        List<Account> accountsToUpdate = new List<Account>();
        
        for (AggregateResult ar : results) {
            Account acc = new Account(Id = (Id)ar.get('AccountId'));
            
            Decimal total = (Decimal)ar.get('totalAmount');
            acc.Total_Opportunities__c = total != null ? total : 0;
            
            accountsToUpdate.add(acc);
        }

        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
}