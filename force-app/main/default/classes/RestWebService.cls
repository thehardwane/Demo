@RestResource(urlMapping='/Cases/*')
global with sharing  class RestWebService {
    @httpGet
    global static Case getCaseById()
    {
        RestRequest req= RestContext.request;
        String caseId=req.requestURI.subString(req.requestURI.lastIndexOf('/')+1);
        Case result=[Select CaseNumber,Subject,Origin from case where Id=:caseId];
        return result;
    }

}