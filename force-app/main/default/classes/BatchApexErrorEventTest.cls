/**********************************************************************************************
* @Author:      Tirthankar - Salesforce COE 
* @Date:        24th June 20200
* @Description: This test class covers for BatchApexErrorEventTriggerHandler
***********************************************************************************************/
@isTest
public with sharing class BatchApexErrorEventTest {
	static testmethod void testLoadData()
    {
        List<sObject> ls = Test.loadData(Account.sObjectType, 'AccountList');          
        list<Account> accountList = [SELECT Id,Name FROM Account];        
        try
        {                    
            Test.startTest();        
            Database.executeBatch(new PlatformEventBatch(), 2000); 
            Test.getEventBus().deliver(); 
            Test.stopTest();  
        }catch(Exception ee){}
        Test.getEventBus().deliver(); 
        System.assertEquals(1, [SELECT Id FROM Error_Log__c].size());                
    }

    @isTest static void testValidFlowEvent()
    {        
        Test.startTest();        
        list<FlowExecutionErrorEvent> flowErrorEventList = new list<FlowExecutionErrorEvent>();
        flowErrorEventList.add(new FlowExecutionErrorEvent(ErrorMessage = 'Custom Flow Exception',
                                                           FlowApiName = 'TestFlowAPIName')); //publishing a standard flow is not available.
        //This standard flow error event only invoked from screen flow. Thus we cannot use autolauched flow for test coverage.
        FlowExecutionEventTriggerHandler.afterInsert(flowErrorEventList);     
        
        
        Test.stopTest();
        
        list<Error_Log__c> errorLogList = [SELECT Id 
                                          FROM Error_Log__c];
        System.assertEquals(1, errorLogList.size()); 
    }
}