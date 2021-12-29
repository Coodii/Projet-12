@RestResource(urlMapping='/Contact/*')
global with sharing class ContactManager {
        
    /**
 	@description This method creates a contact if the email field does not exist.
	If it exists, the contact will be updated with the new fields.
	@return The contact
 	*/
    @HttpPost
    global static Contact createContact() {
        RestRequest request = RestContext.request;
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
        Contact thisContact = new Contact();
        for(String fieldName : params.keySet()) {
            thisContact.put(fieldName, params.get(fieldName));
        }
        upsert thisContact Email;
        return thisContact;
    }
    
    /**
 	@description This method modifies the fields of a contact
	@return The contact id
 	*/
    @HttpPatch
    global static ID updateContactFields() {
        RestRequest request = RestContext.request;
        String contactId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);
        Contact thisContact = [SELECT Id FROM Contact WHERE Id = :contactId];
        // Deserialize the JSON string into name-value pairs
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
        // Iterate through each parameter field and value
        for(String fieldName : params.keySet()) {
            // Set the field and value on the Contact sObject
            thisContact.put(fieldName, params.get(fieldName));
        }
        update thisContact;
        return thisContact.id;
    }
    
    /**
 	@description This method changes the 'Actif' status of the contact deleted to false.
	@return The contact
 	*/
    @HttpDelete
    global static Contact deleteContact() {
        RestRequest request = RestContext.request;
        String contactId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);
        Contact thisContact = [SELECT Id FROM Contact WHERE Id = :contactId];
        thisContact.Actif__c = false;
        update thisContact;
        return thisContact;
    }         
}
