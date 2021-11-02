public with sharing class GD_EmailManager {

    public static void sendMail(List<Contract__c> scope) {

        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

        EmailTemplate template = [SELECT Id, Subject, Body, HtmlValue FROM EmailTemplate WHERE DeveloperName = 'Start_Contract_Reminder'];
        User us = [SELECT Id FROM User WHERE Name = 'Pawel Wrzesien'];
        OrgWideEmailAddress orgAddress = [SELECT Id, Address FROM OrgWideEmailAddress WHERE Address = 'pawel.wrzesien@britenet.com.pl'];

        for (Contract__c contract : scope) {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setTemplateId(template.Id);
            email.setHtmlBody(template.Body);
            email.setToAddresses(new List<String>{contract.Doctor_Email__c});
            email.saveAsActivity = false;
            email.setTargetObjectId(us.Id);
            email.setOrgWideEmailAddressId(orgAddress.Id);
            String HTMLBody = template.Body;
            HTMLBody = HTMLBody.replace('{!Doctor__c.Name}', contract.Doctor__r.Name);
            HTMLBody = HTMLBody.replace('{!Contract__c.Name}', contract.Name);
            HTMLBody = HTMLBody.replace('{!Hospital__c.Name}', contract.Hospital__r.Name);
            HTMLBody = HTMLBody.replace('{!Today}', String.valueOf(Date.today()));
            HTMLBody = HTMLBody.replace('\n', '<br>');
            email.setHtmlBody(HTMLBody);
            email.setSubject(template.Subject);
            emails.add(email);
        }
        Messaging.sendEmail(emails);
    }
}