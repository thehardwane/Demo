trigger updateOpp1 on Opportunity (before update) {
    for (Opportunity op:Trigger.New)
    {
        Opportunity oppOld=trigger.oldMap.get(op.Id);
        
        boolean checkValue=oppOld.StageName.equals('Closed Won');
        boolean checkNewValue=op.StageName.equals('Closed Won');
        if (!checkValue && checkNewValue)
        {
           op.Description='DS';
        }
    }

}