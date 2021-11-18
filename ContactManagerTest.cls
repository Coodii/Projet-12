@IsTest
private class ContactManagerTest {

    @isTest static void testCreateContactWithExistingEmail() {
        Contact testContact = createTestRecord();
     	RestRequest request = new RestRequest();
        request.requestUri =
            'https://yourInstance.my.salesforce.com/services/apexrest/Contacts/';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"firstName": "Jean", "LastName": "Dupont", "email": "jd@hotmail.fr" }');
        RestContext.request = request;
        Contact thisContact = ContactManager.createContact();
        // Verify results
        System.assert(thisContact != null);
        System.assertEquals(thisContact.id, testContact.id);
        System.assertEquals(thisContact.FirstName, 'Jean');
    }
        
    @isTest static void testUpdateContract() {
        Contact testContact = createTestRecord();
     	RestRequest request = new RestRequest();
        request.requestUri =
            'https://yourInstance.my.salesforce.com/services/apexrest/Contacts/' + testContact.id;
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"firstName": "Michel", "LastName": "Dupont", "email": "jd@hotmail.fr" }');
        RestContext.request = request;
        Id thisContactId = ContactManager.updateContactFields();
        // Verify results
        System.assert(thisContactId != null);
        Contact thisContact = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE Id=:thisContactId];
        System.assert(thisContact !=null);
        System.assertEquals(thisContact.FirstName, 'Michel');
    }
   
    // Helper method
    static Contact createTestRecord() {
        // Create test record
        Contact contactTest = new Contact(
            FirstName='Jean',
            LastName='Dupont',
            Email='jd@hotmail.fr'
            );
        insert contactTest;
        return contactTest;
    }          
}