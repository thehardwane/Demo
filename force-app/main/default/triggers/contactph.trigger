trigger contactph on Contact (before insert) {
    for(contact phone: Trigger.New)
    phone.Phone='8198918108';
   
   
}