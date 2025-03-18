public  class StringArrayTest {
    
    
    public static  list<String> generateStringArray(Integer n)
    {
        list<String> lstString= new List<String>();
        
        For(Integer i=0;i<n;i++)
        {
            lstString.add('Test'+i);
            
        }
        System.debug(lstString);
        return lstString;
    }

}