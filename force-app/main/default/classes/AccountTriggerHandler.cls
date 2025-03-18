public class AccountTriggerHandler {
    
    public void runtrigger(){
        
        if(Trigger.isAfter && Trigger.isInsert)
        {
            onAfterInsert((List<Account>)trigger.new);
        }
        
        if(Trigger.isBefore &&( Trigger.isInsert || Trigger.isUpdate))
        {
            onbefore((List<Account>)trigger.new);
        }
        }
    
    
    
    private void onAfterInsert(List<Account> lstaccount)
    {
        createContact(lstaccount);
    }
    
    
    
    private void onbefore(List<Account> lstaccount)
    {
        duplicateAccount(lstaccount);
    }
    
    
    private void createContact(List <Account> lstaccount)
    {
        list<Contact> conlist= new list<Contact>();
        
        for (Account acc: lstaccount)
        {
            Contact con= new contact();
            con.AccountId=acc.Id;
            con.LastName='Testaac';
            conlist.add(con);
        }
        insert conlist;
}
    
    
    private void duplicateAccount(List <Account> lstaccount)
    {
        For(Account acc:lstaccount)
        {
        List <Account> lstaccounts= [Select Id from Account where Name=:acc.Name ];
    
            if(!lstaccounts.isEmpty())
            {
                acc.addError('Preventing the users to create Duplicate Accounts');
            }
            }
    

}
    private void getContacts(List <Account> lstaccount)
    {
        For(Account acc:lstaccount)
        {
        List <Account> lstaccounts= [Select Id from Account where Name=:acc.Name ];
    
            if(!lstaccounts.isEmpty())
            {
                acc.addError('Preventing the users to create Duplicate Accounts');
            }
            }
    

}
    
    
}