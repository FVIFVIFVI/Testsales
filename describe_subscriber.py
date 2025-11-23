from simple_salesforce import Salesforce
import os

sf = Salesforce(instance_url=os.environ['SALESFORCE_INSTANCE_URL'], session_id=os.environ['SALESFORCE_SESSION_ID'])

metadata = sf.Subscriber__c.describe()

print("Field Names and Types for Subscriber__c:")
for field in metadata['fields']:
    print(f"Name: {field['name']}, Type: {field['type']}")
    if field['type'] == 'picklist' and 'picklistValues' in field:
        values = [pv['value'] for pv in field['picklistValues'] if pv['active']]
        print(f"  Picklist Values: {values}")
    if field['type'] == 'reference' and 'referenceTo' in field:
        print(f"  References: {field['referenceTo']}")
    print()