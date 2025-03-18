public without sharing class AccountContactRelationSelector {
    /**
    *  get Account detail from account Id
    *  @name getRelationById
    *  @param Set<Id> accountId
    *  @return map<Id, Account>
    
    public static List<AccountContactRelation> getRelationById(Set<Id> setofChildAcc) {
        List<AccountContactRelation> lstAccContRel = [
            SELECT AccountId, ContactId, Id, IsDirect, Report_Access__c,Partner_Portal_Access__c,
            Contact.Is_Training_User__c, Account.Name
            FROM AccountContactRelation
            WHERE AccountId IN : setofChildAcc
        ];
        return lstAccContRel;
    }
    
    /**
    *  get ACR detail from contact Id
    *  @name getRelationByContactId
    *  @param Set<Id> contactId
    *  @return List<AccountContactRelation>
   
    public static List<AccountContactRelation> getRelationByContactId(Set<Id> contactId) {
        List<AccountContactRelation> listRelation = [
            SELECT AccountId, ContactId, Id, IsDirect, Account.Name, Account.Is_Brand__c
            FROM AccountContactRelation
            WHERE ContactId IN : contactId
        ];
        return listRelation;
    }
    
    /**
    *  get ACR detail from contact Id
    *  @name getIndirectRelationByContactId
    *  @param Set<Id> contactId
    *  @return List<AccountContactRelation>
   
    public static List<AccountContactRelation> getIndirectRelationByContactId(Set<Id> contactId) {
        List<AccountContactRelation> listRelation = [
            SELECT AccountId, ContactId, Id, IsDirect, Account.Name, Account.Is_Brand__c, Partner_Portal_Access__c,Account.Brand_Name__c
            FROM AccountContactRelation
            WHERE ContactId IN : contactId
            AND IsDirect = FALSE
            AND Account.Brand_Name__c != null
        ];
        return listRelation;
    }
    /**
    *  get ACR detail from contact Id
    *  @name getIndirectRelationByContactId
    *  @param Set<Id> contactId
    *  @return List<AccountContactRelation>
    *  @For SSTE 
 
    public static List<AccountContactRelation> getNondirectRelationByContactId(Set<Id> contactId) {
        List<AccountContactRelation> listRelation = [
            SELECT AccountId, ContactId, Id, IsDirect, Account.Name, Account.Is_Brand__c, Partner_Portal_Access__c,Account.Brand_Name__c
            FROM AccountContactRelation
            WHERE ContactId IN : contactId             
            AND Account.Brand_Name__c != null
        ];
        return listRelation;
    }
    
    /**
    *  get Account Contact Relation detail from Contact and Account
    *  @name getRelationByContactAndAccount
    *  @param Id contactId, List<Id> listOfAccountIds
    *  @return List<AccountContactRelation>
   
    public static List<AccountContactRelation> getRelationByContactAndAccount(Id contactId, List<Id> listOfAccountIds) {
        List<AccountContactRelation> lstAccContRel = [
            SELECT Id,AccountId,Account.Brand_Name__c
            FROM AccountContactRelation
            WHERE ContactId = :contactId
            AND AccountId NOT IN :listOfAccountIds
            AND Partner_Portal_Access__c = true
            AND IsDirect = false
        ];
        return lstAccContRel;
    }
    
    /**
    *  get Account Contact Relation detail from Contact ids
    *  @name getIndirectACRByContactId
    *  @param Set<Id> setOfContactId
    *  @return List<AccountContactRelation>
    
    public static List<AccountContactRelation> getIndirectACRByContactId(Set<Id> setOfContactId) {
        List<AccountContactRelation> lstAccContRel = [
            SELECT AccountId, ContactId, Id, IsDirect, Account.Brand_Name__c, Account.Is_Brand__c, Account.Id
            FROM AccountContactRelation
            WHERE ContactId IN :setOfContactId
            AND IsDirect = false
            AND IsActive = true
        ];
        return lstAccContRel;
    }
    /**
    *  @module : Training
    *  get Account detail from Account Id
    *  @name getRelationByAccount
    *  @param Set<Id> setofChildAcc
    *  @return List<AccountContactRelation>
    
    public static List<AccountContactRelation> getRelationByAccount(Set<Id> setofChildAcc) {
        List<AccountContactRelation> lstAccContRel = [
            SELECT AccountId, ContactId, Id
            FROM AccountContactRelation
            WHERE AccountId IN : setofChildAcc
            AND ( IsDirect = true OR
                  Partner_Portal_Access__c = true )
        ];
        return lstAccContRel;
    }

    /**
    *  get Account Contact Relation detail from Contact and Account
    *  @name getIndirectContactAndAccount
    *  @param Id contactId, List<Id> listOfAccountIds
    *  @return Set<AccountContactRelation>
   
    public static List<AccountContactRelation> getIndirectContactAndAccount(Id contactId, Set<Id> setOfAccountIds) {
        List<AccountContactRelation> lstAccContRel = [
            SELECT Id,AccountId,Account.Brand_Name__c
            FROM AccountContactRelation
            WHERE ContactId = :contactId
            AND AccountId IN :setOfAccountIds
            AND Partner_Portal_Access__c = true
            AND IsDirect = false
        ];
        return lstAccContRel;
    }
 */
}