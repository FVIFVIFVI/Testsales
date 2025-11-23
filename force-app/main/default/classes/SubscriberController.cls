public without sharing class SubscriberController {
    @AuraEnabled(cacheable=true)
    public static List<Subscriber__c> getSubscribers(String searchTerm, Boolean includeDisconnected, Integer pageNumber, Integer pageSize) {
        List<String> statuses = new List<String>{'ACTIVE', 'SUSPENDED'};
        if (includeDisconnected) {
            statuses.add('DISCONNECTED');
        }
        String searchPattern = String.isNotBlank(searchTerm) ? '%' + String.escapeSingleQuotes(searchTerm) + '%' : null;
        String query = 'SELECT Id, Name, Country__c, CreatedBy.Name CreatedByName, Data_Used__c, Date_Joined__c, Email__c, LastModifiedBy.Name LastModifiedByName, Owner.Name OwnerName, Phone__c FROM Subscriber__c WHERE (Status__c IN :statuses OR Status__c = null)';
        if (String.isNotBlank(searchTerm)) {
            query += ' AND (Name LIKE :searchPattern OR Phone__c LIKE :searchPattern)';
        }
        query += ' ORDER BY Name LIMIT :pageSize OFFSET :offset';
        Integer offset = (pageNumber - 1) * pageSize;
        return Database.query(query);
    }

    @AuraEnabled(cacheable=true)
    public static Integer getSubscriberCount(String searchTerm, Boolean includeDisconnected) {
        List<String> statuses = new List<String>{'ACTIVE', 'SUSPENDED'};
        if (includeDisconnected) {
            statuses.add('DISCONNECTED');
        }
        String searchPattern = String.isNotBlank(searchTerm) ? '%' + String.escapeSingleQuotes(searchTerm) + '%' : null;
        String query = 'SELECT COUNT() FROM Subscriber__c WHERE (Status__c IN :statuses OR Status__c = null)';
        if (String.isNotBlank(searchTerm)) {
            query += ' AND (Name LIKE :searchPattern OR Phone__c LIKE :searchPattern)';
        }
        return Database.countQuery(query);
    }
}