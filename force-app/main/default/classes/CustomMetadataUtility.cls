public inherited sharing class CustomMetadataUtility {
    public static Error_Log_Configuration__mdt getLogErrorMetadata()
    {
        try
        {
            return [SELECT Id,MasterLabel,DeveloperName,Extended_Class_For_Batch_PE__c,
                    Extended_Class_For_Custom_PE__c,Extended_Class_For_Flow_PE__c,
                    Is_Using_Packaged_Code_For_Batch_PE__c,Is_Using_Packaged_Code_For_Custom_PE__c,
                    Is_Using_Packaged_Code_For_Flow_PE__c 
                    FROM Error_Log_Configuration__mdt WHERE DeveloperName=: ApplicationConstant.CUSTOM_METADATA_NAME LIMIT 1];
        }catch(Exception ee)
        {
            throw ee;
        }
    }
}
