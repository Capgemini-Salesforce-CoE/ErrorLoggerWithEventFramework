/**********************************************************************************************
* @Author:      Tirthankar - Salesforce COE 
* @Date:        24th June 20200
* @Description: This is a generic interface which will implented by Platform event Handler class for dynamic invocation

***********************************************************************************************/
global Interface ErrorLogExtendedInterface {
    void execute(list<SObject> sObjectList);
}