/**

@name BrandingGuideController

@Description Is used as controller to BrandingGuideController LWC

**/
public without sharing class BrandingGuideController {
    
    /**
    *  Save Branding Guide details in the corresponding record.
    *  @Name saveBrandingGuideDetails
    *  @Param  brandingGuideWrapper
    *  @Return AuraResponse
    *  @Throws exception
    
    @AuraEnabled
    public static AuraResponse saveBrandingGuideDetails(String brandingGuideWrapper){
        // save branding guide details
        Branding_Guide__c brandingGuideRec = new Branding_Guide__c();
        AuraResponse responseSaveLines;
        AuraResponse responseSaveFAQ;
        try{
            BrandingGuideDetailWrapper detailWrapper = (BrandingGuideDetailWrapper)JSON.deserialize(
                brandingGuideWrapper, BrandingGuideDetailWrapper.class);
            brandingGuideRec.id = detailWrapper.bgRecord.Id;
            brandingGuideRec.Brand_Card_Art_Alt_text__c = detailWrapper.bgAltText;
            brandingGuideRec.Brand_Logo_Alt_text__c = detailWrapper.bgLogoAltText;
            brandingGuideRec.Benefits_Copy_Headline__c = detailWrapper.bgBenefitsCopyHeadline;
            brandingGuideRec.Benefits_Copy_Supportive_Bullets__c = detailWrapper.bgBenefitsCopyBullets;
            brandingGuideRec.Primary_Brand_Colour__c = detailWrapper.bgPrimaryColor;
            brandingGuideRec.Secondary_Brand_Colour__c = detailWrapper.bgSecondaryColor;
            brandingGuideRec.Benefits_Slideout_Copy_Headline__c = detailWrapper.bgSlideOutHeadline;
            brandingGuideRec.Benefits_Slideout_Bullet_points_Suppor__c = detailWrapper.bgSlideOutBullet;
            brandingGuideRec.Rewards_T_C_Slideout_Copy_Headline__c = detailWrapper.bgRewardsHeadline;
            brandingGuideRec.Rewards_T_C_Supportive_Copy__c = detailWrapper.bgRewardsBullet;
            brandingGuideRec.Completed_Tabs__c = detailWrapper.completedTabs;
            brandingGuideRec.Reward_Programs__c = detailWrapper.bgRewardPrograms;
            brandingGuideRec.Benefit_table_Disclosures__c = detailWrapper.bgRecord.Benefit_table_Disclosures__c;
            brandingGuideRec.Benefits_Card_1__c = detailWrapper.bgRecord.Benefits_Card_1__c;
            brandingGuideRec.Benefits_Card_2__c = detailWrapper.bgRecord.Benefits_Card_2__c;
            brandingGuideRec.Benefits_Card_3__c = detailWrapper.bgRecord.Benefits_Card_3__c;
            brandingGuideRec.Benefits_Tier_1__c = detailWrapper.bgRecord.Benefits_Tier_1__c;
            brandingGuideRec.Benefits_Tier_2__c = detailWrapper.bgRecord.Benefits_Tier_2__c;
            brandingGuideRec.Benefits_Tier_3__c = detailWrapper.bgRecord.Benefits_Tier_3__c;
             brandingGuideRec.Benefits_Tier_1_Reward_1__c = detailWrapper.bgRecord.Benefits_Tier_1_Reward_1__c;
            brandingGuideRec.Benefits_Tier_1_Reward_2__c = detailWrapper.bgRecord.Benefits_Tier_1_Reward_2__c;
            brandingGuideRec.Benefits_Tier_1_Reward_3__c = detailWrapper.bgRecord.Benefits_Tier_1_Reward_3__c;
            brandingGuideRec.Benefits_Tier_1_Reward_4__c = detailWrapper.bgRecord.Benefits_Tier_1_Reward_4__c;
            brandingGuideRec.Benefits_Tier_2_Reward_1__c = detailWrapper.bgRecord.Benefits_Tier_2_Reward_1__c;
            brandingGuideRec.Benefits_Tier_2_Reward_2__c = detailWrapper.bgRecord.Benefits_Tier_2_Reward_2__c;
            brandingGuideRec.Benefits_Tier_2_Reward_3__c = detailWrapper.bgRecord.Benefits_Tier_2_Reward_3__c;
            brandingGuideRec.Benefits_Tier_2_Reward_4__c = detailWrapper.bgRecord.Benefits_Tier_2_Reward_4__c;
            brandingGuideRec.Benefits_Tier_3_Reward_1__c = detailWrapper.bgRecord.Benefits_Tier_3_Reward_1__c;
            brandingGuideRec.Benefits_Tier_3_Reward_2__c = detailWrapper.bgRecord.Benefits_Tier_3_Reward_2__c;
            brandingGuideRec.Benefits_Tier_3_Reward_3__c = detailWrapper.bgRecord.Benefits_Tier_3_Reward_3__c;
            brandingGuideRec.Benefits_Tier_3_Reward_4__c = detailWrapper.bgRecord.Benefits_Tier_3_Reward_4__c;
            brandingGuideRec.Program_Details_Table_Disclosure__c = detailWrapper.bgRecord.Program_Details_Table_Disclosure__c;
            brandingGuideRec.Application_Form_Benifit_Copy__c = detailWrapper.bgRecord.Application_Form_Benifit_Copy__c;
            brandingGuideRec.Application_Form_Headline__c = detailWrapper.bgRecord.Application_Form_Headline__c;
            brandingGuideRec.Value_Proposition_Intro_Statement__c = detailWrapper.bgRecord.Value_Proposition_Intro_Statement__c;
            brandingGuideRec.Rewards_Op__c = detailWrapper.bgRecord.Rewards_Op__c;
            brandingGuideRec.Hero_3__c = detailWrapper.bgRecord.Hero_3__c;
            brandingGuideRec.Hero_2__c = detailWrapper.bgRecord.Hero_2__c;
            brandingGuideRec.Hero_1__c = detailWrapper.bgRecord.Hero_1__c;
            brandingGuideRec.Rewards_Disclosures__c = detailWrapper.bgRecord.Rewards_Disclosures__c;
            brandingGuideRec.Rewards_Amount__c = detailWrapper.bgRecord.Rewards_Amount__c;
            brandingGuideRec.Status__c = detailWrapper.bgRecord.Status__c;
            brandingGuideRec.Tier_Benefits_Disclosures__c = detailWrapper.bgRecord.Tier_Benefits_Disclosures__c;
            update brandingGuideRec;
            if(detailWrapper.lstLineItems != null){
                String lineWrapper = JSON.serialize(detailWrapper.lstLineItems);
                responseSaveLines = saveBrandingGuideLineDetails(lineWrapper, brandingGuideRec.id);
            }
            if(detailWrapper.lstQuestions != null){
                String lineQuestion = JSON.serialize(detailWrapper.lstQuestions);
                responseSaveFAQ = saveBrandingGuideQuestions(lineQuestion, brandingGuideRec.id);
            }
            return new AuraResponse(true, Label.SUCCESS, JSON.serialize(detailWrapper));
        }catch(Exception ex){
              return new AuraResponse(false, handleExceptionValidation(ex), handleExceptionValidation(ex));
            }
    }
    
    /**
    *  Save Branding Guide details in the corresponding record.
    *  @Name saveBrandingGuideLineDetails
    *  @Param  brandingGuideWrapper
    *  @Return AuraResponse
    *  @Throws exception
    *
    @AuraEnabled
    public static AuraResponse saveBrandingGuideLineDetails(String brandingGuideLineWrapper, String brandingGuideId){
        // save branding guide details
        List<Branding_Guide_Line_Item__c> brandingGuideLineRecList = new List<Branding_Guide_Line_Item__c>();
        List<Branding_Guide_Line_Item__c> brandingGuideLineUpdateList = new List<Branding_Guide_Line_Item__c>();
        List<Branding_Guide_Line_Item__c> brandingGuideLineDeleteList = new List<Branding_Guide_Line_Item__c>();
        Map<String, BrandingGuideLineItemsWrapper> mapOfDetailWrapper = new Map<String, BrandingGuideLineItemsWrapper>();
        String recordTypeIdVal;
        Map<String, Branding_Guide_Line_Item__c> mapOfLineItemValues = new Map<String, Branding_Guide_Line_Item__c>();
        List<Branding_Guide_Line_Item__c> listOfLineItems = BrandingGuideSelector.getBGlineItems(brandingGuideId);
        if(!listOfLineItems.isEmpty()){
            for(Branding_Guide_Line_Item__c each : listOfLineItems){
                mapOfLineItemValues.put(each.key__c+'-'+each.recordTypeId+'-'+each.Additional_Offer__c+'-'+each.Card_Tier__c, each);
            }      
        }
        try{
            List<BrandingGuideLineItemsWrapper> detailWrapperList = (List<BrandingGuideLineItemsWrapper>)JSON.deserialize(brandingGuideLineWrapper, List<BrandingGuideLineItemsWrapper>.class);
            for(BrandingGuideLineItemsWrapper detailWrapper : detailWrapperList){
                recordTypeIdVal = detailWrapper.recordTypeId;
                mapOfDetailWrapper.put(detailWrapper.key+'-'+detailWrapper.recordTypeId+'-'+detailWrapper.additionalOffer+'-'+detailWrapper.cardTier, detailWrapper);
                if(
                    (!mapOfLineItemValues.isEmpty() && 
                         (
                             !mapOfLineItemValues.containskey(detailWrapper.key+'-'+detailWrapper.recordTypeId+'-'+detailWrapper.additionalOffer+'-'+detailWrapper.cardTier)
                         )
                    )||(mapOfLineItemValues.isEmpty())
                ){
                    Branding_Guide_Line_Item__c brandingGuideLineRec = new Branding_Guide_Line_Item__c();
                    brandingGuideLineRec.tier__c = detailWrapper.tier;
                    brandingGuideLineRec.key__c = detailWrapper.key;
                    brandingGuideLineRec.Card_Tier__c = detailWrapper.cardTier;
                    brandingGuideLineRec.spend__c = detailWrapper.spend;
                    brandingGuideLineRec.earn__c = detailWrapper.earn;
                    brandingGuideLineRec.purchase__c = detailWrapper.purchase;
                    brandingGuideLineRec.Additional_Offer__c = detailWrapper.additionalOffer;
                    brandingGuideLineRec.Branding_Guide__c = brandingGuideId;
                    brandingGuideLineRec.Program_Details__c = detailWrapper.program;
                    brandingGuideLineRec.RecordTypeId = detailWrapper.recordTypeId;
                    brandingGuideLineRec.Optional_Offer_Card_Tier_1__c = detailWrapper.cardTier1Detail;
                    brandingGuideLineRec.Optional_Offer_Card_Tier_2__c = detailWrapper.cardTier2Detail;
                    brandingGuideLineRec.Optional_Offer_Card_Tier_3__c = detailWrapper.cardTier3Detail;
                    if(detailWrapper.cardTier.equals('1')){
                      brandingGuideLineRec.PB_Three_Card_Tier_1__c = detailWrapper.tierBenefit;  
                    } else if(detailWrapper.cardTier.equals('2')){
                      brandingGuideLineRec.PB_Three_Card_Tier_2__c = detailWrapper.tierBenefit;  
                    } else if(detailWrapper.cardTier.equals('3')){
                      brandingGuideLineRec.PB_Three_Card_Tier_3__c = detailWrapper.tierBenefit;   
                    }
                    brandingGuideLineRecList.add(brandingGuideLineRec);
                } else {
                    Branding_Guide_Line_Item__c brandingGuideLineRec = new Branding_Guide_Line_Item__c();
                    brandingGuideLineRec.id = mapOfLineItemValues.get(detailWrapper.key+'-'+detailWrapper.recordTypeId+'-'+detailWrapper.additionalOffer+'-'+detailWrapper.cardTier).id;
                    brandingGuideLineRec.tier__c = detailWrapper.tier;
                    brandingGuideLineRec.key__c = detailWrapper.key;
                    brandingGuideLineRec.Card_Tier__c = detailWrapper.cardTier;
                    brandingGuideLineRec.spend__c = detailWrapper.spend;
                    brandingGuideLineRec.earn__c = detailWrapper.earn;
                    brandingGuideLineRec.purchase__c = detailWrapper.purchase;
                    brandingGuideLineRec.Additional_Offer__c = detailWrapper.additionalOffer;
                    brandingGuideLineRec.Program_Details__c = detailWrapper.program;
                    brandingGuideLineRec.RecordTypeId = detailWrapper.recordTypeId;
                    brandingGuideLineRec.Optional_Offer_Card_Tier_1__c = detailWrapper.cardTier1Detail;
                    brandingGuideLineRec.Optional_Offer_Card_Tier_2__c = detailWrapper.cardTier2Detail;
                    brandingGuideLineRec.Optional_Offer_Card_Tier_3__c = detailWrapper.cardTier3Detail;
                    if(detailWrapper.cardTier.equals('1')){
                      brandingGuideLineRec.PB_Three_Card_Tier_1__c = detailWrapper.tierBenefit;  
                    } else if(detailWrapper.cardTier.equals('2')){
                      brandingGuideLineRec.PB_Three_Card_Tier_2__c = detailWrapper.tierBenefit;  
                    } else if(detailWrapper.cardTier.equals('3')){
                      brandingGuideLineRec.PB_Three_Card_Tier_3__c = detailWrapper.tierBenefit;   
                    }
                    brandingGuideLineUpdateList.add(brandingGuideLineRec);
                }
            }
            
            if(!mapOfLineItemValues.isEmpty()){
                for(Branding_Guide_Line_Item__c each : mapOfLineItemValues.values()){
                    if(!mapOfDetailWrapper.isEmpty() 
                       && !mapOfDetailWrapper.containskey(each.key__c+'-'+each.recordTypeId+'-'+each.Additional_Offer__c+'-'+each.Card_Tier__c) 
                       && each.RecordTypeId.equals(recordTypeIdVal) 
                    ){
                        brandingGuideLineDeleteList.add(each);
                    }
                }
            }
            if(!brandingGuideLineRecList.isEmpty()){
                Insert brandingGuideLineRecList;
            }
            if(!brandingGuideLineUpdateList.isEmpty()){
                Update brandingGuideLineUpdateList;
            }
            if(!brandingGuideLineDeleteList.isEmpty()){
                Delete brandingGuideLineDeleteList;
            }
            return new AuraResponse(true, Label.SUCCESS, JSON.serialize(detailWrapperList));
        } catch(Exception ex){
            return new AuraResponse(false, Label.SOMETHING_WENT_WRONG, ex.getMessage());
        }  
    }
     /**
    *  Save Branding Guide details in the corresponding record.
    *  @Name saveBrandingGuideQuestions
    *  @Param  String brandingGuideQuesWrapper, String brandingGuideId
    *  @Return AuraResponse
    *  @Throws exception
    *
    @AuraEnabled
    public static AuraResponse saveBrandingGuideQuestions(String brandingGuideQuesWrapper, String brandingGuideId){
        // save branding guide details
        List<Branding_Guide_FAQ__c> brandingGuideQuesRecList = new List<Branding_Guide_FAQ__c>();
        Map<String, Branding_Guide_FAQ__c> mapOfQuesValues = new Map<String, Branding_Guide_FAQ__c>();
        List<Branding_Guide_FAQ__c> listOfQuestions = BrandingGuideSelector.getBGQuestions(brandingGuideId);
        if(!listOfQuestions.isEmpty()){
            for(Branding_Guide_FAQ__c each : listOfQuestions){
                mapOfQuesValues.put(each.key__c+'-'+each.FAQ_Type__c, each);
            }      
        }   
        try{
            List<BrandingGuideQuesWrapper> detailWrapperList = (List<BrandingGuideQuesWrapper>)JSON.deserialize(brandingGuideQuesWrapper, List<BrandingGuideQuesWrapper>.class);
            for(BrandingGuideQuesWrapper detailWrapper : detailWrapperList){
                if(String.isNotBlank(detailWrapper.question) && String.isNotBlank(detailWrapper.answer)){
                    Branding_Guide_FAQ__c brandingGuideQuesRec = new Branding_Guide_FAQ__c();
                    brandingGuideQuesRec.key__c =  detailWrapper.key;
                    brandingGuideQuesRec.Question__c = detailWrapper.question;
                    brandingGuideQuesRec.Answer__c = detailWrapper.answer;
                    brandingGuideQuesRec.FAQ_Type__c = detailWrapper.type;
                    brandingGuideQuesRec.FAQ_label__c = detailWrapper.name;
                    brandingGuideQuesRec.Branding_Guide__c = brandingGuideId;
                    brandingGuideQuesRecList.add(brandingGuideQuesRec);
                }}
                        
            if(!listOfQuestions.isEmpty()){
                Delete listOfQuestions;
            }
            if(!brandingGuideQuesRecList.isEmpty()){
                Insert brandingGuideQuesRecList;
            }
            return new AuraResponse(true, Label.SUCCESS, JSON.serialize(detailWrapperList));
        } catch(Exception ex){
            return new AuraResponse(false, Label.SOMETHING_WENT_WRONG, ex.getMessage());
        }  
    }
    
    /**
    *  Fetch all details of Branding Guide corresponding to Branding Guide Record Id in a wrapper
    *  @Name getAllBGDetailsForPortal
    *  @Param  brandingGuideRecordId
    *  @Return AuraResponse
    *  @Throws exception
    *
    @AuraEnabled(cacheable=true)
    public static AuraResponse getAllBGDetailsForPortal(String brandingGuideRecordId){
        BrandingGuideDetailWrapper bgWrapper = new BrandingGuideDetailWrapper();
        Map<Id,Branding_Guide__c> mapOfBGRecord = new Map<Id,Branding_Guide__c>();
        try{
                  // Fetch the Branding Guide Record
                  mapOfBGRecord = BrandingGuideSelector.getBGRecordsById(brandingGuideRecordId);  
                  if(!mapOfBGRecord.isEmpty()){
                      Map<Id,List<BrandingGuideLineItemsWrapper>> mapOfGuideIdWithLineIntems = getLineItemDetails(brandingGuideRecordId);
                      Map<Id,List<BrandingGuideQuesWrapper>> mapOfGuideIdWithQuestions = getQuestionDetails(brandingGuideRecordId);
                      for(Branding_Guide__c eachGuide : mapOfBGRecord.values()){
                          bgWrapper.bgRecord = eachGuide;
                          bgWrapper.bgAltText = eachGuide.Brand_Card_Art_Alt_text__c;
                          bgWrapper.bgLogoAltText = eachGuide.Brand_Logo_Alt_text__c;
                          bgWrapper.bgBenefitsCopyHeadline = eachGuide.Benefits_Copy_Headline__c;
                          bgWrapper.bgBenefitsCopyBullets = eachGuide.Benefits_Copy_Supportive_Bullets__c;
                          bgWrapper.bgPrimaryColor = eachGuide.Primary_Brand_Colour__c;
                          bgWrapper.bgSecondaryColor = eachGuide.Secondary_Brand_Colour__c;
                          bgWrapper.bgSlideOutHeadline = eachGuide.Benefits_Slideout_Copy_Headline__c;
                          bgWrapper.bgSlideOutBullet = eachGuide.Benefits_Slideout_Bullet_points_Suppor__c;
                          bgWrapper.bgRewardsHeadline = eachGuide.Rewards_T_C_Slideout_Copy_Headline__c;
                          bgWrapper.bgRewardsBullet = eachGuide.Rewards_T_C_Supportive_Copy__c;
                          bgWrapper.completedTabs = eachGuide.Completed_Tabs__c;
                          bgWrapper.productType = eachGuide.Product_Type__c;
                          bgWrapper.bgRewardPrograms = eachGuide.Reward_Programs__c;
                          bgWrapper.bgRecord.Benefits_Card_1__c = eachGuide.Benefits_Card_1__c;
                          bgWrapper.bgRecord.Benefits_Card_2__c = eachGuide.Benefits_Card_2__c;                          
                          bgWrapper.bgRecord.Benefits_Card_3__c = eachGuide.Benefits_Card_3__c;
                          bgWrapper.bgRecord.Benefit_table_Disclosures__c = eachGuide.Benefit_table_Disclosures__c;
              bgWrapper.bgRecord.Benefits_Tier_1__c = eachGuide.Benefits_Tier_1__c;
              bgWrapper.bgRecord.Benefits_Tier_2__c = eachGuide.Benefits_Tier_2__c;
              bgWrapper.bgRecord.Benefits_Tier_3__c = eachGuide.Benefits_Tier_3__c;
                          bgWrapper.bgRecord.Benefits_Tier_1_Reward_1__c = eachGuide.Benefits_Tier_1_Reward_1__c;
                          bgWrapper.bgRecord.Benefits_Tier_1_Reward_2__c = eachGuide.Benefits_Tier_1_Reward_2__c;
                          bgWrapper.bgRecord.Benefits_Tier_1_Reward_3__c = eachGuide.Benefits_Tier_1_Reward_3__c;
                          bgWrapper.bgRecord.Benefits_Tier_1_Reward_4__c = eachGuide.Benefits_Tier_1_Reward_4__c;
                          bgWrapper.bgRecord.Benefits_Tier_2_Reward_1__c = eachGuide.Benefits_Tier_2_Reward_1__c;
                          bgWrapper.bgRecord.Benefits_Tier_2_Reward_2__c = eachGuide.Benefits_Tier_2_Reward_2__c;
                          bgWrapper.bgRecord.Benefits_Tier_2_Reward_3__c = eachGuide.Benefits_Tier_2_Reward_3__c;
                          bgWrapper.bgRecord.Benefits_Tier_2_Reward_4__c = eachGuide.Benefits_Tier_2_Reward_4__c;
                          bgWrapper.bgRecord.Benefits_Tier_3_Reward_1__c = eachGuide.Benefits_Tier_3_Reward_1__c;
                          bgWrapper.bgRecord.Benefits_Tier_3_Reward_2__c = eachGuide.Benefits_Tier_3_Reward_2__c;
                          bgWrapper.bgRecord.Benefits_Tier_3_Reward_3__c = eachGuide.Benefits_Tier_3_Reward_3__c;
                          bgWrapper.bgRecord.Benefits_Tier_3_Reward_4__c = eachGuide.Benefits_Tier_3_Reward_4__c;
                          bgWrapper.bgRecord.Program_Details_Table_Disclosure__c = eachGuide.Program_Details_Table_Disclosure__c;
                          bgWrapper.bgRecord.Application_Form_Benifit_Copy__c = eachGuide.Application_Form_Benifit_Copy__c;
              bgWrapper.bgRecord.Application_Form_Headline__c = eachGuide.Application_Form_Headline__c;
              bgWrapper.bgRecord.Value_Proposition_Intro_Statement__c = eachGuide.Value_Proposition_Intro_Statement__c;
              bgWrapper.bgRecord.Rewards_Op__c = eachGuide.Rewards_Op__c;
              bgWrapper.bgRecord.Hero_3__c = eachGuide.Hero_3__c;
              bgWrapper.bgRecord.Hero_2__c = eachGuide.Hero_2__c;
              bgWrapper.bgRecord.Hero_1__c = eachGuide.Hero_1__c;
              bgWrapper.bgRecord.Rewards_Disclosures__c = eachGuide.Rewards_Disclosures__c;
              bgWrapper.bgRecord.Rewards_Amount__c = eachGuide.Rewards_Amount__c;
                          bgWrapper.bgRecord.Status__c = eachGuide.Status__c;
                          bgWrapper.bgRecord.Tier_Benefits_Disclosures__c = eachGuide.Tier_Benefits_Disclosures__c;
                          if(!mapOfGuideIdWithLineIntems.isEmpty()){
                              //getting line items related to a Branding Guide
                              List<BrandingGuideLineItemsWrapper> lstLineItems = mapOfGuideIdWithLineIntems.get(brandingGuideRecordId);
                              if(!lstLineItems.isEmpty()){
                                  //assigning lstLineItems 
                                  bgWrapper.lstLineItems = lstLineItems;
                              }
                          }
                          if(!mapOfGuideIdWithQuestions.isEmpty()){
                              //getting frequently asked questions related to a Branding Guide
                              List<BrandingGuideQuesWrapper> lstQuestions = mapOfGuideIdWithQuestions.get(brandingGuideRecordId);
                              if(!lstQuestions.isEmpty()){
                                  //assigning lstquestions
                                  bgWrapper.lstQuestions = lstQuestions;
                              }
                          }
                      }
                  }
                  return new AuraResponse(true, Label.SUCCESS, JSON.serialize(bgWrapper));
        } catch(Exception ex){
            return new AuraResponse(false, Label.SOMETHING_WENT_WRONG, null);
        }
        
    }
    /**
    *  Fetch all details of training for a particular account in a wrapper
    *  @Name deleteFile
    *  @Param  contentDocumentId
    *  @Return void
    *  @Throws exception
    *
    @AuraEnabled  
    public static AuraResponse deleteFile(string contentDocumentId){ 
        try{
            delete [SELECT Id from ContentDocument WHERE Id = :contentDocumentId];  
            return new AuraResponse(true, 'Success', 'Success');
        } catch(Exception ex){
            return new AuraResponse(false, handleExceptionValidation(ex), null); 
        }
    }
    /**
    *  Fetch all the details of Line Items to display on portal
    *  @Name getLineItems
    *  @Param  String brandingGuideRecordId
    *  @Return List<BrandingGuideLineItemsWrapper>
    *
    @AuraEnabled(cacheable=true)
    public static List<BrandingGuideLineItemsWrapper> getLineItems(String brandingGuideRecordId, String recordTypeId){
        Map<Id,List<BrandingGuideLineItemsWrapper>> mapOfBGLines = getLineItemDetails(brandingGuideRecordId);
        return mapOfBGLines.get(brandingGuideRecordId);
    }
    /**
    *  Fetch all the details of FAQ's to display on portal
    *  @Name getQuestions
    *  @Param  String brandingGuideRecordId
    *  @Return List<BrandingGuideQuesWrapper>
    *
    @AuraEnabled(cacheable=true)
    public static List<BrandingGuideQuesWrapper> getQuestions(String brandingGuideRecordId){
        Map<Id,List<BrandingGuideQuesWrapper>> mapOfBGQues = getQuestionDetails(brandingGuideRecordId);
        return mapOfBGQues.get(brandingGuideRecordId);
    }
    /** 
    *  Fetch all the line items corresponding to input branding guide record
    *  @Name getLineItemDetails
    *  @Param  String bgRecordId
    *  @Return Map<Id,List<BrandingGuideLineItems>>
    *
    @AuraEnabled(cacheable=true)
    public static Map<Id,List<BrandingGuideLineItemsWrapper>> getLineItemDetails(String brandingGuideRecordId){
        Map<Id,List<BrandingGuideLineItemsWrapper>> mapOfBGIdWithLineItems = new Map<Id,List<BrandingGuideLineItemsWrapper>>();
        List<Branding_Guide_Line_Item__c> listOfLineItems = BrandingGuideSelector.getBGlineItems(brandingGuideRecordId);
        if(!listOfLineItems.isEmpty()){
            //creating a map of branding guide id with line items
            for(Branding_Guide_Line_Item__c eachItem : listOfLineItems){
                if(!mapOfBGIdWithLineItems.containsKey(brandingGuideRecordId)){
                    mapOfBGIdWithLineItems.put(brandingGuideRecordId, new List<BrandingGuideLineItemsWrapper>());
                }
                List<BrandingGuideLineItemsWrapper> lstLineItems = mapOfBGIdWithLineItems.get(brandingGuideRecordId);
                BrandingGuideLineItemsWrapper eachWrapper = new BrandingGuideLineItemsWrapper();
                eachWrapper.recordTypeId = eachItem.RecordTypeId;
                eachWrapper.tier = eachItem.Tier__c;
                eachWrapper.spend = eachItem.Spend__c;
                eachWrapper.earn = eachItem.Earn__c;
                eachWrapper.purchase = eachItem.Purchase__c;
                eachWrapper.additionalOffer = eachItem.Additional_Offer__c;
                eachWrapper.key = eachItem.key__c;
                eachWrapper.cardTier1Detail = eachItem.Optional_Offer_Card_Tier_1__c;
                eachWrapper.cardTier2Detail = eachItem.Optional_Offer_Card_Tier_2__c;
                eachWrapper.cardTier3Detail = eachItem.Optional_Offer_Card_Tier_3__c;
                eachWrapper.cardTier1 = eachItem.PB_Three_Card_Tier_1__c;
                eachWrapper.cardTier2 = eachItem.PB_Three_Card_Tier_2__c;
                eachWrapper.cardTier3 = eachItem.PB_Three_Card_Tier_3__c;
                eachWrapper.cardTier = eachItem.Card_Tier__c;
                eachWrapper.program = eachItem.Program_Details__c;
                if(eachItem.Card_Tier__c.equals('1')){
                  eachWrapper.tierBenefit = eachItem.PB_Three_Card_Tier_1__c;
                } else if(eachItem.Card_Tier__c.equals('2')){
                  eachWrapper.tierBenefit = eachItem.PB_Three_Card_Tier_2__c;  
                } else if(eachItem.Card_Tier__c.equals('3')){
                  eachWrapper.tierBenefit = eachItem.PB_Three_Card_Tier_3__c;   
                }
                lstLineItems.add(eachWrapper);
                mapOfBGIdWithLineItems.put(brandingGuideRecordId,lstLineItems);
            }
        }
        return mapOfBGIdWithLineItems;
    }
    /** 
    *  Fetch all the questions corresponding to input branding guide record
    *  @Name getQuestionDetails
    *  @Param  String brandingGuideRecordId
    *  @Return Map<Id,List<BrandingGuideQuesWrapper>>
    *
    @AuraEnabled(cacheable=true)
    public static Map<Id,List<BrandingGuideQuesWrapper>> getQuestionDetails(String brandingGuideRecordId){
        Map<Id,List<BrandingGuideQuesWrapper>> mapOfBGIdWithQuestions = new Map<Id,List<BrandingGuideQuesWrapper>>();
        List<Branding_Guide_FAQ__c> listOfQuestions = BrandingGuideSelector.getBGQuestions(brandingGuideRecordId);
        if(!listOfQuestions.isEmpty()){
            //creating a map of Branding Guide id with questions wrapper 
            for(Branding_Guide_FAQ__c eachItem : listOfQuestions){
                if(!mapOfBGIdWithQuestions.containsKey(brandingGuideRecordId)){
                    mapOfBGIdWithQuestions.put(brandingGuideRecordId, new List<BrandingGuideQuesWrapper>());
                }
                List<BrandingGuideQuesWrapper> lstQuestions = mapOfBGIdWithQuestions.get(brandingGuideRecordId);
                BrandingGuideQuesWrapper eachWrapper = new BrandingGuideQuesWrapper();
                eachWrapper.question = eachItem.Question__c;
                eachWrapper.key = eachItem.key__c;
                eachWrapper.answer = eachItem.Answer__c;
                eachWrapper.type = eachItem.FAQ_Type__c;
                eachWrapper.name = eachItem.FAQ_label__c;
                lstQuestions.add(eachWrapper);
                mapOfBGIdWithQuestions.put(brandingGuideRecordId,lstQuestions);
            }
        }
        return mapOfBGIdWithQuestions;
    }
    /** 
    *  Method to fetch all the community profiles
    *  @Name getAllCommunityProfile
    *  @Param  none
    *  @Return Set<Id>
    *
    private static set<Id> getAllCommunityProfile() {
        list<Profile> listAllCommunityProfile = ProfileSelctor.getAllCommunityProfile();
        set<Id> setOfProfileId = new set<Id>();
        if(!listAllCommunityProfile.isEmpty()) {
            for(Profile eachProfile : listAllCommunityProfile) {
                setOfProfileId.add(eachProfile.Id);
            }
        }
        return setOfProfileId;
    }
    /**
    *  Fetch all the files corresponding to input branding guide record and its file type
    *  @Name retrieveFiles
    *  @Param  String bgRecordId, String fileType
    *  @Return Map<Id,List<BrandingGuideImage>>
    *
    @AuraEnabled(cacheable=true)
    public static Map<Id,List<BrandingGuideImage>> retriveFiles(String bgRecordId, String fileType){
        try{
            String communityURL = '';
            set<Id> setOfProfileId = getAllCommunityProfile();
            Map<Id,List<BrandingGuideImage>> mapOfBGIdWithMaterials = new Map<Id,List<BrandingGuideImage>>();
            if(String.isNotBlank(bgRecordId)){
                //querying contentdoclink to get all training materials
                List<ContentDocumentLink> lstContentDocumentLink = ContentVersionSelector.getDocument(new Set<Id>{bgRecordId});
                Map<Id, Id> mapOfDocAndVersionId = new Map<Id, Id>();
                Set<Id> setOfContentDocId = new  Set<Id>();
                for(ContentDocumentLink eachLink : lstContentDocumentLink){
                    setOfContentDocId.add(eachLink.ContentDocumentId);
                }
                map<Id,ContentVersion> mapOfversion = ContentVersionSelector.fetchVersionFromDocId(setOfContentDocId);
                if(!mapOfversion.isEmpty()){
                    for(ContentVersion each : mapOfversion.values()){
                        if(mapOfversion.get(each.Id).File_Type_fileupload__c!=null && mapOfversion.get(each.Id).File_Type_fileupload__c.equals(fileType)){
                            mapOfDocAndVersionId.put(each.ContentDocumentId,each.Id);
                        }
                    }
                }
                if(!lstContentDocumentLink.isEmpty()){
                    //fetching current community url
                    List<Network> lstNetowrk = NetworkSelector.getPartnerCommunity();
                    if(!lstNetowrk.isEmpty() && !Test.isRunningTest() && setOfProfileId.contains(UserInfo.getProfileId())){
                        ConnectApi.Community myCommunity = ConnectApi.Communities.getCommunity(lstNetowrk[0].id);
                        if(myCommunity!= null){
                            communityURL = myCommunity.siteUrl;
                        } 
                    }
                    //creating a map of branding guide Id with all content docs ids 
                    if(!mapOfDocAndVersionId.isEmpty()){
                        for(ContentDocumentLink eachLink : lstContentDocumentLink){
                            if(mapOfDocAndVersionId.containsKey(eachLink.ContentDocumentId)){
                                if(!mapOfBGIdWithMaterials.containsKey(eachLink.LinkedEntityId)){
                                    mapOfBGIdWithMaterials.put(eachLink.LinkedEntityId, new List<BrandingGuideImage>());
                                }
                                List<BrandingGuideImage> lstImages = mapOfBGIdWithMaterials.get(eachLink.LinkedEntityId);
                                BrandingGuideImage doc = new BrandingGuideImage();
                                doc.imageId = eachLink.ContentDocumentId;
                                doc.versionId = mapOfDocAndVersionId.get(eachLink.ContentDocumentId);
                                doc.imageName = eachLink.ContentDocument.Title;
                                doc.imageExtension = eachLink.ContentDocument.FileExtension;
                                if(('svg').equalsignorecase(eachLink.ContentDocument.FileExtension)){
                                    doc.isSVGImage = true;
                                } else{
                                    doc.isSVGImage = false;
                                }
                                doc.imageLink = communityURL+Label.TRAINING_DOWNLOAD_URL+eachLink.ContentDocumentId;
                                doc.imageType = mapOfversion.get(mapOfDocAndVersionId.get(eachLink.ContentDocumentId)).File_Type_fileupload__c;
                                if(setOfProfileId.contains(UserInfo.getProfileId())) {
                                    doc.previewLink = communityURL+Label.COMMUNITY_FILE_PREVIEW_LINK+mapOfDocAndVersionId.get(eachLink.ContentDocumentId);       
                                } else{
                                    doc.previewLink = eachLink.ContentDocumentId;
                                }
                                lstImages.add(doc);
                                
                                mapOfBGIdWithMaterials.put(eachLink.LinkedEntityId, lstImages);
                            }
                        }
                    } 
                }
            }
            return mapOfBGIdWithMaterials;
        }catch(Exception e){
                System.debug(e.getMessage());
              return  new Map<Id,List<BrandingGuideImage>>();
        }
    }
    /*
    @name : handleExceptionValidation
    @CreateDate : 16-06-2021
    @Description This method handles the exception messages.
    @Version 1.0
    *
    public static string handleExceptionValidation(exception ex) {
        if ( String.isNotBlank( ex.getMessage() ) && ex.getMessage().contains( 'error:' ) ) {
            string errorMsg = ex.getMessage();
            
            List<String> tempErr;
            if (errorMsg.contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')) {
                tempErr = errorMsg.split('FIELD_CUSTOM_VALIDATION_EXCEPTION');
                
            }
            
            if (tempErr != null && !tempErr.isEmpty()) {
                string errMsg1 = tempErr[1];
                string errMsg = errMsg1.split(':')[0];
                errMsg = errMsg.removeStart(',');
                return errMsg;
            }           
        }        
        return Label.SOMETHING_WENT_WRONG;       
    } 
    
    // Wrapper class for Branding Guide properties
    public class BrandingGuideDetailWrapper{
        @AuraEnabled
        public Branding_Guide__c bgRecord{get;set;}
        @AuraEnabled
        public String bgAltText {get;set;}
        @AuraEnabled
        public String bgLogoAltText {get;set;}
        @AuraEnabled
        public String bgBenefitsCopyHeadline {get;set;}
        @AuraEnabled
        public String bgBenefitsCopyBullets {get;set;}
        @AuraEnabled
        public String bgPrimaryColor {get;set;}
        @AuraEnabled
        public String completedTabs {get;set;}
        @AuraEnabled
        public String bgSecondaryColor {get;set;}
        @AuraEnabled
        public String bgSlideOutHeadline {get;set;}
        @AuraEnabled
        public String bgSlideOutBullet {get;set;}
        @AuraEnabled
        public String bgRewardsHeadline {get;set;}
        @AuraEnabled
        public String bgRewardsBullet {get;set;}
        @AuraEnabled
        public string productType {get;set;}
        @AuraEnabled
        public string bgRewardPrograms {get;set;}
        @AuraEnabled
        public List<BrandingGuideImage> lstImages{get;set;}
        @AuraEnabled
        public List<BrandingGuideLineItemsWrapper> lstLineItems{get;set;}
        @AuraEnabled
        public List<BrandingGuideQuesWrapper> lstQuestions{get;set;}
    }
    
    //Wrapper class for Branding Guide Material 
    public class BrandingGuideImage{
        @AuraEnabled
        public String imageId {get;set;}
        @AuraEnabled
        public String versionId {get;set;}
        @AuraEnabled
        public String previewLink {get;set;}
        @AuraEnabled
        public String imageName {get;set;}
        @AuraEnabled
        public String imageLink {get;set;}
        @AuraEnabled
        public Boolean isSVGImage {get;set;}
        @AuraEnabled
        public String imageExtension {get;set;}
        @AuraEnabled
        public String imageType {get;set;}
    }
    
    //Wrapper class for Branding Guide Line Items 
    public class BrandingGuideLineItemsWrapper{
        @AuraEnabled
        public String tier {get;set;}
        @AuraEnabled
        public String key {get;set;}
        @AuraEnabled
        public String recordTypeId {get;set;}
        @AuraEnabled
        public String spend {get;set;}
        @AuraEnabled
        public String earn {get;set;}
        @AuraEnabled
        public String purchase {get;set;}
        @AuraEnabled
        public String program {get;set;}
        @AuraEnabled
        public String cardTier1Detail {get;set;}
        @AuraEnabled
        public String cardTier2Detail {get;set;}
        @AuraEnabled
        public String cardTier3Detail {get;set;}
        @AuraEnabled
        public String cardTier1 {get;set;}
        @AuraEnabled
        public String cardTier2 {get;set;}
        @AuraEnabled
        public String cardTier3 {get;set;}
        @AuraEnabled
        public String cardTier {get;set;}
        @AuraEnabled
        public String tierBenefit {get;set;}
        @AuraEnabled
        public Boolean additionalOffer {get;set;}
    }
    
    //Wrapper class for Branding Guide FAQ's 
    public class BrandingGuideQuesWrapper{
        @AuraEnabled
        public String question {get;set;}
        @AuraEnabled
        public String key {get;set;}
        @AuraEnabled
        public String answer {get;set;}
        @AuraEnabled
        public String name {get;set;}
        @AuraEnabled
        public String type {get;set;}
 

}
*/
}