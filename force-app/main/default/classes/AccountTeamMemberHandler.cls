public  without sharing class AccountTeamMemberHandler {
    
    public  void runTrigger()
    {
        if(Trigger.isBefore && Trigger.isInsert)
        {
          onBeforeInsert((List<AccountTeamMember>)trigger.new);
        }
    }
    
    private void onBeforeInsert(List<AccountTeamMember> listTriggerNew)
       {
        addAccountTeamToGroup(listTriggerNew);
        }
    
    
    private static void addAccountTeamToGroup(List<AccountTeamMember> listTriggerNew)
    {   
        
        for(AccountTeamMember accTeamMember: listTriggerNew)  
           {
               list<Account> accountOwnerId=new list<Account> ([Select OwnerId  from Account where Id =: accTeamMember.AccountId ]);
               
              Id aid11=accountOwnerId.get(0).OwnerId;
               
               System.debug('test======='+accountOwnerId);
               System.debug('testqqqq======='+aid11);
               
             
              
               
            
              If (accTeamMember.AccountId!=Null && aid11!=UserInfo.getUserId()&& aid11!=accTeamMember.CreatedById )
                  
               {
                accTeamMember.addError('Only Owner can add Team members');
               }
               System.debug('test owner1 ======='+UserInfo.getUserId());
               System.debug('test Created by Id ======='+accTeamMember.CreatedById);
               
           }
    }
    
}