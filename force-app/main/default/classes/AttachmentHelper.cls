/*
 * Purpose: Helper class to handle Attachments comong from EmailtoCase.
 *            1) Creates ADS_Document__C record in before insert
 *            2) Assigns inserted Attachment with ADS_Document__c recond

    */    

public class AttachmentHelper{
    /*
    
    public static void AfterInsert(list<Attachment> lstAtt){
    List<attachment> lstatts = new List<attachment>();
    List<ContentVersion> lstContents = new List<ContentVersion>();
    set<Id> EMIds = new set<Id>();
    set<Id> setIds = new set<Id>();
       // Stores a list of EmailMessage Ids
        for( Attachment a : lstAtt ) {  
          if( a.parentid == null )     
                continue;
            if(a.ParentId.getSObjectType() == EmailMessage.sObjectType){ 
                EMIds.add(a.ParentId); 
                lstatts.add(a);
                setIds.add(a.id);
            }
        }
        //Map of EmailMessage records
        map<Id,EmailMessage> mapEmailMessage = new map<Id,EmailMessage>([select Id, ParentId, Parent.CaseNumber from EmailMessage where Id IN: EMIds]);
        list<Documentation__c> lstADSDocuments = new list<Documentation__c>();
        // Creae a list of ADS Documents - Parent id is set to Case id with category having a default value of 'Email Attachment'
 
        String strDefLibName = Label.CMS_Case_Lib_Name;      

        //List<ContentWorkspace> lstLibrary = [SELECT Id,Name FROM ContentWorkspace where Name = 'CMS Case Content' limit 1];        
        List<ContentWorkspace> lstLibrary = [SELECT Id,Name FROM ContentWorkspace where Name = :strDefLibName limit 1];
        for (EmailMessage EM : mapEmailMessage.values()) {
        for(attachment objAttach: lstatts){
            
            String AttachmentName = Null;
            IF(objAttach.Name.Length() >67)
            {
                AttachmentName = objAttach.Name.Substring(0,65);
            } 
            else 
            { 
                AttachmentName=objAttach.Name;
            }
            
            
            Documentation__c ADSDocument = new Documentation__c(
                        Name = EM.Parent.CaseNumber + '-' + AttachmentName, 
                                Case__c = EM.ParentId,    
                                Category_Type__c = 'Email Attachment' , AttachmentId__c = objAttach.id );
                                
            ContentVersion file = new ContentVersion();
            file.versionData = objAttach.Body;
            file.title = objAttach.Name;
            file.Description = objAttach.description;
            file.FirstPublishLocationId = lstLibrary[0].id;
            file.pathOnClient = objAttach.Name;
            file.AttachmentId__c = objAttach.Id;        
           lstADSDocuments.add(ADSDocument);
            lstContents.add(file);
        }
        }
        // Insert the list of CMS attachments records.    
        if (!lstADSDocuments.isEmpty()){
            try{
                insert lstADSDocuments;
            }catch(Exception ex){
                // Set debug to Investigate Error
                system.debug(' Error in ADS Document Insertion attachment trigger before insert '+ex.getMessage());
            }
        }

    if (!lstContents.isEmpty()){
            try{
                insert lstContents;
            }catch(Exception ex){
                // Set debug to Investigate Error
                system.debug(' Error in ADS Document Insertion attachment trigger before insert '+ex.getMessage());
            }
        }
    list<Documentation__c> updateADSDocuments = new list<Documentation__c>();
    String baseURL = URL.getSalesforceBaseUrl().toExternalForm();       
        if (baseURL.startsWith('http:')){
            baseURL = baseURL.replaceFirst('http:', 'https:');
        }
    for(ContentVersion cont : lstContents){ 
        for(Documentation__c docs : lstADSDocuments){
                
            //Fetch CMS Attachment from map using Attachment parent Id 
            if(docs.AttachmentId__c == cont.AttachmentId__c){
                if(docs.Link_to_document__c == null){
                    docs.Link_to_document__c = '';
                }
                if( ! ( docs.Link_to_document__c.contains('069') || docs.Link_to_document__c.contains('068') ) ){
                    docs.Link_to_document__c = cont.Id;

                }
                updateADSDocuments.add(docs);
            }
        }
    }
    if (!updateADSDocuments.isEmpty()){
            try{
                update updateADSDocuments;
            }catch(Exception ex){
                // Set debug to Investigate Error
                system.debug(' Error in ADS Document Insertion attachment trigger before insert '+ex.getMessage());
            }
        }
        createContentDocLink(updateADSDocuments);//Added by Aman

    List<Attachment> attsTobeDeleted = [Select id from Attachment where id IN:setIds ];
    if (!attsTobeDeleted.isEmpty()){
        try{
            delete attsTobeDeleted ;
        }catch(Exception ex){
            // Set debug to Investigate Error
            system.debug(' Error in Attachment deletion '+ex.getMessage());
        }
    }
    
}
public static Void createContentDocLink(list<Documentation__c> listDocIds) { 
    Set<Id> setOfVersionIds = new Set<Id>();
    Map<Id,ContentVersion> mapOfContentVersion;
    list<ContentDocumentLink> listOfContentLink = new list<ContentDocumentLink>();
    list<Documentation__c> listDocuments = new list<Documentation__c>();
    if(!listDocIds.isEmpty()) {
        for(Documentation__c eachDocument : listDocIds) { 
            setOfVersionIds.add(eachDocument.Link_to_document__c); 
        } 
        if(!setOfVersionIds.isEmpty()){
            mapOfContentVersion = new Map<Id, ContentVersion>([SELECT Id, ContentDocumentId, ContentDocument.ParentId 
                                                               FROM ContentVersion 
                                                               where Id IN : setOfVersionIds]); 
        }
        for(Documentation__c eachDocument : listDocIds) { 
            if(mapOfContentVersion!= null && 
               mapOfContentVersion.keySet()!=null && 
               mapOfContentVersion.containsKey(eachDocument.Link_to_document__c)){
                   ContentDocumentLink contentlink=new ContentDocumentLink();
                   contentlink.ShareType= 'V';
                   contentlink.ContentDocumentId = mapOfContentVersion.get(eachDocument.Link_to_document__c).ContentDocumentId;
                   contentlink.Visibility = 'AllUsers'; 
                   contentlink.LinkedEntityId = eachDocument.Id;
                   listOfContentLink.add(contentlink);   

                   //Added to update the Content Document Id on  Documentation object
                   Documentation__c newDocumnt = new Documentation__c();
                    newDocumnt.Id = eachDocument.Id;
                    newDocumnt.Content_Document_ID__c = mapOfContentVersion.get(eachDocument.Link_to_document__c).ContentDocumentId;
                    newDocumnt.AttachmentId__c = mapOfContentVersion.get(eachDocument.Link_to_document__c).ContentDocumentId;
                    listDocuments.add(newDocumnt);
                    
            }   
        }
        //upsert Documentation
        if(!listDocuments.isEmpty()){
            try {
                upsert listDocuments; 
            }
            catch(Exception e){
                system.debug(' Error in updation of Content Id Field on Documentation  '+e.getMessage());
            }         
        }
        //Insertion of File
        if(!listOfContentLink.isEmpty()){
            try {
                insert listOfContentLink; 
            }
            catch(Exception e){
                system.debug(' Error in File Insertion  '+e.getMessage());
            }         
        }
        
    } else {
        system.debug('Content Document List is Empty');
    }
 }
*/
}