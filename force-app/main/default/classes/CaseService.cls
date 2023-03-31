public with sharing class CaseService {
    public static List<Account> caseRelatedAccounts(List<Case> caseList) {
        List<Account> accounts = new List<Account>();
        //  takes case id, store's it in account id whenever a new case is generated it updates LatesCaseNumber
        for(Case cs: caseList) {
            if(cs.AccountId != NULL) {
                Account account = new Account();
                // account.Id stores the parent account id of case
                account.Id = cs.AccountId;
                account.Latest_Case_Number__c = cs.CaseNumber;
                accounts.add(account);
            }    
        }
        return accounts;
    }

    public static List<Account> getRelatedAccount(Set<Id> accountIds){
        List<Account> accounts = [SELECT Id, NumberOfEmployees, Left_Employee_Count__c, Total_Customer_Case__c, Total_Partner_Case__c FROM ACCOUNT WHERE Id IN : accountIds];   //NOPMD
        return !accounts.isEmpty() ? accounts : NULL;
    }    
}