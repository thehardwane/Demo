public class hello1 {
    public list<Contact> conList {get;set;}
public hello1()
{
    conList=[select firstName,lastName,Lastmodifiedby.Name ,AccountId from Contact];
}
}