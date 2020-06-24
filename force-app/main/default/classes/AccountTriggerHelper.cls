/**********************************************************************************************
* @Author:      Tirthankar - Salesforce COE 
* @Date:        24th June 2020
* @Description: Example of trigger handler to demonstrate the error logging framework.
***********************************************************************************************/
public with sharing class AccountTriggerHelper 
{   
    public static void afterInsert()
    {
        try
        {
            list<Contact> contactList = new list<Contact>();
            for(Account acc : (List<Account>)Trigger.New)
            {               
                contactList.add(new Contact(AccountId= acc.Id));   //feeding contact without required field:LastName 
            }   
          //  insert contactList;
        }catch(DMLException de)
        {            
            GenericEventErrorLogger.publishEventFromException(de, ApplicationConstant.ACCOUNT_TRIGGER_HANDLER_NAME );
            throw de;    
        } catch(Exception ee)
        {           
            GenericEventErrorLogger.publishEventFromException(ee, ApplicationConstant.ACCOUNT_TRIGGER_HANDLER_NAME);
            throw ee;    
        }   
    }
    
}