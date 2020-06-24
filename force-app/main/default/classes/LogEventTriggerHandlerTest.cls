/**********************************************************************************************
* @Author:      Tirthankar - Salesforce COE 
* @Date:        24th June 20200
* @Description: This test class covers for LogEventTriggerHandler,GenericEventErrorLogger,GenericEventErrorLoggerHelper
***********************************************************************************************/
@isTest
public with sharing class LogEventTriggerHandlerTest {
	@isTest static void testValidLogEvent()
    {
    	Log__e logEventInstance = new Log__e(Component_Name__c = 'Test Component',
                                             Error_Message__c = 'Test Error Message');
        Test.startTest();
        Database.SaveResult sr = EventBus.publish(logEventInstance);
        Test.stopTest();
        System.assertEquals(true, sr.isSuccess());
		System.assertEquals(1, [SELECT Id FROM Error_Log__c].size()); 
    }
    @isTest static void testInValidLogEvent()
    {
        Log__e logEventInstance = new Log__e(Component_Name__c = 'Test Component',
                                             Error_Message__c = 'Test Error Message',
                                             Current_User__c = 'testId');
        Test.startTest();
        try
        {
        	Database.SaveResult sr = EventBus.publish(logEventInstance);    
        }catch(Exception ee){
            GenericEventErrorLogger.publishEventFromException(ee, 'Test Component');
        }
        try
        {
        	Account accountInstance;
            accountInstance.Name = 'Test Account';
        }catch(Exception ee) //Null Pointer Exception
        {
        	GenericEventErrorLogger.publishEventFromException(ee, 'Test Exception Component');
        }
        try
        {
        	insert new Account(Name = null);
        }catch(DMLException de)
        {
        	GenericEventErrorLogger.publishEventFromException(de, 'Test Exception Component');
        }
        Test.stopTest();       
		System.assertEquals(0, [SELECT Id FROM Error_Log__c].size());                        
    }
}