@RestResource(urlMapping='/Contact/*')
global with sharing class ContactManager {
   
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
            // Set the field and value on the Case sObject
            thisContact.put(fieldName, params.get(fieldName));
        }
        update thisContact;
        return thisContact.id;
    }
    
    @HttpPost
    global static Contact createContact() {
        RestRequest request = RestContext.request;
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
        String email = (String)params.get('Email');
        List<Contact> listContacts = [SELECT Id, FirstName,LastName, Email From Contact WHERE Email=: email];
        Contact thisContact = new Contact();
        for(String fieldName : params.keySet()) {
            thisContact.put(fieldName, params.get(fieldName));
        }
        upsert thisContact Email;
        return thisContact;
    }
}
