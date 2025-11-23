from simple_salesforce import Salesforce
import pandas as pd

# התחברות ל-Salesforce עם access token
sf = Salesforce(instance_url='https://orgfarm-d68b97b2a5-dev-ed.develop.my.salesforce.com', session_id='YOUR_SESSION_ID_HERE')

# ייבוא כל הרשומות עם כל השדות
query = "SELECT Id, Name, Status__c, Phone__c, Data_Used__c, Country__c, Date_Joined__c, Email__c, CreatedBy.Name, LastModifiedBy.Name, Owner.Name FROM Subscriber__c"
records = sf.query_all(query)['records']

# שמירת הרשומות לקובץ CSV
if records:
    # הסרת השדה attributes
    clean_records = [{k: v for k, v in record.items() if k != 'attributes'} for record in records]
    df = pd.DataFrame(clean_records)
    df.to_csv('all_subscribers.csv', index=False)
    print(f"Imported {len(records)} records to all_subscribers.csv")
    
    # הדפסת הרשומות (Name and Status__c)
    print("Printing records:")
    for record in clean_records:
        print(f"Name: {record.get('Name', 'N/A')}, Status: {record.get('Status__c', 'N/A')}, LastModifiedBy: {record.get('LastModifiedBy', {}).get('Name', 'N/A')}")
else:
    print("No records found")