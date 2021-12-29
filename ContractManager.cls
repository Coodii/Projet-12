@IsTest
private class ContractManagerTest {
    
    @testSetup
    static void createTestRecord() {
        Account acc1 = new Account(Name = 'TestAccount');
        insert acc1;
        // Create test record
        Contract contractTest = new Contract(Status='Draft', AccountID= acc1.id);
        insert contractTest;
    }     
    
    /**
 	@description This method tests the createContract method of ContractManager
 	*/
    @isTest static void testCreateContract() {
     	RestRequest request = new RestRequest();
        request.requestUri =
            'https://yourInstance.my.salesforce.com/services/apexrest/Contracts/';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        Contract testContract = [SELECT Id, Status, AccountID, StartDate FROM Contract LIMIT 1];
        request.requestBody = Blob.valueOf('{"status": "Draft", "accountId":"'+ testContract.AccountID +'","startDate":"2021-10-12" }');
        RestContext.request = request;
        Test.startTest();
        Contract thisContract = ContractManager.createContract();
        Test.stopTest();
        // Verify results
        System.assert(thisContract != null);
        System.assertEquals(thisContract.Status, 'Draft');
    }
    
    /**
 	@description This method tests the updateContractFields method of ContractManager
 	*/
    @isTest static void testUpdateContractFields() {
        Contract testContract = [SELECT Id, Status, AccountID, StartDate FROM Contract LIMIT 1];
     	RestRequest request = new RestRequest();
        request.requestUri =
            'https://yourInstance.my.salesforce.com/services/apexrest/Contracts/' + testContract.id;
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"AccountId":"'+ testContract.AccountId+'","startDate":"2021-10-12"}');
        RestContext.request = request;
        Test.startTest();
        Id thisContractId = ContractManager.updateContractFields();
        Test.stopTest();
        // Verify results
        System.assert(thisContractId != null);
        Contract thisContract = [SELECT Id, Status, AccountID FROM Contract WHERE Id=:thisContractId];
        System.assertEquals(thisContract.accountid, testContract.accountid);
 		System.assertEquals(thisContract.id, testContract.id);
        System.assertEquals(thisContract.status, 'Draft');
    }
}
