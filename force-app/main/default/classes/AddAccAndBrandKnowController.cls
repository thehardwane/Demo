public without sharing class AddAccAndBrandKnowController {
    /**
    @AuraEnabled
    public static FieldSetWrapper getAllIsBrand(String recordId){
        String sObjName = Id.valueOf(recordId).getSObjectType().getDescribe().getName();
        
        String queryForExistingBrand = 'SELECT Account__c, Account__r.Brand_Name__c';
        String fieldSetName='';
        //code review changes - equalsIgnoreCase
        if(String.isNotBlank(sObjName) && sObjName.equalsIgnoreCase('ADCS_Notification__c')){
            fieldSetName = 'Add_Applicable_Account'; 
            queryForExistingBrand += ' FROM Applicable_Account__c WHERE Notification__c =: recordId';
        }
        //code review changes - equalsIgnoreCase
        else if(String.isNotBlank(sObjName) && sObjName.equalsIgnoreCase('Knowledge__kav')){
            fieldSetName = 'Add_Knowledge_Brand';
            queryForExistingBrand += ' FROM Brand_Display__c WHERE Knowledge__c =: recordId';
        }
        
        Set<String> brandName = new Set<String>();
        for(sObject sObjectObj : Database.query(queryForExistingBrand)){
            sObject objSobject = sObjectObj.getSObject('Account__r');
            if(objSobject != null && objSobject.get('Brand_Name__c') != null){
                brandName.add((String)objSobject.get('Brand_Name__c'));  
            }
        }
        
        String result = '';
        
        SObjectType objToken = Schema.getGlobalDescribe().get('Account');
        Schema.DescribeSObjectResult d = objToken.getDescribe();
        Map<String, Schema.FieldSet> fsMap = d.fieldSets.getMap();
        
        String query = 'SELECT ';
        //SF-3868 Adding Brand Record Type check -Yash
        String brandRecordType = System.label.ACCOUNT_BRAND_RT_DEV_NAME;
        //Added by Himanshu for Parent brand
        String parentBrandRecordType = System.label.PARENT_BRAND_RT_DEV_NAME;
        
        if(fsMap.containsKey(fieldSetName)){
            for(Schema.FieldSetMember f : fsMap.get(fieldSetName).getFields()) {
                if(result != ''){
                    result += ',';
                }
                String jsonPart = '{';
                jsonPart += '"label":"' + f.getLabel() + '",';
                jsonPart += '"required":"' + (f.getDBRequired() || f.getRequired()) + '",';
                jsonPart += '"type":"' + (f.getType()) + '",';
                jsonPart += '"name":"' + f.getFieldPath() + '"';
                jsonPart += '}';
                result += jsonPart;
                
                query += f.getFieldPath() + ', ';
            }
        }
        //adding record type check for brand SF-3868 Yash
        query += 'Id FROM Account WHERE Is_Brand__c = true AND Brand_Name__c NOT IN:brandName AND ((RecordType.DeveloperName=:brandRecordType AND Parentid = null) OR RecordType.DeveloperName=:parentBrandRecordType) ORDER BY Brand_Name__c ASC NULLS LAST';
        
        
        List<AccountWrapper> objAccountWrapperList = new List<AccountWrapper>();
        for(Account accountObj : Database.query(query)){
            AccountWrapper objAccountWrapper = new AccountWrapper();
            objAccountWrapper.accObj = accountObj;
            objAccountWrapper.isTrue = false;
            objAccountWrapperList.add(objAccountWrapper);
        }
        
        FieldSetWrapper objFieldSetWrapper = new FieldSetWrapper();
        objFieldSetWrapper.fieldSetName= '['+result+']';
        objFieldSetWrapper.accountWrapperObj= objAccountWrapperList;
        return objFieldSetWrapper;
    }
    
    public class AccountWrapper{
        
        @AuraEnabled
        public Account accObj; 
        
        @AuraEnabled
        public Boolean isTrue;
        
    }
    
    public class FieldSetWrapper{
        @AuraEnabled
        public String fieldSetName; 
        
        @AuraEnabled
        public List<AccountWrapper> accountWrapperObj; 
    }
    
    @AuraEnabled
    public static void callAddAplicableAccOrKnowBrand(List<String> selectdBrandList, String recordId){
        //added try-catch for code review
        try{
            String sObjName = Id.valueOf(recordId).getSObjectType().getDescribe().getName();
            
            String fieldSetName='';
            //code review changes - equalsIgnoreCase
            if(String.isNotBlank(sObjName) && sObjName.equalsIgnoreCase('ADCS_Notification__c')){
                List<Applicable_Account__c> applicableAccountList = new List<Applicable_Account__c>();
                for(String accountObjId : selectdBrandList){
                    Applicable_Account__c applicableAccountObj = new Applicable_Account__c();
                    applicableAccountObj.Account__c = accountObjId;
                    applicableAccountObj.Notification__c = recordId;
                    applicableAccountList.add(applicableAccountObj);
                }
                if(!applicableAccountList.isEmpty()){
                    insert applicableAccountList; 
                }
            }
            //code review changes - equalsIgnoreCase
            else if(String.isNotBlank(sObjName) && sObjName.equalsIgnoreCase('Knowledge__kav')){
                List<Brand_Display__c> brandKnowledgeList = new List<Brand_Display__c>();
                for(String accountObjId : selectdBrandList){
                    Brand_Display__c brandKnowledgeObj = new Brand_Display__c();
                    brandKnowledgeObj.Account__c = accountObjId;
                    brandKnowledgeObj.Knowledge__c = recordId;
                    brandKnowledgeList.add(brandKnowledgeObj);
                }
                if(!brandKnowledgeList.isEmpty()){
                    insert brandKnowledgeList; 
                }
            }
        }catch(Exception e){
            System.debug('exception is::'+e.getMessage());
            System.debug('exception is::'+e.getLineNumber());
        }
    }
   */ 
}