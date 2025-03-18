public without sharing class AccountTriggerHandlerNew {
   /** public static final string BRAND_RECORDTYPE_ID = RecordTypeSelector.getRecordTypeId('Account', label.ACCOUNT_BRAND_RT_DEV_NAME);
    public static final string PROSPECT_RECORDTYPE_ID = RecordTypeSelector.getRecordTypeId('Account', label.PROSPECT_RT_DEV_NAME);
    public static final string REJECTION_MESSAGE = Label.PHQ_CP_Approval_Reject_Message;
    public static final string DE_RECORDTYPEBRAND = RecordTypeSelector.getRecordTypeId('Account', label.DE_BRAND_RECORD_TYPE);
    public void runTrigger(){
        // Method will be called to handle After Update Accounts
        if(Trigger.isAfter && Trigger.isUpdate) {
            onAfterUpdate((list<Account>)trigger.new,(map<id,Account>)trigger.OldMap);
        }
        
        // Method will be called to handle Before update Accounts
        if(Trigger.isBefore && Trigger.isUpdate) {
            onBeforeUpdate((list<Account>)trigger.new,(map<id,Account>)trigger.OldMap);
        }
        
        // Method will be called to handle Before Insert Accounts
        if(Trigger.isBefore && Trigger.isInsert) {
            onBeforeinsert((list<Account>)trigger.new);
        }
        
        // Method will be called to handle After Insert Accounts
        if(Trigger.isAfter && Trigger.isInsert) {
            onAfterinsert((list<Account>)trigger.new);
        }
    
    }
    private void onAfterUpdate(list<Account> listTriggerNew, map<id,Account> triggerOldMap) {
        addAccountSharing(listTriggerNew, triggerOldMap);
        addRemoveAccessToLibrary(listTriggerNew, triggerOldMap);//SF-4810 : Extend Account Owner access to its libraries
        setParentProspectIndicator(listTriggerNew,triggerOldMap);
        addRemoveBrandingGuideSharing(listTriggerNew, triggerOldMap);
    }
    private void onAfterInsert(list<Account> listTriggerNew) {
        updateEncryptedId(listTriggerNew, null);
        setParentProspectIndicator(listTriggerNew, null);
        addRemoveBrandingGuideSharing(listTriggerNew, null);
    }
    private void onBeforeUpdate(list<Account> listTriggerNew, map<id,Account> triggerOldMap) {
        updateEncryptedId(listTriggerNew, triggerOldMap);
        applyDefault(listTriggerNew, triggerOldMap);
        preventFromRejection(listTriggerNew, triggerOldMap);
    }
    private void onBeforeinsert(list<Account> listTriggerNew) {
        applyDefault(listTriggerNew, null);
    }

    /**
    *  Method used for adding the brand admin for edit access to the account
    *  @name addAccountSharing
    *  @param list<Account> listTriggerNew, map<id,Account> triggerOldMap
    *  @return void
    *  @throws exception
    
    private void addAccountSharing(list<Account> listTriggerNew, map<id, Account> triggerOldMap) {
        set<Id> setOfAcc = new set<Id>();
        for(Account eachAcc : listTriggerNew) {
            if(
                !eachAcc.OwnerId.equals(triggerOldMap.get(eachAcc.Id).OwnerId) &&
                eachAcc.RecordTypeId.equals(BRAND_RECORDTYPE_ID)
            ) {
                setOfAcc.add(eachAcc.Id);
            }
        }
        if(!setOfAcc.isEmpty()) {
            list<User> listUser = UserSelector.getUserByAccountId(setOfAcc);
            if(!listUser.isEmpty()) {
                list<AccountShare> listAccountShare = getAccountShare(listUser);
                if(!listAccountShare.isEmpty()) {
                    insert listAccountShare;
                }
            }
        }
    }
    /**
    *  Method used for adding the Account share value on a common method
    *  @name getAccountShare
    *  @param list<User>
    *  @return list<AccountShare>
   
    private list<AccountShare> getAccountShare(list<User> listUser) {
        list<AccountShare> listAccountShare = new list<AccountShare>();
        for(User eachUser : listUser) {
            if(eachUser.Profile.Name.equalsIgnoreCase(label.BRAND_ADMIN_PROFILE_ID)) {
                AccountShare objShare = new AccountShare();
                objShare.AccountAccessLevel = 'Edit';
                objShare.CaseAccessLevel = 'None';
                objShare.OpportunityAccessLevel = 'None';
                objShare.AccountId = eachUser.AccountId;
                objShare.UserOrGroupId = eachUser.Id;
                listAccountShare.add(objShare);
            }
        }
        return listAccountShare;
    }
    /**
    *  Method used for setting the parent prospect flag on Account if criteria is met
    *  @name setParentProspectIndicator
    *  @param list<Account> listTriggerNew, map<id, Account> triggerOldMap
    *  @return void
    
    public static void setParentProspectIndicator(list<Account> listTriggerNew,  Map<Id, Account> triggerOldMap){
        if(!listTriggerNew.isEmpty()){
            Set<Id> setOfAccIds = new Set<Id>();
            List<Account> accountstoUpdate = new List<Account>();
            for(Account eachNewAccount : listTriggerNew) {
                if(
                    ((triggerOldMap == null && eachNewAccount.RecordTypeId == PROSPECT_RECORDTYPE_ID)|| 
                       (
                           triggerOldMap != null && 
                           (   triggerOldMap.get(eachNewAccount.Id).ParentId != eachNewAccount.ParentId || 
                                triggerOldMap.get(eachNewAccount.Id).Is_Brand__c != eachNewAccount.Is_Brand__c
                            ) 
                       ) 
                  )&& String.isNotBlank(eachNewAccount.parentId)
                ){
                     setOfAccIds.add(eachNewAccount.parentId);
                }
            }
            Map<Id,List<Boolean>> mapOfParentAllChild = new Map<Id,List<Boolean>>(); //account id with child id
            if(!setOfAccIds.isEmpty()){
                List<Account> listOfAccounts = AccountSelector.getAccountByParentId(setOfAccIds);
                if(!listOfAccounts.isEmpty()) {
                    //for getting the child account
                    for(Account eachParent : listOfAccounts){
                        if(!mapOfParentAllChild.containsKey(eachParent.parentId)){
                            mapOfParentAllChild.put(eachParent.ParentId,new List<Boolean>());
                        }
                        mapOfParentAllChild.get(eachParent.parentId).add(eachParent.Is_Brand__c);
                    }
                    if(!mapOfParentAllChild.isEmpty()){
                        List<Account> listOfParentAccounts = AccountSelector.getRecordById(mapOfParentAllChild.keySet()).values();
                        if(!listOfParentAccounts.isEmpty()){
                            for(Account each : listOfParentAccounts){
                                if(mapOfParentAllChild.containskey(each.Id) && mapOfParentAllChild.get(each.Id).contains(true)){
                                    each.Is_Parent_of_Prospect__c = false;
                                } else{
                                    if(each.RecordType.DeveloperName == 'Parent_Company'){
                                        each.Is_Parent_of_Prospect__c = true;
                                    }
                                }
                                accountstoUpdate.add(each);
                            } 
                            Update accountstoUpdate;
                        }
                    }   
                } 
            }  
        }
    }
  /**
    *  Method used for adding the Branding Guide / removing Branding Guide sharing
    *  @name addRemoveBrandingGuideSharing
    *  @param list<Account> listTriggerNew, map<id, Account> triggerOldMap
    *  @return void
   
    private static void addRemoveBrandingGuideSharing(list<Account> listTriggerNew, map<id, Account> triggerOldMap) {
        Map<Id, Account> mapOfNewAcctIds = new Map<Id,Account>();
        Map<Id, Account> mapOfOldAcctIds = new Map<Id,Account>();
        
        Map<Id, Account> mapOfOldAcctParent = new Map<Id,Account>();
        Map<Id, Account> mapOfNewAcctParent = new Map<Id,Account>();
        
    if(!listTriggerNew.isEmpty()){
            for(Account eachNewAccount : listTriggerNew) {
               if(
                     (triggerOldMap == null && eachNewAccount.RecordTypeId == PROSPECT_RECORDTYPE_ID && String.isNotBlank(eachNewAccount.parentId)) || 
                       (  triggerOldMap != null && 
                           (   
                               triggerOldMap.get(eachNewAccount.Id).ParentId != eachNewAccount.ParentId
                           ) &&
                           (
                              eachNewAccount.RecordTypeId == PROSPECT_RECORDTYPE_ID
                            )
                       ) 
                ){
                    // Accounts with parent id changed, removed or added
                    mapOfNewAcctIds.put(eachNewAccount.Id, eachNewAccount);
                    if(triggerOldMap!=null){
                        mapOfOldAcctIds.put(eachNewAccount.Id, triggerOldMap.get(eachNewAccount.Id));
                    }
                }
            }
            if(!mapOfNewAcctIds.isEmpty()){
                for(Account eachAccount : mapOfNewAcctIds.values()){
                    if(String.isBlank(eachAccount.ParentId) && !mapOfOldAcctIds.isEmpty()){
                        //if parent is removed
                        mapOfOldAcctParent.put(eachAccount.Id, mapOfOldAcctIds.get(eachAccount.Id));
                    } else if(String.isNotBlank(eachAccount.ParentId) && 
                              !mapOfOldAcctIds.isEmpty() && 
                              mapOfOldAcctIds.containsKey(eachAccount.Id) && 
                              String.isBlank(mapOfOldAcctIds.get(eachAccount.Id).ParentId)
                    ){ 
                        //if parent is added
                        mapOfNewAcctParent.put(eachAccount.Id, eachAccount);
                    } else if(String.isNotBlank(eachAccount.ParentId) && 
                              triggerOldMap==null
                    ){
                       mapOfNewAcctParent.put(eachAccount.Id, eachAccount);
                    } else if(String.isNotBlank(eachAccount.ParentId) && 
                              !mapOfOldAcctIds.isEmpty() && 
                              mapOfOldAcctIds.containsKey(eachAccount.Id) && 
                              String.isNotBlank(mapOfOldAcctIds.get(eachAccount.Id).ParentId)
                    ){
                       //if parent is changed
                       mapOfOldAcctParent.put(eachAccount.Id, mapOfOldAcctIds.get(eachAccount.Id));
                       mapOfNewAcctParent.put(eachAccount.Id, eachAccount);
                    }
                }
                removeBrandingGuideSharingForOldParent(mapOfOldAcctParent);
                insertBrandingGuideSharingForNewParent(mapOfNewAcctParent);
          }
        }
    }
    /**
    *  Method used for removing Branding Guide sharing for old parent account
    *  @name removeBrandingGuideSharingForOldParent
    *  @param Map<Id, Account> mapOfOldAcctParent
    *  @return void
    
    private static void removeBrandingGuideSharingForOldParent(Map<Id, Account> mapOfOldAcctParent) {
        
        Set<String> brandingGuideIdWithOldparent = new  Set<String> ();
        List<Branding_Guide__Share > recordToBeDeletedList = new List<Branding_Guide__Share >();
        
        if(!mapOfOldAcctParent.isEmpty()){
            List<Branding_Guide__c> listOfGuidesToRemove = BrandingGuideSelector.getBrandingGuideFromAccountId(mapOfOldAcctParent.keySet());
            if(!listOfGuidesToRemove.isEmpty()){
                for(Branding_Guide__c eachBG : listOfGuidesToRemove){
                    if(mapOfOldAcctParent.containsKey(eachBG.Account__c)){
                        brandingGuideIdWithOldparent.add(eachBG.Id+'-'+mapOfOldAcctParent.get(eachBG.Account__c).parentId);
                    }
                }
                
                if(!brandingGuideIdWithOldparent.isEmpty()){
                    recordToBeDeletedList.addAll(BrandingGuideHandler.removeBrandingGuideWithBrandUser(brandingGuideIdWithOldparent));
                    try{         
                        //remove sharing records for old parent
                        if(!recordToBeDeletedList.isEmpty()){
                            delete recordToBeDeletedList;
                        }
                    } catch(Exception ex){
                        system.debug('Error::'+ex.getMessage());
                    }
                }
            }
        }
    }
    /**
    *  Method used for adding Branding Guide sharing for new parent account
    *  @name insertBrandingGuideSharingForNewParent
    *  @param Map<Id, Account> mapOfNewAcctParent
    *  @return void
    
    private static void insertBrandingGuideSharingForNewParent(Map<Id, Account> mapOfNewAcctParent) {
        
        Set<String> brandingGuideIdWithNewparent = new  Set<String> ();
        List<Branding_Guide__Share > lstBrandingGuideShare = new List<Branding_Guide__Share >();
        
        if(!mapOfNewAcctParent.isEmpty()){ 
            List<Branding_Guide__c> listOfGuidesToAdd = BrandingGuideSelector.getBrandingGuideFromAccountId(mapOfNewAcctParent.keySet());
            if(!listOfGuidesToAdd.isEmpty()){
                for(Branding_Guide__c eachBG : listOfGuidesToAdd){
                    if(mapOfNewAcctParent.containsKey(eachBG.Account__c)){
                        brandingGuideIdWithNewparent.add(eachBG.Id+'-'+mapOfNewAcctParent.get(eachBG.Account__c).parentId);
                    }
                }
                
                if(!brandingGuideIdWithNewparent.isEmpty()){
                    lstBrandingGuideShare.addAll(BrandingGuideHandler.shareBrandingGuideWithParentUser(brandingGuideIdWithNewparent));
                    try{         
                        //insert sharing records for new parent
                        if(!lstBrandingGuideShare.isEmpty()){
                            insert lstBrandingGuideShare;
                        }
                    } catch(Exception ex){
                        system.debug('Error::'+ex.getMessage());
                    }
                }
            }
        }      
    }
    /**
    *  Method used for adding the new Account Owner to Library and revoke library access from old owner
    *  @name addRemoveAccessToLibrary
    *  @param list<Account> listTriggerNew, map<id, Account> triggerOldMap
    *  @return void
    *  @reference SF-4810
    
    private static void addRemoveAccessToLibrary(list<Account> listTriggerNew, map<id, Account> triggerOldMap) {
        map<Id, Id> mapOfOldOwner = new map<Id, Id>();
        map<Id, Id> mapOfNewOwner = new map<Id, Id>();
        if(!listTriggerNew.isEmpty()){
            for(Account eachNewAccount : listTriggerNew) {
                Account oldAccount= triggerOldMap.get(eachNewAccount.Id);
                if (oldAccount.OwnerId != null &&
                    eachNewAccount.OwnerId != null &&
                    oldAccount.OwnerId != eachNewAccount.OwnerId) {
                        mapOfOldOwner.put(eachNewAccount.Id, oldAccount.OwnerId);
                        mapOfNewOwner.put(eachNewAccount.Id, eachNewAccount.OwnerId );
                    }
            }
            if(!mapOfNewOwner.isEmpty() && !mapOfOldOwner.isEmpty()){
            addRemoveGrpAccessFuture(mapOfOldOwner, mapOfNewOwner);//extend Account Owner access to Account Team Group
            }
        }

    }
    
    /**
    *  Fetches the Group detail for the set of libraries
    *  @name getGroupDetail
    *  @param Set<String> setOfGrpNames
    *  @return map<String, Id>
    *  @reference SF-4810
    
    private static map<String, Id> getGroupDetail(Set<String> setOfGrpNames){
        map<String, Id> mapOfGroups = new map<String, Id>();
        List<Group> groupList = [SELECT name, id FROM Group where name in:setOFGrpNames ];
        for (Group eachGroup: groupList){
            mapOfGroups.put(eachGroup.name, eachGroup.Id);
        }

        return mapOfGroups;
    }
    
     /**
    *  Future method for adding/removing the Account Owner to Account Team Group
    *  @name addRemoveGrpAccessFuture
    *  @param map<Id, Id> mapOfOldOwner, map<Id, Id> mapOfNewOwner
    *  @return void
    *  @reference SF-4810
    
    @future
    private static void addRemoveGrpAccessFuture(map<Id, Id> mapOfOldOwner, map<Id, Id> mapOfNewOwner) {
        Set<GroupMember> toDeleteMemberSet = new Set<GroupMember>();
        list<GroupMember> toAddGroupMemberList = new list<GroupMember>();
        map<String, Id> mapOfGroups = new map<String, Id>();
        list<GroupMember> listOfGroupMembers = new list<GroupMember>();
        map<String, GroupMember> mapOfUniqueMember = new map<String, GroupMember>();
        
        try{
            Set<String> setOfGrpNames = new Set<String>();
            
            Map<Id, Account> mapOfAccount = AccountSelector.getRecordById(mapOfNewOwner.keySet());
            
            if(!mapOfAccount.isEmpty()){
                for(Account eachAccount: mapOfAccount.values()) {
                    String accTeamGrpName = BrandConfigHelper.getTeamGroupName(eachAccount.Id);
                    setOfGrpNames.add(accTeamGrpName);
                }
            }
            if(!setOfGrpNames.isEmpty()){
                mapOfGroups = getGroupDetail(setOfGrpNames);
            }
            
            list<AccountTeamMember> listOfAcctTeamMembers = AccountSelector.getAccountTeamByAccountId(mapOfOldOwner.keySet());
            Set<String> setOfAcctTeamMember = new Set<String>();
            if(!listOfAcctTeamMembers.isEmpty()){
                for(AccountTeamMember eachMember : listOfAcctTeamMembers) {
                    setOfAcctTeamMember.add(eachMember.UserId +'-'+ eachMember.AccountId);
                }
            }

            //fetch list of all the group members
            if(!mapOfGroups.isEmpty()){
                listOfGroupMembers = UserSelector.getGroupMemberByGroupId(mapOfGroups.values());
            }
           
            
            /**
            *  Remove the old Account Owner from the group only if
            *  1. It is a group member already,
            *  2. The owner is not part of the Account Team and,
            *  3. Group Member is not part of Account Team and Account owner? KEEP ACCOUNT TEAM OFF
      
            if(!listOfGroupMembers.isEmpty()){
                for(GroupMember eachMember : listOfGroupMembers) {
                    mapOfUniqueMember.put(eachMember.Group.Name + eachMember.UserOrGroupId, eachMember);
                    String accTeamGrpName = eachMember.group.name;
                    String accountId = eachMember.group.name.substringAfterLast('_');
                    if(
                        mapOfUniqueMember.containskey(accTeamGrpName + mapOfOldOwner.get(accountId)) &&
                        !setOfAcctTeamMember.contains(mapOfOldOwner.get(accountId) +'-'+ accountId)
                    ) {
                        //removes old owner, if it is not part of the Account Team
                        toDeleteMemberSet.add(mapOfUniqueMember.get(accTeamGrpName + mapOfOldOwner.get(accountId)));    
                    }
                    
                    if(
                        !setOfAcctTeamMember.contains(eachMember.UserOrGroupId +'-'+ accountId) && 
                        eachMember.UserOrGroupId != mapOfNewOwner.get(accountId) 
                    ) { 
                        //Removes group members which are neither part of the Account Team nor owns the account
                        toDeleteMemberSet.add(eachMember);
                    }
                }
            }
            
            //Add the new owner to the account team group if it is not already the group member
            
            for(Id eachAccount : mapOfNewOwner.keySet()) {
                String accTeamGrpName = BrandConfigHelper.getTeamGroupName(eachAccount);

                if(!mapOfUniqueMember.containskey(accTeamGrpName + mapOfNewOwner.get(eachAccount))){
                    GroupMember objMember = new GroupMember();
                    objMember.GroupId = mapOfGroups.get(accTeamGrpName);
                    objMember.UserOrGroupId = mapOfNewOwner.get(eachAccount);
                    toAddGroupMemberList.add(objMember);
                }
            }
  
            List<GroupMember> toDeleteMemberList = new List<GroupMember>(toDeleteMemberSet);//to eradicate duplicates
            
            if(!toAddGroupMemberList.isEmpty()){
                insert toAddGroupMemberList;
            }
            if(!toDeleteMemberList.isEmpty()){
                delete toDeleteMemberList;
            }

        } catch(Exception e){
             System.debug('Exception::'+e.getMessage());
        }
    }
    
    /*
    
    Method Name     : updateEncryptedId
    Purpose         : This method updates the encrypted id generated on the Account.
    Parameter       : Trigger.new, TriggerOldMap
    Return          : void
    created  Date   : 21/04/2019
    
    private static void updateEncryptedId(list<Account> listTriggerNew, map<id, Account> triggerOldMap){
        //For after Insert
        if(triggerOldMap == null) {
            List<Account> listAccRec = (List<Account>) JSON.deserialize(JSON.serialize(listTriggerNew), List<Account>.class);
            List<Account> listUpdateEncryptAccIds = generateEncryptedAccId(listAccRec,triggerOldMap);
            if(listUpdateEncryptAccIds != null && !listUpdateEncryptAccIds.isEmpty()) {
                update listUpdateEncryptAccIds;
            }
        } else {
            //For before update
            generateEncryptedAccId(listTriggerNew,triggerOldMap);
        }
    } 
    
    
    Method Name     : preventFromRejection
    Purpose         : This method prevents from rejection of PHQ CP Review process.
    Parameter       : Trigger.new, TriggerOldMap
    Return          : void
    
   
    private static void preventFromRejection(list<Account> listTriggerNew, map<id, Account> triggerOldMap){
        for(Account eachAccount : listTriggerNew) {
            string oldStatus = triggerOldMap.get(eachAccount.Id).PHQ_CP_Review_Status__c;
            if(eachAccount.PHQ_CP_Review_Status__c != oldStatus
              && eachAccount.PHQ_CP_Review_Status__c == 'Rejected') {
                eachAccount.addError(REJECTION_MESSAGE);
            }
        }
    }
    
    /*
  
    Method Name     : generateEncryptedAccId
    Purpose         : This method is used to generate the Encrypted Id.
    Parameter       : Trigger.new, TriggerOldMap
    Return          : void
    created  Date   : 21/04/2019
    
    private static List<Account> generateEncryptedAccId(list<Account> listAccRec,map<id, Account> triggerOldMap) {
        List<Account> listUpdateEncryptAccIds = New List<Account>();
        for(Account eachAcc : listAccRec){
            account accOld;
            if(triggerOldMap!=null){
               accOld = triggerOldMap.get(eachAcc.Id);
            }else{
                accOld = null;
            }
            //if(eachAcc.recordTypeId == DE_RECORDTYPEBRAND && string.isNotBlank(eachAcc.DE_Verification_Code_c__c)
            if(eachAcc.recordTypeId == DE_RECORDTYPEBRAND && string.isBlank(eachAcc.DE_EncryptAccountId__c) &&
               string.isNotBlank(eachAcc.DE_Verification_Code_c__c)
               && (accOld == null || (accOld != null && eachAcc.DE_Verification_Code_c__c != accOld.DE_Verification_Code_c__c))){
                   Blob cryptoKey = EncodingUtil.base64Decode(label.recaptchaCryptoKey);// In label store a key
                   Blob data = Blob.valueOf(eachAcc.Id);                
                   Blob encryptedData = Crypto.encryptWithManagedIV('AES128', cryptoKey, data);
                   String b64Data = EncodingUtil.base64Encode(encryptedData);
                   eachAcc.DE_EncryptAccountId__c = b64Data;
                   listUpdateEncryptAccIds.add(eachAcc);
               }
        }   
        return listUpdateEncryptAccIds;
    }
    
    /*
   
    Method Name     : applyDefault
    Purpose         : This method updates the default values on before trigger
    Parameter       : Trigger.new, TriggerOldMap
    Return          : void
    created  Date   : 10/15/2019
   
    private static void applyDefault(list<Account> listTriggerNew, map<id, Account> triggerOldMap) {
        for(Account eachAcount : listTriggerNew) {
            eachAcount.Connectivity_Method_History__c = eachAcount.Connectivity_Method__c;
        }
    }
 */  
}