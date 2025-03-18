public class abcd 
{

Public static void abc()
{
    List<Account> conList = new List<Account>
{
    new Account(Name='shu1',HOUSE_no__c='shubham'),
        new Account(Name='athy',HOUSE_no__c='shubham123'),
        new Account(Name='roline',HOUSE_no__c='shubham1'),
        new Account(Name='im')

        };
            System.debug('Abc');
            insert conList;
}
}