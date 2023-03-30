public with sharing class CaseTriggerHandler {

    public static void beforeInsert(List<Case> newLisCase) { //NOPMD

     }
     
     public static void afterInsert(List<Case> newList) {
        updateLatestCaseNumber(newList);
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
}