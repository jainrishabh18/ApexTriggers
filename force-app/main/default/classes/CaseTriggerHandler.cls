public with sharing class CaseTriggerHandler {

   public static void beforeInsert(List<Case> newLisCase) { //NOPMD

   }
     
   public static void afterInsert(List<Case> newList) {
      updateLatestCaseNumber(newList);
      populateAccountWithCaseType(newList);
   }
     
   public static void beforeUpdate(List<Case> newList, Map<Id, Case> oldMap) { //NOPMD
         
   }
     
   public static void afterUpdate(List<Case> newList, Map<Id, Case> oldMap) { //NOPMD
         
   }
     
   public static void beforeDelete(List<Case> oldList) { //NOPMD
         
   }
     
   public static void afterDelete(List<Case> oldList) { //NOPMD
         
   }

   private static void updateLatestCaseNumber(List<Case> caseList) {
        
      List<Account> accounts = CaseService.caseRelatedAccounts(caseList);
      if(!accounts.isEmpty()) {
          update accounts;        //NOPMD
      }
   }

//    Scenerio 22
   private static void populateAccountWithCaseType(List<Case> casesList) {   //NOPMD
         Map<Id, Case> idToCustomerCase = new Map<Id, Case>();
         Map<Id, Case> idToPartnerCase = new Map<Id, Case>();
     
         Set<Id> accountIds = new Set<Id>();
         //List<Case> casesWithRecordType = CaseService.getRecordTypes(); //List of all the cases 
         for(Case currentCase : casesList) {
             accountIds.add(currentCase.AccountId);

             if(currentCase.RecordType.DeveloperName == 'Customer_Case'){
                 idToCustomerCase.put(currentCase.Id, currentCase);
             }

             if(currentCase.RecordType.DeveloperName == 'Partner_Case'){
                 idToPartnerCase.put(currentCase.Id, currentCase);
             }
         }
         //will access all the accounts related to casesList       
         List<Account> accounts = CaseService.getRelatedAccount(accountIds);
         System.debug(accounts);
         for(Account account : accounts){
             for(Case currentCase : casesList){
                 if(account.Id == currentCase.AccountId){
                     if(idToCustomerCase.containsKey(currentCase.Id)){
                         account.Total_Customer_Case__c += 1;
                     }
                     if(idToPartnerCase.containsKey(currentCase.Id)){
                         account.Total_Partner_Case__c += 1;
                     }
                 }
             }
         }
         update accounts;  //NOPMD
      }
} 

