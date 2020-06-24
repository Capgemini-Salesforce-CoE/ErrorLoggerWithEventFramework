/**********************************************************************************************
* @Author:      Tirthankar - Salesforce COE 
* @Date:        24th June 20200
* @Description: Trigger details of custom platform event. In after insert logic ,
				event with error log information will be passed to salesforce error log object
***********************************************************************************************/
trigger LogPlatformEventTrigger on Log__e (after insert) {
    LogEventTriggerHandler.afterInsert(Trigger.new);	
}