trigger CaseTrigger on Case (before insert) {
    
    Map<String,Triggers_Execution_Handling__c> mapOfAction =Triggers_Execution_Handling__c.getAll();
    If(mapOfAction!=Null && mapOfAction.containsKey('Case') && mapOfAction.get('Case').Execute_trigger__c)
    {
        
        CaseTriggerHandler objCaseTriggerHandler= new CaseTriggerHandler();
        objCaseTriggerHandler.runTrigger();
        
    }
}