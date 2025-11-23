from simple_salesforce import Salesforce
import pandas as pd
import os

sf = Salesforce(instance_url=os.environ['SALESFORCE_INSTANCE_URL'], session_id=os.environ['SALESFORCE_SESSION_ID'])

query = "SELECT Id, Name, Status__c, Phone__c, Data_Used__c, Country__c, Date_Joined__c, Email__c, CreatedBy.Name, LastModifiedBy.Name, Owner.Name FROM Subscriber__c"
records = sf.query_all(query)['records']

if records:
    clean_records = [{k: v for k, v in record.items() if k != 'attributes'} for record in records]
    df = pd.DataFrame(clean_records)
    df.to_csv('all_subscribers.csv', index=False)
    print(f"Imported {len(records)} records to all_subscribers.csv")
    
    print("Printing records:")
    for record in clean_records:
        print(f"Name: {record.get('Name', 'N/A')}, Status: {record.get('Status__c', 'N/A')}, LastModifiedBy: {record.get('LastModifiedBy', {}).get('Name', 'N/A')}")
else:
    print("No records found")