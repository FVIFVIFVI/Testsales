from simple_salesforce import Salesforce

# התחברות ל-Salesforce עם access token
sf = Salesforce(instance_url='https://orgfarm-d68b97b2a5-dev-ed.develop.my.salesforce.com', session_id='YOUR_SESSION_ID_HERE')

# תיאור האוביקט Subscriber__c
metadata = sf.Subscriber__c.describe()

# הדפסת שמות השדות וסוגיהם עם פרטים נוספים
print("Field Names and Types for Subscriber__c:")
for field in metadata['fields']:
    print(f"Name: {field['name']}, Type: {field['type']}")
    if field['type'] == 'picklist' and 'picklistValues' in field:
        values = [pv['value'] for pv in field['picklistValues'] if pv['active']]
        print(f"  Picklist Values: {values}")
    if field['type'] == 'reference' and 'referenceTo' in field:
        print(f"  References: {field['referenceTo']}")
    print()  # רווח בין שדות