trigger helloworldnew on Account (before insert) {
    
    for(Account a: trigger.new)
    {
        if(a.industry=='Education')
        a.adderror('we dont work with education');
    }
}