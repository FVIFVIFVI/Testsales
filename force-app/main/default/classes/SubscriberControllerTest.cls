@IsTest
public class SubscriberControllerTest {
    @TestSetup
    static void makeData() {
        List<Subscriber__c> subscribers = new List<Subscriber__c>();
        subscribers.add(new Subscriber__c(Name='John Doe', Country__c='USA', Data_Used__c=100, Date_Joined__c=Date.today(), Email__c='john@example.com', Phone__c='1234567890', Status__c='ACTIVE'));
        subscribers.add(new Subscriber__c(Name='Jane Smith', Country__c='Canada', Data_Used__c=200, Date_Joined__c=Date.today().addDays(-10), Email__c='jane@example.com', Phone__c='0987654321', Status__c='SUSPENDED'));
        subscribers.add(new Subscriber__c(Name='Bob Johnson', Country__c='UK', Data_Used__c=150, Date_Joined__c=Date.today().addDays(-20), Email__c='bob@example.com', Phone__c='1122334455', Status__c='DISCONNECTED'));
        
        for(Integer i=0; i<15; i++) {
            subscribers.add(new Subscriber__c(
                Name='Bulk Subscriber ' + i, 
                Country__c='USA', 
                Data_Used__c=0, 
                Date_Joined__c=Date.today(), 
                Email__c='bulk'+i+'@example.com', 
                Phone__c='555000'+i, 
                Status__c='ACTIVE'
            ));
        }
        insert subscribers;
    }

    @IsTest
    static void testGetSubscribersWithoutFilter() {
        Test.startTest();
        List<Subscriber__c> result = SubscriberController.getSubscribers(null, false, 1, 10);
        Test.stopTest();
        System.assertEquals(10, result.size(), 'Should return 10 records (page size)');
    }

    @IsTest
    static void testGetSubscribersWithDisconnected() {
        Test.startTest();
        List<Subscriber__c> result = SubscriberController.getSubscribers(null, true, 1, 10);
        Test.stopTest();
        System.assertEquals(10, result.size(), 'Should return 10 records (page size)');
    }

    @IsTest
    static void testGetSubscribersWithSearch() {
        Test.startTest();
        List<Subscriber__c> result = SubscriberController.getSubscribers('John', false, 1, 10);
        Test.stopTest();
        System.assertEquals(1, result.size(), 'Should return 1 subscriber matching name');
        System.assertEquals('John Doe', result[0].Name);
    }

    @IsTest
    static void testGetSubscriberCount() {
        Test.startTest();
        Integer count = SubscriberController.getSubscriberCount(null, false);
        Test.stopTest();
        System.assertEquals(17, count, 'Should count 17 active and suspended subscribers');
    }

    @IsTest
    static void testGetSubscriberCountWithDisconnected() {
        Test.startTest();
        Integer count = SubscriberController.getSubscriberCount(null, true);
        Test.stopTest();
        System.assertEquals(18, count, 'Should count all 18 subscribers');
    }

    @IsTest
    static void testPagination() {
        Test.startTest();
        List<Subscriber__c> page1 = SubscriberController.getSubscribers(null, false, 1, 10);
        System.assertEquals(10, page1.size(), 'Page 1 should have 10 records');
        
        List<Subscriber__c> page2 = SubscriberController.getSubscribers(null, false, 2, 10);
        System.assertEquals(7, page2.size(), 'Page 2 should have 7 records');
        Test.stopTest();
    }

    @IsTest
    static void testSearchByPhone() {
        Test.startTest();
        List<Subscriber__c> result = SubscriberController.getSubscribers('1234567890', false, 1, 10);
        Test.stopTest();
        System.assertEquals(1, result.size(), 'Should find subscriber by phone');
        System.assertEquals('John Doe', result[0].Name, 'Should return the correct subscriber');
    }
}
