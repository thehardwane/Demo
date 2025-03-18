public class CaseTriggerHandler {
    
    public void runTrigger(){
        if(Trigger.isBefore && Trigger.isInsert)
        {
            System.debug('inside runTrigger');
          onBeforeInsert((List<Case>)Trigger.New);
        }
    }
    
    private void onBeforeInsert(List<Case> listTriggerNew)
       {
           System.debug('inside onBeforeInsert');
        caseOriginEmail(listTriggerNew);
        }

    Private  void caseOriginEmail(List<Case> listTriggerNew)
    {
        
        for(Case orginCase:listTriggerNew)
        {
            System.debug('inside for');
            if(orginCase.origin=='Email')
            {
                
                orginCase.status = 'New';
             
                orginCase.priority = 'Medium';
                System.debug('inside if');
            }
            
        }
    }
}