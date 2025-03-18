/**

@Description Controller class for BrandSelect Component

*/
public with sharing class BrandController {
    /**
    @AuraEnabled
    //method getAccount is retriving the account detail
    public static AuraResponse getAccount(Id accountId) {
        map<Id, Account> mapOfAccount = AccountSelector.getRecordById(new Set<Id>{accountId});
        //SF-3651 : Grant permission to Admin profiles
        Setting_Up_Brand_Access__c settingUpBrandAccess = Setting_Up_Brand_Access__c.getInstance();
        if(settingUpBrandAccess == null || (settingUpBrandAccess != null && !settingUpBrandAccess.Active__c)){
            return new AuraResponse(false,Label.INSUFFICIENT_PRIVILEGES_ERROR, null);
        } else if(
            !mapOfAccount.isEmpty() && 
            mapOfAccount.containsKey(accountId) && 
            !(mapOfAccount.get(accountId).RecordType.DeveloperName.equalsIgnoreCase(Label.ACCOUNT_BRAND_RT_DEV_NAME)||
              //SF-5250 Enable Set As Brand for Parent Brand Accounts
              mapOfAccount.get(accountId).RecordType.DeveloperName.equalsIgnoreCase(Label.PARENT_BRAND_RT_DEV_NAME)||
              //SF-9804 Enable Set As Brand for Prospect Standalone Accounts
              mapOfAccount.get(accountId).RecordType.DeveloperName.equalsIgnoreCase(Label.PROSPECT_RT_DEV_NAME))
        ){
            
            return new AuraResponse(false,Label.INSUFFICIENT_PRIVILEGES_ERROR, null);
        }else{
            return BrandConfigHelper.getAccountDetail(accountId);
        }
    }
    
    //method saveAccontBrandWithAccount is validating the BrandName on a particular Account
    @AuraEnabled
    public static AuraResponse saveAccontBrandWithAccount(String brandName, Id accountId) {
        try{
            return BrandConfigHelper.saveAccontBrandWithAccount(brandName, accountId);
        } catch(Exception ex){
            return new AuraResponse(false,ex.getMessage(), null);
        }
        
    }
    */
}