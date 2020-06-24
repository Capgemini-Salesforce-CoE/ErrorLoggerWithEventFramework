/**********************************************************************************************
* @Author:      Tirthankar - Salesforce COE 
* @Date:        24th June 20200
* @Description: Trigger details of Batch event. In after insert logic ,
				event with error log information will be passed to salesforce error log object
***********************************************************************************************/
trigger BatchApexErrorPlatformEventTrigger on BatchApexErrorEvent (after insert) {
	BatchApexErrorEventTriggerHandler.afterInsert(Trigger.new); 
}