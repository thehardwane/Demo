public with sharing class AutoCreateServiceAppointments {
    /*
    
    public static void AddServiceAppointmentsToWorkOrder(List<WorkOrder> WOrRec){       
        try{
            for(WorkOrder wor : WOrRec){
                if(wor.Multiple_Appointments_Required__c==true){ 
                    Integer cnt = Integer.valueOf(wor.Number_of_appointments_to_be_created__c);
                    //WorkOrder recWorkOrder = [select id,Due_Date__c,ServiceTerritoryId, WorkTypeId,ContactId,StartDate from WorkOrder where id=:wor.id];
                    List<ServiceAppointment>ServiceAppointmenttoadd = new List<ServiceAppointment>();
                   for(Integer i=0;i<cnt;i++){
                        ServiceAppointment ser = new ServiceAppointment();     
                        ser.ParentRecordId = wor.id;
                        //ser.ContactId = '0036s0000052ff4AAA';
                        ser.ServiceTerritoryId = wor.ServiceTerritoryId;
                        ser.DueDate = wor.Due_Date__c;
                        ser.EarliestStartTime = wor.StartDate;
                        ser.Start_Date__c = wor.StartDate;
                        ser.Duration = wor.Duration;
                        ser.Recommended_Engagement_Tools__c = wor.Recommended_Engagement_Tools__c;
                        ServiceAppointmenttoadd.add(ser);
                    }
                    if(ServiceAppointmenttoadd.size()>0){
                        insert ServiceAppointmenttoadd;
                        updateServiceAppointment(wor.id);
                    }
                }
                else{
                    ServiceAppointment ser = new ServiceAppointment();
                    ser.ParentRecordId = wor.id;
                    //ser.ContactId = '0036s0000052ff4AAA';
                    ser.ServiceTerritoryId = wor.ServiceTerritoryId;
                    ser.DueDate = wor.Due_Date__c;
                    ser.EarliestStartTime = wor.StartDate;
                    ser.Start_Date__c = wor.StartDate;
                    ser.Duration = wor.Duration;
                    ser.Recommended_Engagement_Tools__c = wor.Recommended_Engagement_Tools__c;
                    insert ser;
                    updateServiceAppointment(wor.id);   
                }
            }      
        }catch(exception e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
    }
    
    
    public static void updateServiceAppointment(Id workId){
        try{ 
            List<ServiceAppointment>ServiceAppointmenttoupdate = new List<ServiceAppointment>();
            for(ServiceAppointment ser: [select id,ContactId from ServiceAppointment where ParentRecordId=:workId])   
            {
                ser.ContactId = null;
                ServiceAppointmenttoupdate.add(ser);
            }
            if(ServiceAppointmenttoupdate.size()>0){
                update ServiceAppointmenttoupdate; 
            }
        }catch(exception e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
    }
*/
}