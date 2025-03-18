trigger checkEmail on Contact (before insert,before update) 
{
   for(contact  c: Trigger.new )
   {
       if(c.email!=null){
       if (Trigger.isInsert ) {
     
        System.debug('Please enter email');
    
   }
}
   }
}