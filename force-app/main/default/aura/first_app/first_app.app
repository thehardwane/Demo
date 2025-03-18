<aura:application extends="force:slds" >
  
   
    
    <aura:attribute name="RegForm" type= "Boolean" default="false" /> 
    <aura:attribute name="ButtonLabel" type= "String"  default="Open registration form" /> 
    <lightning:button label="{!v.ButtonLabel}" onclick="{!c.openOrCloseForm}"/>
    
    <aura:if isTrue="{!v.RegForm}">
    <c.registrationform/>
</aura:if>
    
   
	
</aura:application>