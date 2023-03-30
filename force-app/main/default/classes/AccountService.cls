public with sharing class AccountService {

    public static List<Contact> accountRelatedContacts(List<Account> accounts) {
        // create contact from Account
        List<Contact> contacts = new List<Contact>();
        for(Account account: accounts) {
            Contact relatedContact = new Contact();
            relatedContact.AccountId = account.Id;
            relatedContact.LastName = account.Name;
            contacts.add(relatedContact);    
        }
        return contacts;    
    }

    public static List<Opportunity> accountRelatedOpportunities(List<Account> accounts) {
        // create contact from Account
        List<Opportunity> opportunities = new List<Opportunity>();
        for(Account account: accounts) {
            Opportunity relatedOpportunite = new Opportunity();
            relatedOpportunite.AccountId = account.Id;
            relatedOpportunite.Name = account.Name;
            relatedOpportunite.CloseDate = System.Today();
            relatedOpportunite.StageName = 'Qualification';
            opportunities.add(relatedOpportunite);    
        }
        return opportunities;    
    }

    public static List<Contact> updateContactsPhone(Map<Id, String> accountIdPhoneUpdate) {
        List<Contact> contacts = ContactSelector.fetchContactRelatedToAccount(accountIdPhoneUpdate.keySet());
        for(Contact contact : contacts) {
            contact.Phone = accountIdPhoneUpdate.get(contact.AccountId);
        }
        return !contacts.isEmpty() ? contacts : NULL;
    }

    public static List<Opportunity> updateStageToCloseLost(Set<Id> accountsToUpdate) {
        List<Opportunity> allOpportunityToUpdate = [SELECT StageName FROM Opportunity WHERE AccountId IN: accountsToUpdate]; //NOPMD
        for(Opportunity OpportunityInstance: allOpportunityToUpdate) { //NOPMD
            if(OpportunityInstance.StageName != 'Close Won') {
                OpportunityInstance.StageName = 'Close Lost';
            }
        } 
        return !allOpportunityToUpdate.isEmpty() ? allOpportunityToUpdate : NULL;
    }

    public static List<Account> getRelatedOpportunities(List<Account> accounts){
        Set<Id> accountIds = new Set<Id>();
        for(Account account : accounts) {
            accountIds.add(account.Id);
        }
        List<Account> accountWithRelatedOpp = [SELECT Id,Name, (SELECT Id, AccountId FROM Opportunities) FROM ACCOUNT WHERE Id IN: accountIds]; //NOPMD
        if(accountWithRelatedOpp.isEmpty()){
            return NULL;
        }
        return accountWithRelatedOpp;
     }
}