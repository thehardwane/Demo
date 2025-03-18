public class AccountSelector {
    /**


public without sharing class AccountSelector {

    /**
    *  get Account detail from account Id
    *  @name getRecordById
    *  @param Set<Id> accountId
    *  @return map<Id, Account>
    
    public static map<Id, Account> getRecordById(Set<Id> accountId) {
       return(new map<Id, Account>([
            SELECT Id, Name, okta_group_id__c, parentId, Is_Parent_of_Prospect__c, Brand_Name__c, Is_Brand__c, Testing_Agreement__c, RecordType.DeveloperName, //SF-4810 : Added Owner Id
            OwnerId
            FROM Account
            WHERE Id IN : accountId
        ]));
    }
    /**
*  get Account detail where IsBrand is True
*  @name getAccountId
*  @param
*  @return List<Account>

    public static List<Account> getActiveBrands() {
        return [
            SELECT Id , Brand_Name__c
            FROM Account
            WHERE Is_Brand__c = True
        ];
    }
    
        /**
*  get Account detail where IsBrand is True
*  @name getAccountId
*  @param
*  @return List<Account>

    public static List<Account> getActiveBrandRecordType() {
        return[
            SELECT Id , Brand_Name__c
            FROM Account
            WHERE Is_Brand__c = True
            AND RecordType.DeveloperName =: System.label.ACCOUNT_BRAND_RT_DEV_NAME
            ORDER BY Brand_Name__c ASC 
        ];
    }
    /**
*  get AccountTeam record by Id
*  @name getAccountTeamById
*  @param Set<Id>
*  @return List<AccountTeamMember>

    public static list<AccountTeamMember> getAccountTeamById(Set<Id> accountTeamId) {
        return [
            SELECT Id, AccountId, UserId
            FROM AccountTeamMember
            WHERE Id in :accountTeamId
        ];
    }
    /**
    *  get AccountTeam record by user Id
    *  @name getAccountTeamByUserId
    *  @param Set<Id>
    *  @return List<AccountTeamMember>
   
    public static list<AccountTeamMember> getAccountTeamByUserId(Set<Id> setUserId) {
        return [
            SELECT Id, AccountId, UserId,Account.Recordtype.DeveloperName,
            Account.ParentId,Account.Parent.RecordType.DeveloperName
            FROM AccountTeamMember
            WHERE UserId in :setUserId
        ];
    }
    
      /**
*  get AccountTeam record by user Id
*  @name getAccountTeamByAccountId
*  @param Set<Id>
*  @return List<AccountTeamMember>


    public static list<AccountTeamMember> getAccountTeamByAccountId(Set<Id> setOfAccountId) {
        return [
            SELECT Id, UserId, AccountId
            FROM AccountTeamMember
            WHERE AccountId in: setOfAccountId
        ];
    }

    /**
    *  get the list of brand account ids from the account set
    *  @name getRecordByRecordType
    *  @param Set<Id> accountId
    *  @return set<Id>
  
    public static Set<Id> getBrandAccounts(Set<Id> accountId) {
        Map<Id, Account> mapOfAccounts = new Map<Id, Account>([
            SELECT Id
            FROM Account
            WHERE Id IN :accountId
            AND (RecordType.DeveloperName =: System.label.ACCOUNT_BRAND_RT_DEV_NAME
            OR RecordType.DeveloperName =: System.label.PARENT_BRAND_RT_DEV_NAME)
        ]);
        return mapOfAccounts.keySet();
    }
    
    /**
    *  get the list of brand account ids from the account set
    *  @name getRecordByRecordType
    *  @param Set<Id> accountId
    *  @return set<Id>
    *  @reference digital onboarding
    * 
    public static Set<Id> getBrandAndProspectAccounts(Set<Id> accountId) {
        Map<Id, Account> mapOfAccounts = new Map<Id, Account>([
            SELECT Id
            FROM Account
            WHERE Id IN :accountId
            AND (RecordType.DeveloperName =: System.label.ACCOUNT_BRAND_RT_DEV_NAME
            OR RecordType.DeveloperName =: System.label.PARENT_BRAND_RT_DEV_NAME
            OR RecordType.DeveloperName =: System.label.PROSPECT_RT_DEV_NAME)
        ]);
        return mapOfAccounts.keySet();
    }
    /**
    *  get the list of brand info corresponding to input Account Id
    *  @name getBrandByAccountId
    *  @param String
    *  @return List<Account>
   
    public static List<Account> getBrandByAccountId(String accountId) {
        return [
                SELECT Id, Is_Brand__c, Name, Brand_Name__c
                FROM Account
                WHERE Id = :accountId
                AND (RecordType.DeveloperName =: System.label.ACCOUNT_BRAND_RT_DEV_NAME
                OR RecordType.DeveloperName =: System.label.PARENT_BRAND_RT_DEV_NAME)
        ];
    }
    /**
    *  get the list of Account with record type as Brand
    *  @name getAccountbyRecordType
    *  @param none
    *  @return List<Account>

    public static List<Account> getAccountbyRecordType() {
        return [
            SELECT Id,Brand_Name__c
            FROM Account
            WHERE Is_Brand__c = TRUE AND
            Brand_Name__c != NULL AND
            (RecordType.DeveloperName =:System.label.ACCOUNT_BRAND_RT_DEV_NAME OR
            RecordType.DeveloperName =:System.label.PARENT_BRAND_RT_DEV_NAME)
            ORDER BY Brand_Name__c
        ];
    }
    /**
    *  get the list of Account with record type as Brand with parent Id
    *  @name getAccountByParentId
    *  @param none
    *  @return List<Account>
    *  @reference SF
    
    public static List<Account> getAccountByParentId(Set<Id> setOfAccountId) {
        return [
            SELECT Name, Id, ParentId, Brand_Name__c, Is_Brand__c
            FROM Account
            WHERE ParentId IN : setOfAccountId
        ];
    }
    /**
    *  get the list of Account with record type as Brand
    *  @name getAccountByParent
    *  @param none
    *  @return List<Account>
    *  @reference 
    
    public static List<Account> getAccountByParent() {
        return [
                SELECT Id,Brand_Name__c FROM Account WHERE Is_Brand__c = TRUE
                AND Brand_Name__c != NULL
                AND ( (RecordType.DeveloperName =:System.label.ACCOUNT_BRAND_RT_DEV_NAME
                        AND ParentId = null)
                        OR RecordType.DeveloperName =:System.label.PARENT_BRAND_RT_DEV_NAME)
                ORDER BY Brand_Name__c
        ];
    }
    /**
    *  get the list of Account which having ParentId as Parent Brand Account
    *  @name getAllChildAccountByParentBrand
    *  @param Set<Id> accountIds
    *  @return List<Account>
    *  @reference 
    
    public static List<Account> getAllChildAccountByParentBrand(Set<Id> accountIds) {
        return [
                SELECT Id,Name,Brand_Name__c,ParentId FROM Account 
                WHERE Parent.RecordType.Developername =:System.label.PARENT_BRAND_RT_DEV_NAME
                AND ParentId IN :accountIds
        ];
    }
     /*
        @Author : Aman Kumar
        @CreateDate : 04-11-2020
        @Description :This method is used fetch the brand name 
        @Version 1.0
    */ 
    public static List<Account> fetchBrandName()
    {
        return [
                SELECT id , Name 
                FROM Account 
                WHERE RecordType.Name =:'Brand' 
                ORDER BY Name
        ];
    }

    /*
        @Author : Aman Kumar
        @CreateDate : 04-11-2020
        @Description :This method is used fetch the All brands based on Id 
        @Version 1.0
    
    public static List<Account> fetchBrandNameBasedOnId(List<Id> accId)
    {
        return [
                SELECT Id , Name 
                FROM Account 
                WHERE RecordType.Name =:'Brand' 
                AND Id 
                IN:accId 
                ORDER BY Name
        ];
    }
}
*/
}