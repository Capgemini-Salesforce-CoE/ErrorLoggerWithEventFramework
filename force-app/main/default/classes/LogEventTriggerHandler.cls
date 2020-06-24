/**********************************************************************************************
* @Author:      Tirthankar - Salesforce COE 
* @Date:        24th June 20200
* @Description: Trigger handler class for LogEventTrigger
***********************************************************************************************/
public with sharing class LogEventTriggerHandler {
    
    public static void afterInsert(list<Log__e> logEventList)
    {
        Error_Log_Configuration__mdt errorLogEventInstance = CustomMetadataUtility.getLogErrorMetadata();
        if(errorLogEventInstance!=null && 
           String.isNotEmpty(errorLogEventInstance.Extended_Class_For_Custom_PE__c) && 
           !errorLogEventInstance.Is_Using_Packaged_Code_For_Custom_PE__c)
        {
        	//Dynamically fetch the batch handler class and invoke the method
            Type classType = Type.forName(errorLogEventInstance.Extended_Class_For_Custom_PE__c);  
            ErrorLogExtendedInterface errorLogInterface = (ErrorLogExtendedInterface)classType.newInstance();
            errorLogInterface.execute(logEventList);    
        }else
        {
        	insertIntoLoggerObject(logEventList);    
        }
    }    
    
    public static void insertIntoLoggerObject(list<Log__e> logEventList)
    {   
        try
        {
            list<Error_Log__c> errorLogList = new list<Error_Log__c>();
            for(Log__e logInst : logEventList)
            {
                errorLogList.add( new Error_Log__c(
                    Component_Name__c = logInst.Component_Name__c ,
                    Error_Message__c = logInst.Error_Message__c ,
                    Error_Source__c = logInst.Error_Type__c ,                
                    Row_Exception_Message__c = logInst.Row_Exception_Message__c ,
                    Stack_Trace__c = logInst.Error_Stacktrace__c ,
                    Line_Number__c = logInst.Line_Number__c ,
                    Limits__c = logInst.Limits__c,
                    Exception_Type__c = logInst.Exception_Type__c,
                    Record_Id__c = logInst.Record_Id__c,
                    Flow_User__c = logInst.Current_User__c                
                ));    
            }
            list<DataBase.SaveResult> errorLogSaveResults = Database.insert(errorLogList);      
        }catch(Exception ee)
        {
            if (EventBus.TriggerContext.currentContext().retries < 4) 
            {
                // Condition isn't met, so try again later.
                throw new EventBus.RetryableException( ApplicationConstant.RETRYERROR );
            }else
            {
                //probably add a seperate record into error log of platform event type
            }
        }
        
    }
}