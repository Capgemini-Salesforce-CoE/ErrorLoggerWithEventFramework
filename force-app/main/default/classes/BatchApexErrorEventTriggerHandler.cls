/**********************************************************************************************
* @Author:      Tirthankar - Salesforce COE 
* @Date:        24th June 20200
* @Description: Trigger handler class for BatchApexErrorEventTrigger
* @TestClass:   BatchApexErrorEventTest 
***********************************************************************************************/
global class BatchApexErrorEventTriggerHandler {
    
    global static void afterInsert(list<BatchApexErrorEvent> batchApexErrorList)
    {
        Error_Log_Configuration__mdt errorLogEventInstance = CustomMetadataUtility.getLogErrorMetadata();
        if(errorLogEventInstance!=null && 
           String.isNotEmpty(errorLogEventInstance.Extended_Class_For_Batch_PE__c) && 
           !errorLogEventInstance.Is_Using_Packaged_Code_For_Batch_PE__c)
        {
        	//Dynamically fetch the batch handler class and invoke the method
            Type classType = Type.forName(errorLogEventInstance.Extended_Class_For_Batch_PE__c);  
            ErrorLogExtendedInterface errorLogInterface = (ErrorLogExtendedInterface)classType.newInstance();
            errorLogInterface.execute(batchApexErrorList);    
        }else
        {
        	insertIntoLoggerObject(batchApexErrorList);    
        }
    }
    
    public static void insertIntoLoggerObject(list<BatchApexErrorEvent> batchApexErrorList)
    {
        try
        {
            set<Id> asyncApexJobIds = new set<Id>();
            list<Error_Log__c> errorLogList = new list<Error_Log__c>();
            for(BatchApexErrorEvent batchInst : batchApexErrorList)
            {
                asyncApexJobIds.add(batchInst.AsyncApexJobId);
            }
            Map<Id,AsyncApexJob> asyncIdJobMap = new Map<Id,AsyncApexJob>([SELECT Id, ApexClass.Name 
                                                                           FROM AsyncApexJob 
                                                                           WHERE Id IN :asyncApexJobIds]
                                                                         );                       
            for(BatchApexErrorEvent batchInst : batchApexErrorList)
            {            
                //instantiate the error logging object and feed the error information from PE               
                errorLogList.add( new Error_Log__c(
                    Component_Name__c = asyncIdJobMap.get(batchInst.AsyncApexJobId)!=null ? asyncIdJobMap.get(batchInst.AsyncApexJobId).ApexClass.Name : '' ,
                    Error_Message__c = batchInst.Message ,
                    Error_Source__c = ApplicationConstant.BATCHAPEX ,                
                    Phase__c = batchInst.Phase ,
                    Stack_Trace__c = batchInst.StackTrace ,
                    Exception_Type__c = batchInst.ExceptionType ,
                    Record_Id__c = batchInst.JobScope                
                ));                 
            }                      
            list<DataBase.SaveResult> errorLogSaveResults = Database.insert(errorLogList);     
        }catch(Exception ee)
        {
            if (EventBus.TriggerContext.currentContext().retries < 4) 
            {
                // Condition isn't met, so try again later.
                throw new EventBus.RetryableException(ApplicationConstant.RETRYERROR);
            }else
            {
                 //probably add a seperate record into error log of platform event type
            }
        }        
    }
    
}