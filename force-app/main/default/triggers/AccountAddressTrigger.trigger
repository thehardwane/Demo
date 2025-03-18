trigger AccountAddressTrigger on Account (before insert,before update) 
{
    for (Account acc: trigger.new)
    {
        if(acc.Match_Billing_Address__c==True || acc.BillingPostalCode!=NULL)
        {
           acc.ShippingPostalCode = acc.BillingPostalCode;
        

    }
    

}
}