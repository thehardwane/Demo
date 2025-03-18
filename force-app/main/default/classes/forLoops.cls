public class forLoops {
    private String name;
    private Integer age;
    public forLoops()
    {
       
    }
    public void callprivate()
    {
        display1();
    }
    public void set(String n,Integer i)
    {
        name=n;
        age=i;
    }
    
    private void display1()
    {
        system.debug('my name is '+name);
        system.debug('my age is '+age);
    }
}