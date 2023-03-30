public with sharing class AccountTriggerHandler { //NOPMD
   
    public static void beforeInsert(List<Account> newList) {
        updateRatingRelatedToIndustry(newList,NULL);
        copyBillingToShippingAddress(newList);
    }
     
    public static void afterInsert(List<Account> newList) {
        createRelatedContact(newList);
        createRelatedOpportunity(newList);
        createRelatedContactOrOpportunity(newList);
    }
     
    public static void beforeUpdate(List<Account> newList, Map<Id, Account> oldMap) { //NOPMD
        updateDescriptionOnPhoneChange(newList,oldMap);
        preventEditAccount(newList,oldMap);
    }
     
    public static void afterUpdate(List<Account> newList, Map<Id, Account> oldMap) { //NOPMD
        updateRelatedContactPhone(newList,oldMap);
        updateStageOnAccountActive(newList,oldMap);
    }
     
    public static void beforeDelete(List<Account> oldList) { //NOPMD
        stopDeleteOnActiveAccount(oldList);
    }
     
    public static void afterDelete(List<Account> oldList) { //NOPMD
         
    }
     
    private static void updateRatingRelatedToIndustry(List<Account> accounts, Map<Id, Account> oldAccountDetailsMap) { 
         //updating rating based on industry type
         for(Account account: accounts ) {
            if(oldAccountDetailsMap != NULL && account.Industry != NULL && account.Industry == 'Media') {
                if(account.Industry != oldAccountDetailsMap.get(account.Id).Industry) {
                    account.Rating = 'Hot';
                }    
            } else if(account.Industry != NULL && account.Industry == 'Media') {
                account.Rating = 'Hot';
            }
         } 
    }

     //copy Billing Address Fields => Shipping Address
    private static void copyBillingToShippingAddress(List<Account> accounts) { //NOPMD
        for(Account account : accounts) {
            if(account.CopyBillingToShipping__c  ) {
                if(account.BillingStreet != NULL) account.ShippingStreet = account.BillingStreet;   //NOPMD
                if(account.BillingCity != NULL) account.ShippingCity = account.BillingCity;     //NOPMD
                if(account.BillingPostalCode != NULL) account.ShippingPostalCode = account.BillingPostalCode;   //NOPMD
                if(account.BillingState != NULL) account.ShippingState = account.BillingState;  //NOPMD
                if(account.BillingCountry != NULL) account.ShippingCountry =  account.BillingCountry;   //NOPMD 
            }
        }
    }

    private static void createRelatedContact(List<Account> accounts) {
        List<Contact> contacts = AccountService.accountRelatedContacts(accounts);
        if(!contacts.isEmpty()) { 
            insert contacts;        //NOPMD
        }
    }

    private static void createRelatedOpportunity(List<Account> accounts) {
        List<Opportunity> opportunities = AccountService.accountRelatedOpportunities(accounts);
        if(!opportunities.isEmpty()) { 
            insert opportunities;        //NOPMD
        }
    }

    private static void createRelatedContactOrOpportunity(List<Account> accounts) {
        for(Account account : accounts) {
            if(account.Contact__c) {
                createRelatedContact(accounts);
            }
            if(account.Opportunity__c && account.Active__c == 'Yes') {
                createRelatedOpportunity(accounts);
            }
        }
    }

    private static void updateDescriptionOnPhoneChange(List<Account> accounts, Map<Id, Account> accountMap) {
        for(Account account : accounts) {
            if(account.Phone != accountMap.get(account.Id).Phone){
                account.Description = ' Phone is Updated! Old Value : ' + accountMap.get(account.Id).Phone + ' and new value : ' + account.Phone;
            }
        }
    }

    // ques 3
    private static void updateRelatedContactPhone(List<Account>accounts, Map<Id, Account> accountMap) {
        Map<Id, String> accountIdPhoneUpdate = new Map<Id, String>();
        for(Account account: accounts) {
            if(account.Phone != accountMap.get(account.Id).phone) {
            // stores all account id and phone number whoes number is updated
                accountIdPhoneUpdate.put(account.Id, account.phone);
            }
            // List to store all contacts to update
            List<Contact> contacts = AccountService.updateContactsPhone(accountIdPhoneUpdate);
            if(!contacts.isEmpty()) {
                update contacts;    //NOPMD
            }
        }
    }


    //Ques 5
    // private static void setBillingToMailingAddress(List<Account> newList, Map<Id, Account> oldMap){ //NOPMD
    //     List<Contact> newContacts = new List<Contact>();
    //     Map<Id, Account> idToAccountMap = new Map<Id, Account>();
    //     for(Account account : newList){
    //         if(account.BillingCountry != oldMap.get(account.Id).BillingCountry && oldMap!=NULL){
    //             idToAccountMap.put(account.Id, account);
    //         }
    //         if(account.BillingGeocodeAccuracy != oldMap.get(account.Id).BillingGeocodeAccuracy && oldMap!=NULL){
    //             idToAccountMap.put(account.Id, account);
    //         }
    //         if(account.BillingLatitude != oldMap.get(account.Id).BillingLatitude && oldMap!=NULL){
    //             idToAccountMap.put(account.Id, account);
    //         }
    //         if(account.BillingLongitude != oldMap.get(account.Id).BillingLongitude && oldMap!=NULL){
    //             idToAccountMap.put(account.Id, account);
    //         }
    //         if(account.BillingPostalCode != oldMap.get(account.Id).BillingPostalCode && oldMap!=NULL){
    //             idToAccountMap.put(account.Id, account);
    //         }
    //         if(account.BillingState != oldMap.get(account.Id).BillingState && oldMap!=NULL){
    //             idToAccountMap.put(account.Id, account);
    //         }
    //         if(account.BillingStreet != oldMap.get(account.Id).BillingStreet && oldMap!=NULL){
    //             idToAccountMap.put(account.Id, account);
    //         }
    //     }
    //     List<Contact> oldContacts = [SELECT AccountId, Id FROM Contact WHERE AccountId IN: idToAccountMap.keyset()]; //NOPMD
    //     for(Contact contactInstance : oldContacts){
    //         if(idToAccountMap.containsKey(contactInstance.AccountId)){
    //             contactInstance.MailingCountry = idToAccountMap.get(contactInstance.AccountId).BillingCountry;
    //             contactInstance.MailingState = idToAccountMap.get(contactInstance.AccountId).BillingState;
    //             contactInstance.MailingStreet = idToAccountMap.get(contactInstance.AccountId).BillingStreet;
    //             contactInstance.MailingPostalCode = idToAccountMap.get(contactInstance.AccountId).BillingPostalCode;
    //             newContacts.add(contactInstance);
    //         }
    //     }
    //     if(!newContacts.isEmpty()){
    //         update newContacts; //NOPMD
    //     }
    // }
    
    // Ques 6
    // private static void setBillingToMailingAddress(List<Account> newList, Map<Id, Account> oldMap){ //NOPMD
    //     List<Contact> newContacts = new List<Contact>();
    //     Set<Id> accountIds = new Set<Id>();
    //     for(Account account : newList){
    //         if(account.BillingCountry != oldMap.get(account.Id).BillingCountry && oldMap!=NULL){
    //             accountIds.add(account.Id);
    //         }
    //         if(account.BillingGeocodeAccuracy != oldMap.get(account.Id).BillingGeocodeAccuracy && oldMap!=NULL){
    //             accountIds.add(account.Id);
    //         }
    //         if(account.BillingLatitude != oldMap.get(account.Id).BillingLatitude && oldMap!=NULL){
    //             accountIds.add(account.Id);
    //         }
    //         if(account.BillingLongitude != oldMap.get(account.Id).BillingLongitude && oldMap!=NULL){
    //             accountIds.add(account.Id);
    //         }
    //         if(account.BillingPostalCode != oldMap.get(account.Id).BillingPostalCode && oldMap!=NULL){
    //             accountIds.add(account.Id);
    //         }
    //         if(account.BillingState != oldMap.get(account.Id).BillingState && oldMap!=NULL){
    //             accountIds.add(account.Id);
    //         }
    //         if(account.BillingStreet != oldMap.get(account.Id).BillingStreet && oldMap!=NULL){
    //             accountIds.add(account.Id);
    //         }
    //     }
    //     List<Account> oldAccounts = [SELECT Id, BillingCountry, BillingState, BillingStreet, BillingPostalCode,(SELECT Id FROM contacts) FROM Account WHERE Id IN: accountIds]; //NOPMD
    //     for(Account accountInstance : oldAccounts){
    //         for(Contact contactInstance : accountInstance.Contacts){
    //             contactInstance.MailingCountry = accountInstance.BillingCountry;
    //             contactInstance.MailingState = accountInstance.BillingState;
    //             contactInstance.MailingStreet = accountInstance.BillingStreet;
    //             contactInstance.MailingPostalCode = accountInstance.BillingPostalCode;
    //             newContacts.add(contactInstance);
    //         }
    //     }
    //     if(!newContacts.isEmpty()){
    //         update newContacts; //NOPMD
    //     }
    // }

    //Ques 8
    private static void updateStageOnAccountActive(List<Account> accounts, Map<Id, Account> accountMap) {
        Set<Id> accountsToUpdate = new Set<Id>();
        for(Account account: accounts) { 
            // for update
            if(account.Active__c != accountMap.get(account.id).Active__c) {
                if(account.Active__c !=NULL && account.Active__c == 'No') {
                    accountsToUpdate.add(account.Id);
                }
            }
        }
        List<Opportunity> updatedOpportunityList = AccountService.updateStageToCloseLost(accountsToUpdate);
        if(!updatedOpportunityList.isEmpty() && updatedOpportunityList != NULL) {
            update updatedOpportunityList;    //NOPMD
        }
    }

    //Ques 9
    private static void stopDeleteOnActiveAccount(List<Account> accounts) {
        for(Account account: accounts) {
            if(account.Active__c != NULL && account.Active__c == 'Yes') {
                account.adderror('Cannot Delete As Account set to Active');
            }
        }
    }

    //Ques 10
    private static void preventEditAccount(List<Account> accounts, Map<Id, Account> accountMap) {
        for(Account account: accounts) { 
            if(account.createdDate < System.Today().addDays(-7)) {
                account.addError('Cannot Edit as Account created 7 days before');
            }
        }   
    }
    
    // ques 13
    private static void deleteAccessOnlyToSystemAdmin(List<Account> accounts){
        String currentUserId = UserInfo.getProfileId();
        String systemAdministratorId = [Select Id, Name from Profile where Name = 'System Administrator' Limit 1].Id;
        
        for(Account account : accounts){
            if(currentUserId != systemAdministratorId){
               account.addError('You Cannot Delete this record');
            }
        }
    }




}