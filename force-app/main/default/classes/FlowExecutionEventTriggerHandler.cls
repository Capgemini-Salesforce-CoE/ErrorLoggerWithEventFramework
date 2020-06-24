/**********************************************************************************************
* @Author:      Tirthankar - Salesforce COE 
* @Date:        24th June 20200
* @Description: Trigger handler class for FlowExecutionEventTrigger
* @TestClass:   FlowExecutionEventTriggerHandlerTest 
***********************************************************************************************/
public with sharing class FlowExecutionEventTriggerHandler 
{
    public static void afterInsert(list<FlowExecutionErrorEvent> flowErrorList)
    {
        Error_Log_Configuration__mdt errorLogEventInstance = CustomMetadataUtility.getLogErrorMetadata();        
        if(errorLogEventInstance!=null && 
           String.isNotEmpty(errorLogEventInstance.Extended_Class_For_Flow_PE__c) && 
           !errorLogEventInstance.Is_Using_Packaged_Code_For_Flow_PE__c)
        {
        	//Dynamically fetch the batch handler class and invoke the method
            Type classType = Type.forName(errorLogEventInstance.Extended_Class_For_Flow_PE__c);  
            ErrorLogExtendedInterface errorLogInterface = (ErrorLogExtendedInterface)classType.newInstance();
            errorLogInterface.execute(flowErrorList);    
        }else
        {
        	insertIntoLoggerObject(flowErrorList);    
        }
    }

	public static void insertIntoLoggerObject(list<FlowExecutionErrorEvent> flowErrorList)
    {
    	try
        {
            list<Error_Log__c> errorLogList = new list<Error_Log__c>();
        	for(FlowExecutionErrorEvent flowErrorInstance : flowErrorList)
            {
                 //instantiate the error logging object and feed the error information from PE 
                errorLogList.add(new Error_Log__c(
                    Record_Id__c = flowErrorInstance.RelatedRecordId, 
                    Error_Message__c = flowErrorInstance.ErrorMessage,
                    Component_Name__c = flowErrorInstance.FlowApiName,
                    Flow_User__c= flowErrorInstance.UserId,
                    Error_Source__c = ApplicationConstant.FLOW 
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