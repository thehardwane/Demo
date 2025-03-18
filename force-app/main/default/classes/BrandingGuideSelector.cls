public without sharing class BrandingGuideSelector {
    /**
    *  get BrandingGuide__Share object records
    *  @name getBrandingGuideSharing
    *  @param Set<String> brandingGuideIdSet, List<Id> groupids
    *  @return List<Branding_Guide__Share>
    *
    public static List<Branding_Guide__Share> getBrandingGuideSharing(Set<String> brandingGuideIdSet, List<Id> groupids) {
        return [
                SELECT ParentId,UserOrGroupId 
                FROM Branding_Guide__Share 
                WHERE ParentId IN :brandingGuideIdSet 
                AND UserOrGroupId IN :groupids
        ];
    }
    public static List<Branding_Guide__c> getBrandingGuideFromAccountId(Set<Id> setOfAccountIds){
        return [  SELECT Id, Name, Opportunity_Product__c, Opportunity__c, Status__c, Brand_Name__c,
                  Product_Type__c, Account__c FROM Branding_Guide__c where Account__c IN :setOfAccountIds
        ];
    }
    /**
    *  get Branding Guide records from Id
    *  @name getBGRecordsById
    *  @param String brandingGuideRecordId
    *  @return Map<Id, Branding_Guide__c>
    *
    public static Map<Id, Branding_Guide__c> getBGRecordsById(String brandingGuideRecordId) {
         return new map<Id, Branding_Guide__c>(
             [SELECT Id, Name, Brand_Card_Art_Alt_text__c, Brand_Logo_Alt_text__c, 
                  Benefits_Copy_Headline__c, Benefits_Copy_Supportive_Bullets__c, 
                  Primary_Brand_Colour__c, Secondary_Brand_Colour__c, Benefits_Slideout_Copy_Headline__c, 
                  Benefits_Slideout_Bullet_points_Suppor__c, Rewards_T_C_Slideout_Copy_Headline__c, 
                  Rewards_T_C_Supportive_Copy__c, Application_Form_Headline__c, Application_Form_Benifit_Copy__c,
                  Benefits_Card_1__c, Reward_Programs__c, Benefits_Card_2__c, Benefits_Card_3__c,
                  Program_Details_Table_Disclosure__c, Benefits_Tier_1__c, Benefits_Tier_2__c, Benefits_Tier_3__c, 
                  Benefits_Tier_1_Reward_1__c, Benefits_Tier_1_Reward_2__c, Benefits_Tier_1_Reward_3__c, 
                  Benefits_Tier_1_Reward_4__c, Benefits_Tier_2_Reward_1__c, Benefits_Tier_2_Reward_2__c, 
                  Benefits_Tier_2_Reward_3__c, Benefits_Tier_2_Reward_4__c, Benefits_Tier_3_Reward_1__c,
                  Benefits_Tier_3_Reward_2__c, Benefits_Tier_3_Reward_3__c, Benefits_Tier_3_Reward_4__c, 
                  Opportunity_Product__c, Opportunity__c, Status__c, Brand_Name__c, Completed_Tabs__c,
                  Product_Type__c, Show_On_Portal__c, Benefit_table_Disclosures__c,Value_Proposition_Intro_Statement__c,
                  Rewards_Op__c,Hero_3__c,Hero_2__c,Hero_1__c,Rewards_Disclosures__c,Rewards_Amount__c,Tier_Benefits_Disclosures__c, Account__c 
               FROM 
                   Branding_Guide__c 
               where 
                   id =: brandingGuideRecordId]);
    }
    /**
    *  get Branding Guide Line Item records from Branding Guide Id
    *  @name getBGlineItems
    *  @param String brandingGuideRecordId
    *  @return List<Branding_Guide_Line_Item__c>
    *
    public static List<Branding_Guide_Line_Item__c> getBGlineItems(String brandingGuideRecordId) {
         return [SELECT id, Spend__c, Purchase__c, Earn__c, Tier__c, Name, 
                    RecordType.DeveloperName, Branding_Guide__r.Name , Additional_Offer__c, key__c, Program_Details__c, 
                    Optional_Offer_Card_Tier_1__c, Optional_Offer_Card_Tier_2__c, Optional_Offer_Card_Tier_3__c,
                    PB_Three_Card_Tier_1__c,PB_Three_Card_Tier_2__c,PB_Three_Card_Tier_3__c, card_tier__c
              FROM 
                Branding_Guide_Line_Item__c
              WHERE 
                   Branding_Guide__r.id  =: brandingGuideRecordId order by key__c asc];
    }
    /**
    *  get Branding Guide Question records from Branding Guide Id
    *  @name getBGQuestions
    *  @param String brandingGuideRecordId
    *  @return Map<Id, Branding_Guide_FAQ__c>
    *
    public static List<Branding_Guide_FAQ__c> getBGQuestions(String brandingGuideRecordId) {
         return [SELECT id, Question__c,Answer__c,FAQ_Type__c, Branding_Guide__r.Name, key__c, FAQ_Label__c 
              FROM 
                Branding_Guide_FAQ__c
              WHERE 
                   Branding_Guide__r.id  =: brandingGuideRecordId order by key__c asc];
    }
  /**
    *  get Branding Guide records for opportunities with not completed Status
    *  @name getNotCompletedBrandingGuides
    *  @return List<Branding_Guide__c>
       
    public static List<Branding_Guide__c> getNotCompletedBrandingGuides(Set<Id> SetOfRequiredOppId) {
         return [Select id,Opportunity__c,Status__c 
              from Branding_Guide__c 
              where Opportunity__r.id =: SetofRequiredOppId 
              AND Status__c != 'Completed'];
    }
*/ 
}