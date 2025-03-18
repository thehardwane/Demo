trigger afterUpdateContact on Contact (after update) {

    list<contact> conList= trigger.old;
    for(Contact con:conList)
    {
        if(con.Account==null)
        {
            con.Account.Description='abc';
        }
    }
}