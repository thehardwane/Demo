trigger AccountTeamMemberTrigger on AccountTeamMember (after insert,after update) {
    map<String, Triggers_Execution_Handling__c> mapOfAction = Triggers_Execution_Handling__c.getAll();
    if(mapOfAction != null && mapOfAction.containsKey('AccountTeamMember') &&
       mapOfAction.get('AccountTeamMember').Execute_trigger__c) {
         AccountTeamMemberHandler acc= new AccountTeamMemberHandler();
           acc.runTrigger();
           
       }
}