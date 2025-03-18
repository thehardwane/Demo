public class intergration 

{ 
    public static void getJobData(Id jobId) 
	{ 
   
        Http http = new Http(); 
        HttpRequest request = new HttpRequest(); 
        request.setEndpoint('callout:itachi/services/apexrest/JobApplicationServer/'+jobId); 
        request.setMethod('GET'); HttpResponse response = http.send(request); 
        if(response.getStatusCode() == 200) 
        { 
                   
                    Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                    decimal Amount = (decimal) results.get('Amount__c');
            		Id Amounts = (Id) results.get('Id');
               		Map<String,Object> Amounts1= (Map<String,object>) results.get( 'attributes');
                    String Amount2 = (String) Amounts1.get('type');
                    String amt3 = (String) Amounts1.get('url');
                     
                     system.debug(response.getBody()); 
                     System.debug(results);
                     //System.debug(Amount);
                     //System.debug(Amounts);
                     //System.debug(Amounts1);
                    //System.debug(Amount2);
                    //System.debug(amt3);
        } 
    }
}