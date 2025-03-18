public class future {
    @future
    
    public static void futureExample(){
        Account acc=[Select name from Account limit 1];
        acc.Name='Update from future';
        acc.HOUSE_no__c='1234segfaset';
        update acc;
        
    }
}