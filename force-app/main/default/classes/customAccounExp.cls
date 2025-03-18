public class customAccounExp {

    public static void mainProcess()
    {
        try{
        insertAcc();
        }
        catch (CustomException ce)
        {
         system.debug('message'+ce.getMessage());   
        }
    }
    public static void insertAcc()
    {
        try{
            Account ac= new Account();
            insert ac;

               }
        catch(DmlException de )
        {
            throw new CustomException('Please insert mandotry feilds to create a new account record',de);
        }
    }
}