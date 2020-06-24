/**********************************************************************************************
* @Author:      Tirthankar - Salesforce COE 
* @Date:        24th June 2020
* @Description: This class will be used to publish the custom platform event
                containing exception information.
* @Test:        LogEventTriggerHandlerTest
***********************************************************************************************/
public inherited sharing class GenericEventErrorLogger {

    public static void publishEventFromException(Exception exceptionInstance,String componentName)
    {            
        publishEventFromException(exceptionInstance, componentName, getLimitDetails(), null);
    }

    public static void publishEventFromException(DMLException exceptionInstance,String componentName)
    {                     
        publishEventFromException(exceptionInstance, componentName, getLimitDetails(), getRecordIdsFromDMLException(exceptionInstance, Trigger.new) );
    }

    public static void publishEventFromException(Exception exceptionInstance, String ComponentName, String limitData, String recordIds)
    {
    	if(exceptionInstance!= null)
        {            
            Log__e logEventInstance = new Log__e(Component_Name__c = ComponentName,
                                                 Error_Stacktrace__c = exceptionInstance.getStackTraceString(),                                                 
                                                 Error_Type__c = ApplicationConstant.APEX, //Need some way to find out the actual source 
                                                 Error_Message__c = exceptionInstance.getMessage(),
                                                 Row_Exception_Message__c = String.valueOf(exceptionInstance),
                                                 Limits__c = limitData,
                                                 Line_Number__c = exceptionInstance.getLineNumber(),
                                                 Exception_Type__c = exceptionInstance.getTypeName(),
                                                 Current_User__c = UserInfo.getUserId()
                                                );            
            if(exceptionInstance.getTypeName().containsIgnoreCase(ApplicationConstant.DMLEXCEPTION))
            {
                 logEventInstance.Record_Id__c =  recordIds ; 
                 logEventInstance.Error_Message__c = exceptionInstance.getDMLMessage(0) ;                
            }			        
            DataBase.SaveResult platformErrorLogSR = EventBus.publish(logEventInstance);
        }
    } 

    private static String getRecordIdsFromDMLException(DMLException exceptionInstance, list<SObject> sobjectList)
    {
        String recordIds = ApplicationConstant.SPACE;
        if(Trigger.isExecuting  && sobjectList!= null && !sobjectList.isEmpty() && (sobjectList.size() >= exceptionInstance.getNumDml()))
        {
            for(Integer i=0; i< exceptionInstance.getNumDml() ; i++)
            {                
                if(String.isNotEmpty(sobjectList[i].Id))
                {
                    recordIds += sobjectList[i].Id + ApplicationConstant.COMMA;    
                }        			    
            }
            if(String.isNotEmpty(recordIds))
            {
                recordIds = recordIds.removeEnd(ApplicationConstant.COMMA);    
            }      
        }              
        return recordIds;
    }
    /**********************************************************************************************
    * @Author:      Ranjan Singh 
    * @Date:        10th Jan 2020
    * @Description: This method return the limit snapshot consumed in synchronous transaction.
    ***********************************************************************************************/    
    public static String getLimitDetails()
    {
        String queryLimit = ApplicationConstant.NUMBER_OF_SOQL + Limits.getQueries() + ApplicationConstant.SLASH + Limits.getLimitQueries();
        String queryRowLimit = ApplicationConstant.NUMBER_OF_QUERYROWS + Limits.getQueryRows() + ApplicationConstant.SLASH + Limits.getLimitQueryRows();
        String soslLimit =  ApplicationConstant.NUMBER_OF_SOSL + Limits.getSoslQueries() + ApplicationConstant.SLASH + Limits.getLimitSoslQueries();
        String dmlLimit = ApplicationConstant.NUMBER_OF_DML + Limits.getDmlRows() + ApplicationConstant.SLASH + Limits.getLimitDmlRows();
        String dmlStatement = ApplicationConstant.NUMBER_OF_DMLSTATEMENTS +  Limits.getDmlStatements() + ApplicationConstant.SLASH + Limits.getLimitDmlStatements();   
        String cpuTime = ApplicationConstant.MAXIMUM_CPU_TIME + Limits.getCpuTime() + ApplicationConstant.SLASH + Limits.getLimitCpuTime();  
        String heapSize = ApplicationConstant.MAXIMUM_HEAP_SIZE + Limits.getHeapSize() + ApplicationConstant.SLASH + Limits.getLimitHeapSize();
        String futureCall = ApplicationConstant.NUMBER_OF_FUTURE_CALLS + Limits.getFutureCalls() + ApplicationConstant.SLASH + Limits.getLimitFutureCalls();
        String callout = ApplicationConstant.NUMBER_OF_CALLOUTS + Limits.getCallouts() + ApplicationConstant.SLASH + Limits.getLimitCallouts();
        String queueable = ApplicationConstant.NUMBER_OF_QUEUABLE + Limits.getQueueableJobs() + ApplicationConstant.SLASH + Limits.getLimitQueueableJobs();
        String finalLimitString =   queryLimit + ApplicationConstant.NEXTLINE +
                                    queryRowLimit + ApplicationConstant.NEXTLINE +
                                    soslLimit + ApplicationConstant.NEXTLINE +
                                    dmlLimit + ApplicationConstant.NEXTLINE +
                                    dmlStatement + ApplicationConstant.NEXTLINE +
                                    cpuTime + ApplicationConstant.NEXTLINE +
                                    heapSize + ApplicationConstant.NEXTLINE +
                                    futureCall + ApplicationConstant.NEXTLINE +
                                    callout ;            
            
        return finalLimitString;
    }
}