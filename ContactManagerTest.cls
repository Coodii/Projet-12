@IsTest
private class ContactManagerTest { 
    
    @testSetup
    static void createTestRecord() {
        // Create test record
        Contact contactTest = new Contact(
            FirstName='Jean',
            LastName='Dupont',
            Email='jd@hotmail.fr'
            );
        insert contactTest;
    } 
     
    /**
 	@description This method tests the deleteContact method of ContactManager
 	*/
     @isTest static void testDeleteContact() {
        Contact testContact = [SELECT Id, Actif__c FROM Contact LIMIT 1];
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://yourInstance.my.salesforce.com/services/apexrest/Contacts/'
            + testContact.id;
        request.httpMethod = 'DELETE';
        RestContext.request = request;
        // Call the method to test
        Contact thisContact = ContactManager.deleteContact();
        System.assertEquals(false, thisContact.Actif__c);
    } 
    
    /**
 	@description This method tests the createContact method of ContractManager
 	*/
    @isTest static void testCreateContact() {
        Contact testContact = [SELECT Id, firstName, LastName, email FROM Contact LIMIT 1];
     	RestRequest request = new RestRequest();
        request.requestUri =
            'https://yourInstance.my.salesforce.com/services/apexrest/Contacts/';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"firstName": "Jean", "LastName": "Dupont", "email": "jd@hotmail.fr" }');
        RestContext.request = request;
        Contact thisContact = ContactManager.createContact();
        System.debug('Contact info: ' + thisContact);
        // Verify results
        System.assert(thisContact != null);
        System.assertEquals(thisContact.id, testContact.id);
        System.assertEquals(thisContact.FirstName, 'Jean');
    }
    
	/**
 	@description This method tests the updateContactFields method of ContactManager
 	*/
    @isTest static void testUpdateContractFields() {
        Contact testContact = [SELECT Id, firstName, LastName, email FROM Contact LIMIT 1];
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
}
