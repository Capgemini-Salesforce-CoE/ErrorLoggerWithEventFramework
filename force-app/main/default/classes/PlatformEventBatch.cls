/**********************************************************************************************
* @Author:      Tirthankar - Salesforce COE 
* @Date:        24th June 20200
* @Description: This class will be used to demonstrate the platform event error logging. Will be used in test classes
***********************************************************************************************/
public class PlatformEventBatch implements Database.Batchable<SObject>,Database.RaisesPlatformEvents{
    public List<Account> start(Database.BatchableContext ctx) 
    {
        return [SELECT Id,Name FROM Account 
                WHERE Name like 'Bulk Data Load Test PE%'
                ORDER BY Name desc LIMIT 2000]; 
    }
    
    public void execute(Database.BatchableContext bc, List<SObject> scope) 
    {                 
        for(Account accInst : (List<Account>)scope) 
        {
            errorGeneratorMethod(accInst.Name); //this will throw 3 diffrent types of error.           
        }                                      
    }
    
    public void finish(Database.BatchableContext bc) { }
   
    public static void errorGeneratorMethod(String accountName)
    {        
        if(String.isNotEmpty(accountName))
        {
            if(accountName.containsIgnoreCase('Bulk Data Load Test PE 9'))
            { 
                throw new AccountException('Order Ref:100 is invalid.');
            }if(accountName.containsIgnoreCase('Bulk Data Load Test PE 4'))
            {
                // Divide by zero!
                Integer newAmount = 20 / 0;
            }if(accountName.containsIgnoreCase('Bulk Data Load Test PE 1'))
            {
                // Limits exception
                for(Integer i=0 ; i<201 ; i++) {
                    Account acc = [SELECT Id FROM Account LIMIT 1];
                }
            }
            if(accountName.containsIgnoreCase('Bulk Data Load Test PE 2'))
            {
                // Limits exception
                for(Integer i=0 ; i<201 ; i++) {
                    Account acc = [SELECT Id FROM Account LIMIT 1];
                }
            }
            if(accountName.containsIgnoreCase('Bulk Data Load Test PE 3'))
            {
                // Limits exception
                for(Integer i=0 ; i<201 ; i++) {
                    Account acc = [SELECT Id FROM Account LIMIT 1];
                }
            }
            if(accountName.containsIgnoreCase('Bulk Data Load Test PE 5'))
            {
                // Limits exception
                for(Integer i=0 ; i<201 ; i++) {
                    Account acc = [SELECT Id FROM Account LIMIT 1];
                }
            }
        }            
    }

    public with sharing class AccountException extends Exception {
 
    }
}