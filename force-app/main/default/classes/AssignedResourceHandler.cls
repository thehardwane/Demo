public class AssignedResourceHandler {
    /**
    public void runTrigger(){    
        
        if(Trigger.isAfter && Trigger.isInsert) {
            calculatedDistanceOnAppointment2((list<AssignedResource>)trigger.new);
            populateAssignedResource((list<AssignedResource>)trigger.new);
            populateLocalScheduledTime((list<AssignedResource>)trigger.new, null);
        }
        if(trigger.isAfter && trigger.isUpdate) {
            populateLocalScheduledTime((list<AssignedResource>)trigger.new,(map<id,AssignedResource>)trigger.OldMap);
        }
    }

    public static void calculatedDistanceOnAppointment2(List<AssignedResource>AsResNewRecord){
        Set<AssignedResource>relatedIDs = new Set<AssignedResource>([Select ServiceAppointmentId,ServiceResourceId from AssignedResource where Id IN : AsResNewRecord]);
        List<ServiceAppointment> serviceAppointmentToUpdate = new List<ServiceAppointment>();
        
        
        Set<Id>serviceAppointmentIDs = new Set<Id>();
        Set<Id>serviceResourceIDs = new Set<Id>();
        
        for(AssignedResource ar : RelatedIDs){
            ServiceAppointmentIDs.add(ar.ServiceAppointmentId);
            ServiceResourceIDs.add(ar.ServiceResourceId);
        }
        
        Map<id,ServiceAppointment> artosa = new Map<id,ServiceAppointment>([Select id,Distance__c,FSL__InternalSLRGeolocation__Latitude__s,FSL__InternalSLRGeolocation__Longitude__s from ServiceAppointment where id IN : ServiceAppointmentIDs]);
        Map<id,List<ServiceTerritoryMember> > srtostm = new Map<id,List<ServiceTerritoryMember> >();
        List<ServiceTerritoryMember> stms = new List<ServiceTerritoryMember>([Select ServiceResourceId,Latitude, Longitude from ServiceTerritoryMember where ServiceResourceId IN : ServiceResourceIDs]);
        
        
        
        for(ServiceTerritoryMember stm : stms){
            if (!srtostm .containsKey(STM.ServiceResourceId))
                srtostm .put(STM.ServiceResourceId, new List<ServiceTerritoryMember>());
            srtostm.get(STM.ServiceResourceId).add(STM);
        }
        
        for(AssignedResource ar : AsResNewRecord){
            
            if(artosa.containsKey(ar.ServiceAppointmentId)){
                ServiceAppointment sa = artosa.get(ar.ServiceAppointmentId);
                if(srtostm.containsKey(ar.ServiceResourceId)){
                    List<ServiceTerritoryMember> relatedSTMS = SRTOSTM.get(ar.ServiceResourceId);
                    for(ServiceTerritoryMember stm : relatedSTMS){
                        if(stm.Latitude!=NULL && stm.Longitude!=NULL && sa.FSL__InternalSLRGeolocation__Latitude__s!=NULL && sa.FSL__InternalSLRGeolocation__Longitude__s!=NULL){
                            Location loc1 = Location.newInstance(sa.FSL__InternalSLRGeolocation__Latitude__s ,sa.FSL__InternalSLRGeolocation__Longitude__s);
                            Location loc2 = Location.newInstance(stm.Latitude,stm.Longitude);
                            if(loc1!=NULL && loc2!=NULL){
                                sa.Distance__c = Location.getDistance(loc1, loc2, 'mi');
                                serviceAppointmentToUpdate.add(SA);
                                break;
                            }
                        }
                    }
                } 
            }
        }
        
        if(serviceAppointmentToUpdate.size()>0){
            update serviceAppointmentToUpdate;
        }
    }
    
    
    
    
    
    public static void populateAssignedResource(List<AssignedResource> AsResNewRecord){
        
        Set<AssignedResource>relatedIDs = new Set<AssignedResource>([Select ServiceAppointmentId,ServiceResourceId from AssignedResource where Id IN : AsResNewRecord]);
        List<ServiceAppointment> serviceAppointmentToUpdate = new List<ServiceAppointment>();
        Set<Id>serviceAppointmentIDs = new Set<Id>();
        Set<Id>serviceResourceIDs = new Set<Id>();
        for(AssignedResource ar : RelatedIDs){
            ServiceAppointmentIDs.add(ar.ServiceAppointmentId);
            ServiceResourceIDs.add(ar.ServiceResourceId);
        }
        Map<id,ServiceAppointment>idtosa = new Map<id,ServiceAppointment>([Select id,Assigned_Resource__c from ServiceAppointment where id IN : ServiceAppointmentIDs]);
        Map<id,ServiceResource>idtosr = new Map<id,ServiceResource>([Select id,  Name from ServiceResource where id IN : ServiceResourceIDs]);
        for(AssignedResource ar : AsResNewRecord){
            if(idtosa.containsKey(ar.ServiceAppointmentId)){
                ServiceAppointment sa = idtosa.get(ar.ServiceAppointmentId);
                if(idtosr.containsKey(AR.ServiceResourceId)){
                    ServiceResource sr= IDTOSR.get(AR.ServiceResourceId);
                    sa.Assigned_Resource__c = SR.Name;
                    serviceAppointmentToUpdate.add(sa);
                }
            }
        }
        if(serviceAppointmentToUpdate.size()>0){
            update serviceAppointmentToUpdate;
        }
    }
    /**
*  Populates the Local Scheduled Start and End Time on Service Appointment
*  @name populateLocalScheduledTime
*  @param List<AssignedResource> newAssignedResourceList, map<id,AssignedResource> oldAssignedResMap
*  @return void

    public static void populateLocalScheduledTime(List<AssignedResource> newAssignedResourceList, map<id,AssignedResource> oldAssignedResMap){
        try{
            List<ServiceAppointment> ServiceAppListToUpdate = new List<ServiceAppointment>();
            List<ServiceAppointment> serviceAppointList = new List<ServiceAppointment>();
            Set<Id> serviceResourceIDs = new Set<Id>();
            Map<id, List<AssignedResource>> assignedResourceMap = new Map<id, List<AssignedResource>>();
            Map<id, List<AssignedResource>> assignedResourceMapAll =  new Map<id, List<AssignedResource>>();
            Map<id, AssignedResource> finalAssgnResourceMap = new Map<id, AssignedResource>();
            //fetch assigned resources corresponding to the new list
            Set<AssignedResource> assigedResourceSet = ServiceAppointmentSelector.getAssignedResourcesbyId(newAssignedResourceList);
            //prepare map of service appointment with it's list of assigned resources
            for(AssignedResource assignedResRec : assigedResourceSet){
                if(!assignedResourceMap.containsKey(assignedResRec.ServiceAppointmentId)){
                    assignedResourceMap.put(assignedResRec.ServiceAppointmentId, new list<AssignedResource>());
                }
                assignedResourceMap.get(assignedResRec.ServiceAppointmentId).add(assignedResRec);
            }
            if(!assignedResourceMap.isEmpty()){
                serviceAppointList = ServiceAppointmentSelector.getServiceAppointments(assignedResourceMap.keySet());
                //fetch all the assigned resource corresponding to a service appointment ordered by created date 
                for(AssignedResource eachRes :ServiceAppointmentSelector.getAssignedResources(assignedResourceMap.keySet())
                   ){
                       if(!assignedResourceMapAll.containsKey(eachRes.ServiceAppointmentId)){
                           assignedResourceMapAll.put(eachRes.ServiceAppointmentId, new list<AssignedResource>());
                       }
                       assignedResourceMapAll.get(eachRes.ServiceAppointmentId).add(eachRes);
                   }
          }
            if(!serviceAppointList.isEmpty() ){
                for(ServiceAppointment serAppRec : serviceAppointList){
                    //fetch the first assinged resource from the list corresponding to the service appointment
                    if(!assignedResourceMapAll.isEmpty() && assignedResourceMapAll.containsKey(serAppRec.Id)){
                        List<AssignedResource> assignedRecList = new List<AssignedResource>(assignedResourceMapAll.get(serAppRec.Id));
                        if(!assignedRecList.isEmpty() && assignedRecList.size() <= 1){
                            finalAssgnResourceMap.put(serAppRec.Id, assignedRecList[0]);
                        }
                    } 
                }
            }
            if(!finalAssgnResourceMap.isEmpty()){
                Set<id> serviceTerritoryIdSet = New Set<id>();
                //fetch all the service resources corresponding to the assigned resources
                for(AssignedResource assignedResRec : finalAssgnResourceMap.values()){
                    ServiceResourceIDs.add(assignedResRec.ServiceResourceId);
                }
                Map<id,List<ServiceTerritoryMember> > serviceTeritoryMemberMap = new Map<id,List<ServiceTerritoryMember>>();
                List<ServiceTerritoryMember> serviceTeritoryMemberList = ServiceAppointmentSelector.getServiceTerritoryMember(ServiceResourceIDs);
                //fetch all the service territory and service territory member for each service resource
                for(ServiceTerritoryMember stmRec : serviceTeritoryMemberList){
                    if (!serviceTeritoryMemberMap.containsKey(stmRec.ServiceResourceId))
                        serviceTeritoryMemberMap.put(stmRec.ServiceResourceId, new List<ServiceTerritoryMember>());
                    serviceTeritoryMemberMap.get(stmRec.ServiceResourceId).add(stmRec);
                    serviceTerritoryIdSet.add(stmRec.ServiceTerritoryId);
                }
                if(!serviceTerritoryIdSet.isEmpty()){
                    Map<id, ServiceTerritory> serviceTerritoryMap = ServiceAppointmentSelector.getServiceTerritory(serviceTerritoryIdSet);
                    
                    if(!serviceTerritoryMap.isEmpty()){
                        
                        List<ServiceAppointment> ServiceAppList = ServiceAppointmentSelector.getServiceAppointments(finalAssgnResourceMap.keySet());
                        for(ServiceAppointment saRecord : ServiceAppList){
                            AssignedResource assignedRescRec = finalAssgnResourceMap.get(saRecord.Id);
                            if((saRecord.SchedStartTime != null && saRecord.SchedEndTime != null) 
                              ){
                                  List<ServiceTerritoryMember> serviceTerrMemberList =  new  List<ServiceTerritoryMember>();
                                  ServiceTerritory serviceTerr;
                                  if(assignedRescRec != null &&
                                     !serviceTeritoryMemberMap.isEmpty() &&
                                     serviceTeritoryMemberMap.containsKey(assignedRescRec.ServiceResourceId)
                                    ){
                                        serviceTerrMemberList = serviceTeritoryMemberMap.get(assignedRescRec.ServiceResourceId);
                                    }
                                  //it is assumed that there would be only one primary territory tagged to a service resource
                                  if(!serviceTerrMemberList.isEmpty() &&
                                     !serviceTeritoryMemberMap.isEmpty() &&
                                     serviceTerritoryMap.containsKey(serviceTerrMemberList[0].ServiceTerritoryId)
                                    ){
                                        serviceTerr = serviceTerritoryMap.get(serviceTerrMemberList[0].ServiceTerritoryId);
                                    }
                                  if(serviceTerr != null){
                                      String timeZoneUpdate = serviceTerr.OperatingHours.Timezone;
                                      if(timeZoneUpdate!=null){
                                          String strLocalSchedStartTime = saRecord.SchedStartTime.format('MM/dd/YYYY hh:mm a', timeZoneUpdate);
                                          string strLocalSchedEndTime = saRecord.SchedEndTime.format('MM/dd/YYYY hh:mm a', timeZoneUpdate);
                                          ServiceAppointment saUpdated = new ServiceAppointment();
                                          saUpdated.Id = saRecord.Id;
                                          saUpdated.Local_Scheduled_Start__c = strLocalSchedStartTime;
                                          saUpdated.Local_Scheduled_End__c = strLocalSchedEndTime;
                                          ServiceAppListToUpdate.add(saUpdated);
                                      }
                                  }
                              } 
                        }
                    }  
                }
            }
            if(!ServiceAppListToUpdate.isEmpty()){
                list<Database.SaveResult> listResult = Database.update(ServiceAppListToUpdate, false);
            }
        }catch(Exception e){
            System.debug('Exception::'+e.getMessage());
        }
    }  
*/
}