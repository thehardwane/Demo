({// Your renderer method overrides go here
    render:function(component,helper)
    {
    
    var a= this.superRender();
    //custom rendering
    console.log("Hi render");
    return a;
    },
    
    afterRender:function(component,helper)
    {
        this.superAfterRender();
        console.log("text come after render() is over");
        console.log("Hi AfterRender");
    },
    
    rerender:function(component,helper)
    {
        this.superRerender();
       
        console.log("Hi Rerender");
    },
    unrender:function(component,helper)
    {
        this.superUnrender();
       
        console.log("component destroyed");
    }
})