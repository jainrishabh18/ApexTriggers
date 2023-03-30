public with sharing class EmployeeService {

    public static List<Account> getEmployeeRelatedAccount(Set<Id> accIds){
        List<Account> accounts = [SELECT Id, NumberOfEmployees, Left_Employee_Count__c FROM ACCOUNT WHERE Id IN : accIds]; //NOPMD
        return !accounts.isEmpty() ? accounts : NULL;
    }

}