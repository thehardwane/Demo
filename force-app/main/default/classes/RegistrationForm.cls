public class RegistrationForm {
    
    public static Id getRegistrationFormDetails(Registration_Form__c regFormObj)
    {
        insert regFormObj;
        return regFormObj.Id;
    }

}