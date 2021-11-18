@RestResource(urlMapping='/Contract/*')
global with sharing class ContractManager {
  
    @HttpPost
    global static Contract createContract() {
        RestRequest request = RestContext.request;
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
       	Contract thisContract = new Contract();
        for(String fieldName : params.keySet()) {
            thisContract.put(fieldName, params.get(fieldName));}
        insert thisContract;
        return thisContract;
    }
   
    @HttpPatch
    global static ID updateContractFields() {
        RestRequest request = RestContext.request;
        String contractId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);
        Contract thisContract = [SELECT Id FROM Contract WHERE Id = :contractId];
        // Deserialize the JSON string into name-value pairs
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
        // Iterate through each parameter field and value
        for(String fieldName : params.keySet()) {
            // Set the field and value on the Case sObject
            thisContract.put(fieldName, params.get(fieldName));
        }
        update thisContract;
        return thisContract.id;
    }   
    
}