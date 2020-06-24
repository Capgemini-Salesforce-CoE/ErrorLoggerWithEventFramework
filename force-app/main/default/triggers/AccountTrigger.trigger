/**********************************************************************************************
* @Author:      Tirthankar - Salesforce COE 
* @Date:        24th June 2020
* @Description: Trigger details of Account. 
***********************************************************************************************/
trigger AccountTrigger on Account (before insert, 
                                    after insert,
                                     before delete,
                                      after delete,
                                      before update, 
                                      after update, 
                                      after undelete) 
{

    try
    {       
        //This sectiona is for manual log testing.commenting this to test batch apex PE error test
        if(Trigger.isAfter && Trigger.isinsert)
        {
           AccountTriggerHelper.afterInsert();         
        } 
    }catch(Exception ee)
    {      
        throw ee;
    } 

   
    
}