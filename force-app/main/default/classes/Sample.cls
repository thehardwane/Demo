public with sharing class Sample {
    public List<Account> accList{get;set;}

    public Sample()
    {
        accList=[Select Name,id from Account limit 10];
    }
    
    
}