public without sharing class AccountContactRelationHandler {
/**
    public void runTrigger(){
        // Method will be called to handle After Insert AccountContactRelations
        if(Trigger.isAfter && Trigger.isInsert) {
            onAfterInsert((list<AccountContactRelation>)trigger.new,(Map<Id,AccountContactRelation>)trigger.newMap);
        }
        // Method will be called to handle After Update AccountContactRelations
        if(Trigger.isAfter && Trigger.isUpdate) {
            onAfterUpdate((list<AccountContactRelation>)trigger.new,(Map<Id,AccountContactRelation>) trigger.oldMap,
                          (Map<Id,AccountContactRelation>) trigger.newMap);
        }
        // Method will be called to handle After Delete AccountContactRelations
        if(Trigger.isAfter && Trigger.isDelete) {
            onAfterDelete((list<AccountContactRelation>)trigger.old,(Map<Id,AccountContactRelation>) trigger.oldMap);
        }
    }

    private void onAfterInsert(list<AccountContactRelation> listTriggerNew,Map<Id,AccountContactRelation> newMap) {
        createGroupMembers(listTriggerNew);
        updateRelatedBrand(listTriggerNew);
    }

    private void onAfterUpdate(list<AccountContactRelation> listTriggerNew,Map<Id,AccountContactRelation> oldMap,Map<Id,AccountContactRelation> newMap) {
        updateGroupMembers(listTriggerNew,oldMap,newMap);
    }

    private void onAfterDelete(list<AccountContactRelation> listTriggerOld,Map<Id,AccountContactRelation> oldMap) {
        removeUsersFromGroup(listTriggerOld,null);
        updateRelatedBrand(listTriggerOld);
    }

    /**
    *  Method used for updating the group members according to AccountContactRelations
    *  @name fetchUserFromContacts
    *  @param list<AccountContactRelation> listTriggerNew,Map<Id,AccountContactRelation> oldMap
    *  @return void
   
    private void updateGroupMembers(list<AccountContactRelation> listTriggerNew,Map<Id,AccountContactRelation> oldMap,Map<Id,AccountContactRelation> newMap) {
        //local variable
        List<AccountContactRelation> lstOldAccountContactRelation = new List<AccountContactRelation>();
        List<AccountContactRelation> lstNewAccountContactRelation = new List<AccountContactRelation>();
        //end

        for(AccountContactRelation eachACR : listTriggerNew){
            //checking conditions to remove users from group
            //version 2.0 : added Partner Portal condition
            if((oldMap.get(eachACR.Id).Report_Access__c != eachACR.Report_Access__c ||
                (oldMap.get(eachACR.Id).Partner_Portal_Access__c &&
                 !eachACR.Partner_Portal_Access__c)
               ) &&
               String.isNotBlank(oldMap.get(eachACR.Id).Brand_Name__c) &&
               !oldMap.get(eachACR.Id).IsDirect
              ){
                  //adding accountcontact from which user will be removed from public group
                  lstOldAccountContactRelation.add(oldMap.get(eachACR.Id));
              }
            //checking conditions to add users in the group
            if( (oldMap.get(eachACR.Id).Report_Access__c != eachACR.Report_Access__c ||
                 (!oldMap.get(eachACR.Id).Partner_Portal_Access__c && eachACR.Partner_Portal_Access__c) ||
                 oldMap.get(eachACR.Id).Last_Sync__c != eachACR.Last_Sync__c
                ) &&
               String.isNotBlank(eachACR.Brand_Name__c) &&
               !eachACR.IsDirect
              ){
                  lstNewAccountContactRelation.add(eachACR);
              }
        }
        //calling generic function to add/remove group members
        createGroupMembers(lstNewAccountContactRelation);
        removeUsersFromGroup(lstOldAccountContactRelation,newMap);
    }

    /**
    *  Method used for fetching users from contactIds
    *  @name fetchUserFromContacts
    *  @param list<AccountContactRelation>
    *  @return Map<Id,Id>
       private static Map<Id,Id> fetchUserFromContacts(list<AccountContactRelation> listACR){
        //local varibale
        Set<Id> setOfContactIds = new Set<Id>();
        Map<Id,Id> mapOfContactWithUserId = new Map<Id,Id>();
        //end
        for(AccountContactRelation eachACR : listACR){
            //relationship should be Indirect and brand name must exists
            if(!eachACR.IsDirect && String.isNotBlank(eachACR.Brand_Name__c)){
                setOfContactIds.add(eachACR.ContactId);
            }
        }
        //checking contactid is not null
        if(!setOfContactIds.isEmpty()){
            //fetching all community users
            List<User> lstUsers = UserSelector.getAllCommunityUsers(setOfContactIds);
            if(!lstUsers.isEmpty()){
                for(User eachuser : lstUsers){
                    //creating a map of contact with userid
                    mapOfContactWithUserId.put(eachuser.ContactId,eachUser.Id);
                }
            }
        }
        return mapOfContactWithUserId;
    }

    /**
    *  Method used for adding the group member to the access group
    *  @name addUserstoGroup
    *  @param Set<Id> setOfACRId,Map<Id,Id> mapOfContactWithUserId
    *  @return void
    
    public static void createGroupMembers(list<AccountContactRelation> listAccountContactRelation){
        Set<String> setOfUserIdWithGroupId = new Set<String>();
        //fetching map of contactid with userid
        Map<Id,Id> mapOfContactWithUserId = fetchUserFromContacts(listAccountContactRelation);
        //fetch metadata consists of records which gives library access
    Map<String, Report_Access__mdt> mapOfMetadata =  fetchCustomMetadata();

        if(mapOfMetadata.isEmpty()){
            return;
        }
        //fetching map of groupname with its associated Ids
        Map<String, Id> mapOfGroup = getGroupMap(listAccountContactRelation);
        //fetching all existing group members
        Map<String,Id> mapOfKeyWithMemberId = getExistingMembers(mapOfGroup,mapOfContactWithUserId);
        list<GroupMember> listGroupMember = new list<GroupMember>();
        //iterating ACR records and adding user to its related group based upon access
        for(AccountContactRelation eachACR : listAccountContactRelation){
            String accessLevel = eachACR.Report_Access__c;
            String nonLibraryGroupName = getGroupName(eachACR);
            //logic for adding user in non-library group 
            //version 2.0 : applied Partner Portal Check
            if( eachACR.Partner_Portal_Access__c &&
                mapOfGroup.containsKey(nonLibraryGroupName) &&
                mapOfContactWithUserId.containsKey(eachACR.ContactId) &&
                !mapOfKeyWithMemberId.containsKey(mapOfGroup.get(nonLibraryGroupName)+'-'+mapOfContactWithUserId.get(eachACR.ContactId))
              ) {
                  setOfUserIdWithGroupId.add(mapOfGroup.get(nonLibraryGroupName)+'-'+mapOfContactWithUserId.get(eachACR.ContactId));
            }
            //logic for add user in library group
            //version 2.0 : applied Partner Portal Check
            if( eachACR.Partner_Portal_Access__c &&
               mapOfMetadata.containsKey(accessLevel) && 
               !eachACR.IsDirect && 
               String.isNotBlank(eachACR.Brand_Name__c)  
              ) {
                  String standardReportAPIName = BrandConfigHelper.getLibraryAPIName(eachACR.Brand_Name__c, eachACR.AccountId, label.STANDARD_REPORT_API);
                  String privilegeReportAPIName = BrandConfigHelper.getLibraryAPIName(eachACR.Brand_Name__c, eachACR.AccountId, label.PRIVILEGE_REPORT_API);
                  
                  if( mapOfMetadata.containsKey(accessLevel) &&
                      String.isNotBlank(mapOfMetadata.get(accessLevel).Access_Level__c) &&
                      mapOfMetadata.get(accessLevel).Access_Level__c.equalsIgnoreCase('Non Confidential') &&
                      mapOfGroup.containsKey(standardReportAPIName) &&
                      mapOfContactWithUserId.containsKey(eachACR.ContactId) &&
                     !mapOfKeyWithMemberId.containsKey(mapOfGroup.get(standardReportAPIName)+'-'+mapOfContactWithUserId.get(eachACR.ContactId))
                    ) {
                        setOfUserIdWithGroupId.add(mapOfGroup.get(standardReportAPIName)+'-'+mapOfContactWithUserId.get(eachACR.ContactId));
                    }
                  if(mapOfMetadata.containsKey(accessLevel) &&
                     String.isNotBlank(mapOfMetadata.get(accessLevel).Access_Level__c) &&
                     mapOfMetadata.get(accessLevel).Access_Level__c.equalsIgnoreCase('Confidential') &&
                     mapOfGroup.containsKey(privilegeReportAPIName) &&
                     mapOfContactWithUserId.containsKey(eachACR.ContactId) &&
                     !mapOfKeyWithMemberId.containsKey(mapOfGroup.get(privilegeReportAPIName)+'-'+mapOfContactWithUserId.get(eachACR.ContactId))
                    ) {
                        setOfUserIdWithGroupId.add(mapOfGroup.get(privilegeReportAPIName)+'-'+mapOfContactWithUserId.get(eachACR.ContactId));
                    }
              }
        }
        if(!setOfUserIdWithGroupId.isEmpty()){
            //calling future method
            insertGroupMembers(setOfUserIdWithGroupId);
        }
    }
    
    /**
    *  Method used for inserting the group members with future method
    *  @name insertGroupMembers
    *  @param Set<String> setOfUserIdWithGroupId
    *  @return void
    
    @future 
    public static void insertGroupMembers(Set<String> setOfUserIdWithGroupId){
        //local variables
        list<GroupMember> listGroupMember = new list<GroupMember>();
        
        for(String groupIdWithUserId : setOfUserIdWithGroupId){
            //splitting the string in groupId and UserId
            List<String> idsList= groupIdWithUserId.split('-');
            //after splitting, list not null then populating group members list
            if(idsList != null && idsList.size() > 0){
                GroupMember objMember = new GroupMember();
                objMember.GroupId = idsList[0];
                objMember.UserOrGroupId = idsList[1];
                listGroupMember.add(objMember);
            }
        }
        //checking list size greater then 0 and inserting group members
        if(!listGroupMember.isEmpty()) {            
            insert listGroupMember;
        }
    }

    /**
    *  Method used for fetching custom settings records
    *  @name fetchCustomSettingsData
    *  @param
    *  @return map<String, Report_Access__mdt>
   
    private static Map<String, Report_Access__mdt> fetchCustomMetadata(){

         list<Report_Access__mdt> listMetadata = [
            SELECT Id, MasterLabel, Access_Level__c
            FROM Report_Access__mdt
            WHERE Access_Level__c != null
        ];
        map<String, Report_Access__mdt> mapOfMetadata = new map<String, Report_Access__mdt>();
        for(Report_Access__mdt eachReportAccess : listMetadata) {
            mapOfMetadata.put(eachReportAccess.MasterLabel, eachReportAccess);
        }
        return mapOfMetadata;
    }

     /**
    *  method used for getting the group map
    *  @name getGroupMap
    *  @param list<User> listUser
    *  @return map<String, Id>
    *  @throws exception
    
    private static map<String, Id> getGroupMap(list<AccountContactRelation> listAccountContactRelation) {

        set<String> setOfGroupName = new set<String>();
        for(AccountContactRelation eachRelation : listAccountContactRelation) {
            //storing all group names in a set
            if(!eachRelation.IsDirect && String.isNotBlank(eachRelation.Brand_Name__c)){
                setOfGroupName.add(
                    BrandConfigHelper.getLibraryAPIName(eachRelation.Brand_Name__c, eachRelation.AccountId, label.STANDARD_REPORT_API)
                );
                setOfGroupName.add(
                    BrandConfigHelper.getLibraryAPIName(eachRelation.Brand_Name__c, eachRelation.AccountId, label.PRIVILEGE_REPORT_API)
                );
                setOfGroupName.add(
                    getGroupName(eachRelation)
                );
            }
        }

        //fetching group records from its name
        list<Group> listOfGroup = [SELECT Id, DeveloperName, Name
                                   FROM Group
                                   WHERE Type = 'Regular'
                                   AND Name IN: setOfGroupName];
        map<String, Id> mapOfGroup = new map<String, Id>();
        if(!listOfGroup.isEmpty()) {
            for(Group eachGroup : listOfGroup) {
                mapOfGroup.put(eachGroup.Name, eachGroup.Id);
            }
        }
        return mapOfGroup;
    }

     /**
    *  return the public group name associated with the account
    *  @name getGroupName
    *  @param Account objAccount
    *  @return string
    
    public static string getGroupName(AccountContactRelation objACR) {
        String groupName = 'NA';
        if(String.isNotBlank(objACR.Brand_Name__c)) {
            if(objACR.Brand_Name__c.length() > 10) {
                groupName = objACR.Brand_Name__c.substring(0, 10);
            } else {
                groupName = objACR.Brand_Name__c;
            }
        }
        groupName += '-'+objACR.AccountId;
        return groupName;
    }

     /**
    *  return the existing member of public groups
    *  @name getExistingMembers
    *  @param Map<String, Id> mapOfGroup Map<Id,Id> mapOfContactWithUserId
    *  @return Set<String>
    
    public static Map<String,Id> getExistingMembers(Map<String, Id> mapOfGroup,Map<Id,Id> mapOfContactWithUserId) {
        Map<String,Id> mapOfKeyWithMemberId = new Map<String,Id>();
        //querying all existing members
        list<GroupMember> listExistingMembers = [
            SELECT Id, GroupId, UserOrGroupId, Group.Name
            FROM GroupMember
            WHERE GroupId IN : mapOfGroup.values()
            AND UserOrGroupId IN : mapOfContactWithUserId.values()
        ];
        //
        if(!listExistingMembers.isEmpty()){
            for(GroupMember eachMember : listExistingMembers){
                mapOfKeyWithMemberId.put(eachMember.GroupId+'-'+eachMember.UserOrGroupId, eachMember.Id);
            }
        }
        return mapOfKeyWithMemberId;
    }


    /**
    *  adding User to the groups which having indirect relationships
    *  @name addUserstoGroup
    *  @param list<AccountContactRelation> listTriggerNew
    *  @return Void
   
    public static void removeUsersFromGroup(list<AccountContactRelation> listTriggerOld,Map<Id,AccountContactRelation> newMap){
    Set<String> setOfGroupMemberId = new Set<String>();
        list<GroupMember> listGroupMembers = new list<GroupMember>();

        //fetching custom metadata
        Map<String, Report_Access__mdt> mapOfMetadata =  fetchCustomMetadata();

        if(mapOfMetadata.isEmpty()){
            return;
        }
        //fetching user from contacts
        Map<Id,Id> mapOfContactWithUserId = fetchUserFromContacts(listTriggerOld);
        //fetching related groups
        Map<String, Id> mapOfGroup = getGroupMap(listTriggerOld);
        //fetching all existing group members
        Map<String,Id> mapOfKeyWithMemberId = getExistingMembers(mapOfGroup,mapOfContactWithUserId);
        
        for(AccountContactRelation eachACR: listTriggerOld){
            String accessLevel = eachACR.Report_Access__c;
            String nonLibraryGroupName = getGroupName(eachACR);
            //logic for removing user in non-library group
            if( !(newMap != null &&  
                  newMap.get(eachACR.Id) != null &&
                  eachACR.Report_Access__c != newMap.get(eachACR.Id).Report_Access__c) &&
                mapOfGroup.containsKey(nonLibraryGroupName) &&
                mapOfContactWithUserId.containsKey(eachACR.ContactId) &&
                mapOfKeyWithMemberId.containsKey(mapOfGroup.get(nonLibraryGroupName)+'-'+mapOfContactWithUserId.get(eachACR.ContactId))
              ){
                  setOfGroupMemberId.add(mapOfKeyWithMemberId.get(mapOfGroup.get(nonLibraryGroupName)+'-'+mapOfContactWithUserId.get(eachACR.ContactId)));
            }
            //logic for remove user from library group
            if(mapOfMetadata.containsKey(accessLevel) && !eachACR.IsDirect && String.isNotBlank(eachACR.Brand_Name__c)) {
                
                String standardReportAPIName = BrandConfigHelper.getLibraryAPIName(eachACR.Brand_Name__c, eachACR.AccountId, label.STANDARD_REPORT_API);
              String privilegeReportAPIName = BrandConfigHelper.getLibraryAPIName(eachACR.Brand_Name__c, eachACR.AccountId, label.PRIVILEGE_REPORT_API);

                if(mapOfMetadata.containsKey(accessLevel) &&
                   String.isNotBlank(mapOfMetadata.get(accessLevel).Access_Level__c) &&
                   mapOfMetadata.get(accessLevel).Access_Level__c.equalsIgnoreCase('Non Confidential') &&
                   mapOfGroup.containsKey(standardReportAPIName) &&
                   mapOfContactWithUserId.containsKey(eachACR.ContactId) &&
                   mapOfKeyWithMemberId.containsKey(mapOfGroup.get(standardReportAPIName)+'-'+mapOfContactWithUserId.get(eachACR.ContactId))
                  ) {
                      setOfGroupMemberId.add(mapOfKeyWithMemberId.get(mapOfGroup.get(standardReportAPIName)+'-'+mapOfContactWithUserId.get(eachACR.ContactId)));
                }
                if(mapOfMetadata.containsKey(accessLevel) &&
                   String.isNotBlank(mapOfMetadata.get(accessLevel).Access_Level__c) &&
                   mapOfMetadata.get(accessLevel).Access_Level__c.equalsIgnoreCase('Confidential') &&
                   mapOfGroup.containsKey(privilegeReportAPIName) &&
                   mapOfContactWithUserId.containsKey(eachACR.ContactId) &&
                   mapOfKeyWithMemberId.containsKey(mapOfGroup.get(privilegeReportAPIName)+'-'+mapOfContactWithUserId.get(eachACR.ContactId))
                  ) {
                      setOfGroupMemberId.add(mapOfKeyWithMemberId.get(mapOfGroup.get(privilegeReportAPIName)+'-'+mapOfContactWithUserId.get(eachACR.ContactId)));
                }
            }
        }
        if(!setOfGroupMemberId.isEmpty()){
            //calling future method
            deleteGroupMember(setOfGroupMemberId);
        }
    }
    
    /**
    *  Method used for deleting the group members with future method
    *  @name deleteGroupMember
    *  @param Set<String> setOfUserIdWithGroupId
    *  @return void
   
    @future 
    public static void deleteGroupMember(Set<String> setOfGroupMemberId){
        //local variables
        list<GroupMember> listGroupMember = new list<GroupMember>();
        
        for(String groupIdWithUserId : setOfGroupMemberId){  
            GroupMember objMember = new GroupMember();
            objMember.Id = groupIdWithUserId;
            listGroupMember.add(objMember);
        }
        //deleting group members
        if(!listGroupMember.isEmpty()) {            
            delete listGroupMember;
        }
    }

    /**
    *  method used for update the brand names on contact
    *  @name updateRelatedBrand
    *  @param list<AccountContactRelation> listTriggerNew
    *  @return Void
    
    private void updateRelatedBrand(list<AccountContactRelation> listTriggerNew) {
        Set<Id> setofContactid = new Set<Id>();
        for(AccountContactRelation eachRelation : listTriggerNew) {
            if(String.isNotBlank(eachRelation.ContactId) && !eachRelation.IsDirect) {
                setofContactid.add(eachRelation.ContactId);
            }
        }
        if(!setofContactid.isEmpty()) {
            List<AccountContactRelation> listAllRelation = AccountContactRelationSelector.getRelationByContactId(setofContactid);
            if(!listAllRelation.isEmpty()) {
                Map<Id, List<String>> mapOfBrandNames = fetchRelatedBrands(listAllRelation);
                List<Contact> listContact = new List<Contact>();
                for(Id eachContactId : setofContactid) {
                    Contact objContact = new Contact();
                    objContact.Id = eachContactId;
                    if(mapOfBrandNames.containsKey(eachContactId) && !mapOfBrandNames.get(eachContactId).isEmpty()) {
                        objContact.Related_Brand_Names__c = String.join(mapOfBrandNames.get(eachContactId), ', ');
                    } else {
                        objContact.Related_Brand_Names__c = null;
                    }
                    listContact.add(objContact);
                }
                if(!listContact.isEmpty()) {
                    update listContact;
                }
            }
        }
    }

    /**
    *  method used for returning the contact id with related brand names
    *  @name fetchRelatedBrands
    *  @param list<AccountContactRelation> listAllRelation
    *  @return Map<Id, List<String>>
    
    private Map<Id, List<String>> fetchRelatedBrands(list<AccountContactRelation> listAllRelation) {
        Map<Id, List<String>> mapOfBrandNames = new Map<Id, List<String>>();
        for(AccountContactRelation eachRelation : listAllRelation) {
            if(!eachRelation.IsDirect && String.isNotBlank(eachRelation.AccountId) && eachRelation.Account.Is_Brand__c) {
                if(!mapOfBrandNames.containsKey(eachRelation.ContactId)) {
                    mapOfBrandNames.put(eachRelation.ContactId, new List<String>());
                }
                mapOfBrandNames.get(eachRelation.ContactId).add(eachRelation.Account.Name);
            }
        }
        return mapOfBrandNames;
    }
*/
}