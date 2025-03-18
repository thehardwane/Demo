trigger checkIndstry on Account (before insert) {
    for (Account acc: Trigger.new)
    {
        if(acc.Industry=='Education')
        {
            acc.addError('Wrong');
        }
    }

}