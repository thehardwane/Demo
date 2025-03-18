public without sharing class BrandingGuideHandler {
      /**
   
    public static void runTrigger(){     
        switch on Trigger.operationType {
            when AFTER_INSERT {
                insertSharingForBrandingGuide(Trigger.new);
            }
            when AFTER_UPDATE {
                removeSharingForBrandingGuide(Trigger.old);
                insertSharingForBrandingGuide(Trigger.new);
            }
            when AFTER_DELETE {
                removeSharingForBrandingGuide(Trigger.old);
            }
        }
    }
    
    /**
    *  Method used for inserting the sharing records for Branding Guide with Accounts
    *  @name insertSharingForBrandingGuide
    *  @param List<Branding_Guide__c> lstBrandingGuide
    *  @return void
    
    public static void insertSharingForBrandingGuide(List<Branding_Guide__c> lstBrandingGuide){
        //local variables
        //Map<Id, BrandingGuide__c> mapOfGuides = new Map<Id, BrandingGuide__c>();
        Set<String> brandingGuideIdWithAccountIdSet = new  Set<String> ();
        List<Branding_Guide__Share > lstBrandingGuideShare = new List<Branding_Guide__Share >();
        Set<Id> setOfAccounts = new Set<Id>();
        for(Branding_Guide__c eachBrandingGuide : lstBrandingGuide){
            if(String.isNotBlank(eachBrandingGuide.Account__c)){
               setOfAccounts.add(eachBrandingGuide.Account__c);
            }
        }
        Map<Id, Account> mapOfAccounts = new Map<Id, Account>();
        if(!setOfAccounts.isEmpty()){
            mapOfAccounts = AccountSelector.getRecordById(setOfAccounts);
            for(Branding_Guide__c eachBrandingGuide : lstBrandingGuide){
                if(!mapOfAccounts.isEmpty() && 
                   mapOfAccounts.containsKey(eachBrandingGuide.Account__c) && 
                   String.isNotBlank(mapOfAccounts.get(eachBrandingGuide.Account__c).parentId))
                {
                    brandingGuideIdWithAccountIdSet.add(eachBrandingGuide.Id+'-'+mapOfAccounts.get(eachBrandingGuide.Account__c).parentId);
                }
            }

            lstBrandingGuideShare.addAll(shareBrandingGuideWithParentUser(brandingGuideIdWithAccountIdSet));
            try{         
                //insert sharing records
                if(!lstBrandingGuideShare.isEmpty()){
                    insert lstBrandingGuideShare;
                }
            } catch(Exception ex){
                system.debug('Error::'+ex.getMessage());
            }
        }
    }

    /**
    *  Method used for populating the sharing records for Parent user
    *  @name shareBrandingGuideWithBrandUser
    *  @param Set<String> brandingGuideIdWithAccountIdSet
    *  @return List<Branding_Guide__Share>
    
    public static List<Branding_Guide__Share> shareBrandingGuideWithParentUser(Set<String> brandingGuideIdWithAccountIdSet){
        //local varibales
        String accountId = '';
        Set<Id> accountIdSet = new Set<Id>();
        Map<Id,Account> mapOfAccounts = new Map<Id,Account>();
        Map<Id,String> accountIdWithGroupName = new Map<Id,String>();
 
        //checking set is not empty
        if(!brandingGuideIdWithAccountIdSet.isEmpty()){
            for(String brandingGuideIdWithAccountId : brandingGuideIdWithAccountIdSet){
                //getting account Id and storing in a set
                accountIdSet.add(brandingGuideIdWithAccountId.split('-')[1]);
            }
        }
        //querying accounts to fetch brand names
        if(!accountIdSet.isEmpty()){
            mapOfAccounts = AccountSelector.getRecordById(accountIdSet);
        }
        
        //checking set is not empty
        if(!brandingGuideIdWithAccountIdSet.isEmpty()){
            //iterating through set
            for(String brandingGuideIdWithAccountId : brandingGuideIdWithAccountIdSet){
                //getting account Id
                accountId = brandingGuideIdWithAccountId.split('-')[1];
                //populating set which holds the name of Portal User Group
                accountIdWithGroupName.put(accountId,CaseTriggerHelper.getGroupName(mapOfAccounts.get(accountId)));
            }
        }
        //calling common method for creating sharing record
        return populateSharingRecords(brandingGuideIdWithAccountIdSet,accountIdWithGroupName,'Read');
    }
    
    /**
    *  Method used for populating share records for Account Team & Brand users
    *  @name populateSharingRecords
    *  @param Set<String> brandingGuideIdWithAccountIdSet,Map<Id,String> accountIdWithGroupName,String accessLevel
    *  @return List<Branding_Guide__Share>
    
    public static List<Branding_Guide__Share> populateSharingRecords(Set<String> brandingGuideIdWithAccountIdSet,
                                                               Map<Id,String> accountIdWithGroupName,
                                                               String accessLevel){
            
        //local variables
        String groupName = '';
        String brandingGuideId = '';
        String accountId = '';                                                           
        Map<String,Id> mapOfGroupNameWithId = new Map<String,Id>();
        List<Branding_Guide__Share> lstBrandingGuideShare = new List<Branding_Guide__Share>();
        //fetch all group details from its name
        if(!accountIdWithGroupName.isEmpty()){
            List<group> lstGroup = UserSelector.getAllGroupsByName(new Set<String>(accountIdWithGroupName.values()));
            if(!lstGroup.isEmpty()){
                for(Group eachGroup : lstGroup){
                    //creating a map of groupName with its id
                    mapOfGroupNameWithId.put(eachGroup.Name,eachGroup.Id);
                }
            }
        }
        //iterating map of brandingGuideId with accountId
        if(!brandingGuideIdWithAccountIdSet.isEmpty()){
            for(String brandingGuideIdWithAccountId : brandingGuideIdWithAccountIdSet){
                //getting account Id and brandingGuideId
                accountId = brandingGuideIdWithAccountId.split('-')[1];
                brandingGuideId = brandingGuideIdWithAccountId.split('-')[0];
                //checking group name exists for a particular account
                if(accountIdWithGroupName.containsKey(accountId)){
                    //storing group name in a string variable
                    groupName =  accountIdWithGroupName.get(accountId);
                    //creating sharing records if group name found in map
                    if(mapOfGroupNameWithId.containsKey(groupName)){
                        Branding_Guide__Share eachBrandingGuideShare = new Branding_Guide__Share();
                        eachBrandingGuideShare.ParentId = brandingGuideId;
                        eachBrandingGuideShare.UserOrGroupId  = mapOfGroupNameWithId.get(groupName);
                        eachBrandingGuideShare.AccessLevel  = accessLevel;
                        eachBrandingGuideShare.RowCause  = Schema.Branding_Guide__Share.RowCause.Manual;
                        lstBrandingGuideShare.add(eachBrandingGuideShare);
                    }
              }
            }
        }
        return lstBrandingGuideShare;
    }
    
    /**
    *  Method used for deleting the sharing records for Branding Guide with Accounts
    *  @name removeSharingForBrandingGuide
    *  @param List<Branding_Guide__c> lstBrandingGuide
    *  @return void
    
    public static void removeSharingForBrandingGuide(List<Branding_Guide__c> lstBrandingGuide){
        //local variables
        Set<String> brandingGuideIdWithAccountIdSet = new  Set<String> ();
        List<Branding_Guide__Share > recordToBeDeletedList = new List<Branding_Guide__Share >();
        Set<Id> setOfAccounts = new Set<Id>();
        Map<Id, Account> mapOfAccounts = new Map<Id, Account>();
        
        for(Branding_Guide__c eachBrandingGuide : lstBrandingGuide){
            if(String.isNotBlank(eachBrandingGuide.Account__c)){
               setOfAccounts.add(eachBrandingGuide.Account__c);
            }
        }
        
        if(!setOfAccounts.isEmpty()){
            mapOfAccounts = AccountSelector.getRecordById(setOfAccounts);
            for(Branding_Guide__c eachBrandingGuide : lstBrandingGuide){
                if(!mapOfAccounts.isEmpty() && 
                   mapOfAccounts.containsKey(eachBrandingGuide.Account__c) && 
                   String.isNotBlank(mapOfAccounts.get(eachBrandingGuide.Account__c).parentId))
                {
                    brandingGuideIdWithAccountIdSet.add(eachBrandingGuide.Id+'-'+mapOfAccounts.get(eachBrandingGuide.Account__c).parentId);
                }
            }
            recordToBeDeletedList.addAll(removeBrandingGuideWithBrandUser(brandingGuideIdWithAccountIdSet));
            try{         
                //delete sharing records
                if(!recordToBeDeletedList.isEmpty()){
                    delete recordToBeDeletedList;
                }
            } catch(Exception ex){
                system.debug('Error::'+ex.getMessage());
            }
        }
    }
  
    /**
    *  Method used for removing the sharing records for Brand User groups
    *  @name removeBrandingGuideWithBrandUser
    *  @param Set<String> brandingGuideIdWithAccountIdSet
    *  @return List<Branding_Guide__Share>
  
    public static List<Branding_Guide__Share> removeBrandingGuideWithBrandUser(Set<String> brandingGuideIdWithAccountIdSet){
        
        //local varibales
        String accountId = '';
        Set<Id> accountIdSet = new Set<Id>();
        Map<Id,Account> mapOfAccounts = new Map<Id,Account>();
        Map<Id,String> accountIdWithGroupName = new Map<Id,String>();
        
        //checking set is not empty
        if(!brandingGuideIdWithAccountIdSet.isEmpty()){
            for(String brandingGuideIdWithAccountId : brandingGuideIdWithAccountIdSet){
                //getting account Id and storing in a set
                accountIdSet.add(brandingGuideIdWithAccountId.split('-')[1]);
            }
        }
        //querying accounts to fetch brand names
        if(!accountIdSet.isEmpty()){
            mapOfAccounts = AccountSelector.getRecordById(accountIdSet);
        }
        //checking map is not empty
        if(!brandingGuideIdWithAccountIdSet.isEmpty()){
            //iterating through set
            for(String brandingGuideIdWithAccountId : brandingGuideIdWithAccountIdSet){
                //getting account Id
                accountId = brandingGuideIdWithAccountId.split('-')[1];
                //populating set which holds the name of account team group
                accountIdWithGroupName.put(accountId,CaseTriggerHelper.getGroupName(mapOfAccounts.get(accountId)));
            }
        }
        //calling common method for creating sharing record
       return removeSharingRecords(brandingGuideIdWithAccountIdSet,accountIdWithGroupName);
    }
    
    /**
    *  Method used for populating share records for Brand users
    *  @name removeSharingRecords
    *  @param Set<String> brandingGuideIdWithAccountIdSet,Map<Id,String> accountIdWithGroupName
    *  @return List<Branding_Guide__Share>
   
    public static List<Branding_Guide__Share> removeSharingRecords(Set<String> brandingGuideIdWithAccountIdSet,Map<Id,String> accountIdWithGroupName){
        
        //local variables
        String groupName = '';
        Set<String> brandingGuideIdSet = new Set<String>();
        Map<String,Id> mapOfGroupNameWithId = new Map<String,Id>();
        List<Branding_Guide__Share> lstBrandingGuideShare = new List<Branding_Guide__Share>();
        List<Branding_Guide__Share> recordsToBeDeleted = new List<Branding_Guide__Share>();
        
        //fetch all group details from its name
        if(!accountIdWithGroupName.isEmpty()){
            List<group> lstGroup = UserSelector.getAllGroupsByName(new Set<String>(accountIdWithGroupName.values()));
            if(!lstGroup.isEmpty()){
                for(Group eachGroup : lstGroup){
                    //creating a map of groupName with its id
                    mapOfGroupNameWithId.put(eachGroup.Name,eachGroup.Id);
                }
            }
        }
        //fetching all BrandingGuide records in a set
        if(!brandingGuideIdWithAccountIdSet.isEmpty()){
            for(String eachBrandingGuideIdWithAccountId : brandingGuideIdWithAccountIdSet){
                //adding BrandingGuideId in a set
                brandingGuideIdSet.add(eachBrandingGuideIdWithAccountId.split('-')[0]);
            }
        }
        //querying shared records which needs to be delete
        if(!brandingGuideIdSet.isEmpty() && !mapOfGroupNameWithId.isEmpty()){
            lstBrandingGuideShare = BrandingGuideSelector.getBrandingGuideSharing(brandingGuideIdSet,mapOfGroupNameWithId.values());
        }
        
        Id groupId;
        //iterating list of shared records
        if(!lstBrandingGuideShare.isEmpty()){
            for(Branding_Guide__Share brandingGuideShare : lstBrandingGuideShare){
                //finding groupId related to a particular Account
                //brandingGuideIdWithAccountIdSet
                for(String eachBrandingGuideIdWithAccountId : brandingGuideIdWithAccountIdSet){
                    //checking BrandingGuide id should be same
                    if(eachBrandingGuideIdWithAccountId.split('-')[0].equals(brandingGuideShare.ParentId)){
                        //get accountId from map
                        Id accountId = eachBrandingGuideIdWithAccountId.split('-')[1];
                        if(accountIdWithGroupName.containsKey(accountId)){
                            //get groupName from map
                            groupName = accountIdWithGroupName.get(accountId);
                            if(mapOfGroupNameWithId.containsKey(groupName)){
                                //fetching groupId
                                groupId = mapOfGroupNameWithId.get(groupName);
                                if(brandingGuideShare.UserOrGroupId.equals(groupId)){
                                    recordsToBeDeleted.add(brandingGuideShare);
                                }
                            }
                        }
                    }
                }
            }
        }
        return recordsToBeDeleted;
    }
    */
}