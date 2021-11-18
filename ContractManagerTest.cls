@IsTest
private class ContractManagerTest {
    
    @isTest static void testCreateContract() {
     	RestRequest request = new RestRequest();
        request.requestUri =
            'https://yourInstance.my.salesforce.com/services/apexrest/Contracts/';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"status": "Draft", "accountId": "0017Q000003wAEmQAM" }');
        RestContext.request = request;
        Contract thisContract = ContractManager.createContract();
        // Verify results
        System.assert(thisContract != null);
        System.assertEquals(thisContract.Status, 'Draft');
    }
    
    
    @isTest static void testUpdateContract() {
        Contract testContract = createTestRecord();
     	RestRequest request = new RestRequest();
        request.requestUri =
            'https://yourInstance.my.salesforce.com/services/apexrest/Contracts/' + testContract.id;
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        date newDate = date.newInstance(2022, 11, 16);
        request.requestBody = Blob.valueOf('{"AccountId" : "0017Q000003wAEmQAM" }');
        RestContext.request = request;
        Id thisContractId = ContractManager.updateContractFields();
        // Verify results
        System.assert(thisContractId != null);
        Contract thisContract = [SELECT Id, Status, AccountID FROM Contract WHERE Id=:thisContractId];
        System.assert(thisContract.accountid != testContract.accountid);
 		System.assertEquals(thisContract.id, testContract.id);
        System.assertEquals(thisContract.status, 'Draft');
    }
   
    // Helper method
    static Contract createTestRecord() {
        Account acc1 = new Account(Name = 'TestAccount');
        insert acc1;
        // Create test record
        Contract contractTest = new Contract(
            Status='Draft',
            AccountID= acc1.id,
            StartDate = Date.today()
            );
        insert contractTest;
        return contractTest;
    }          
}