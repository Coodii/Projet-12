@RestResource(urlMapping='/Contract/*')
global with sharing class ContractManager {

    /**
 	@description This method modifies the fields of a contract
	@return The id of the contract
 	*/
    @HttpPatch
    global static ID updateContractFields() {
        RestRequest request = RestContext.request;
        String contractId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);
        Contract thisContract = [SELECT Id FROM Contract WHERE Id = :contractId];
        // Deserialize the JSON string into name-value pairs
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
        for(String fieldName : params.keySet()) {
            //Cast the string 'startDate' to date
            if (fieldName == 'startDate'){
                String startDate = (String)params.get(fieldName);
                List<String> dateArray= startDate.split('-');
                Date newdate = date.newInstance(integer.valueOf(dateArray[0]), integer.valueOf(dateArray[1]), integer.valueOf(dateArray[2]));
                thisContract.put(fieldName, newdate);
            } else { 
                thisContract.put(fieldName, params.get(fieldName));
            }
        }
        update thisContract;
        return thisContract.id;
    }
    
    /**
 	@description This method creates a new contract
	@return The contract object
 	*/
    @HttpPost
    global static Contract createContract() {
        RestRequest request = RestContext.request;
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
        Contract thisContract = new Contract();
        for(String fieldName : params.keySet()) {
            if(fieldName == 'startDate'){
                String startDate = (String)params.get(fieldName);
                List<String> dateArray= startDate.split('-');
                Date newdate = date.newInstance(integer.valueOf(dateArray[0]), integer.valueOf(dateArray[1]), integer.valueOf(dateArray[2]));
                thisContract.put(fieldName, newdate);
            } else { 
                thisContract.put(fieldName, params.get(fieldName));
            }
        }
        insert thisContract;
        return thisContract;
    }
}
