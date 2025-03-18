global class BatchClassForAccount implements Database.Batchable<sobject>
{
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
       // list<Account> acc=[select id from account  where name='United Oil & Gas Corp.'];
       List <Id> accid= new List <Id>();
     //   accid.add(acc.Id);
        return Database.getQueryLocator('Select Id ,Description,name,AccountId from Opportunity where AccountId in: accid ');
    }

    global void execute(Database.BatchableContext bc, List<Opportunity> opp)
    {
        for(Opportunity op:opp)
        {
            op.Description='Batch run completed';
            opp.add(op);
            
        }
        update opp;
    }
    global void finish(Database.BatchableContext bc)
    {
        
    }
}