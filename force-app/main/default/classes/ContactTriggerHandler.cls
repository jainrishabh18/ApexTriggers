public class ContactTriggerHandler {  //NOPMD

    public static void afterInsert(List<Contact> newList) {
        sendEmailAfterInsert(newList);
    }
    public static void beforeInsert(List<Contact> oldList) {
        preventDuplicateRecordByEmail(oldList);
    }
    public static void beforeUpdate(List<Contact> newList, Map<Id, Contact> oldMap) { //NOPMD
         
    }
      
    public static void afterUpdate(List<Contact> newList, Map<Id, Contact> oldMap) { //NOPMD
          
    }
      
    public static void beforeDelete(List<Contact> oldList) { //NOPMD
          
    }
      
    public static void afterDelete(List<Contact> oldList) { //NOPMD
          
    }

    // Scenerio 21
    private static void sendEmailAfterInsert(List<Contact> contacts) {
        List<Messaging.SingleEmailMessage> emailList= new List<Messaging.SingleEmailMessage>();
        EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body           //NOPMD
                                        from EmailTemplate where name='Contact Email']; 
        for(Contact conObj : contacts) {
            if (conObj.Email != null) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setTargetObjectId(conObj.Id);
                mail.setSenderDisplayName('System Administrator');
                mail.setUseSignature(false);
                mail.setBccSender(false);
                mail.setSaveAsActivity(false);
                mail.setTemplateID(emailTemplate.Id);
                mail.toAddresses = new String[]{conObj.Email};
                System.debug(conObj.Email);
                emailList.add(mail);
            }
        }
        if(emailList.size()>0){
            Messaging.SendEmailResult[] results = Messaging.sendEmail(emailList);
        }
    }
    
    // Scenerio 30
    private static void preventDuplicateRecordByEmail(List<Contact> contacts) {
        Set<String> emailIds = new Set<String>();
        for(Contact contact : contacts) {
            if(contact.Email != NULL) { 
                emailIds.add(contact.Email); 
            }    
        }
        List<Contact> oldContacts = ContactService.getContactsByEmail(emailIds); 
        for(Contact contact : contacts) {
            if(oldContacts.size() > 0) {
            contact.addError('Already Existing Contact with this Email');
            } 
        }
    }

}