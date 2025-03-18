trigger updateacc on Account (after insert,before insert,before update) {

    map<String, Triggers_Execution_Handling__c> mapOfAction = Triggers_Execution_Handling__c.getAll();
    if(mapOfAction != null && mapOfAction.containsKey('Account') &&
       mapOfAction.get('Account').Execute_trigger__c) {
         AccountTriggerHandler acc= new AccountTriggerHandler();
           acc.runTrigger();
}
}