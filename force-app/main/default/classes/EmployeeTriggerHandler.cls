public with sharing class EmployeeTriggerHandler {
    public static void beforeInsert(List<Employee__c> newList){
        updateActive(newList);
        getEmployeeCount(newList);
    }
    public static void afterDelete(List<Employee__c> oldList, Map<Id, Employee__c> oldMap){
        getRemainingEmployee(oldList);
    }
    public static void afterInsert(List<Employee__c> newList){
        getEmployeeCount(newList);
    }
// ques 18
    private static void updateActive(List<Employee__c> employeeList) {
        Set<Id> accountIds = new Set<Id>();
        for(Employee__c employee : employeeList){
            accountIds.add(employee.Account__c);
        }
        
        List<Account> accounts = EmployeeService.getEmployeeRelatedAccount(accountIds);
        for(Account account : accounts){
            account.Active__c = 'Yes';
        }
        if(!accounts.isEmpty()){
            update accounts; //NOPMD
        }
    }
// ques 17
    private static void getRemainingEmployee(List<Employee__c> employeeList) {
        Set<Id> accountIds = new Set<Id>();
        for(Employee__c employee : employeeList){
            accountIds.add(employee.Account__c);
        }
        List<Account> accounts = EmployeeService.getEmployeeRelatedAccount(accountIds);
        for(Account account : accounts){    
            account.Left_Employee_Count__c = account.Employees__r.size();
        }
        if(!accounts.isEmpty()) {
            update accounts; //NOPMD
        }
    }
// ques 20   
    private static void getEmployeeCount(List<Employee__c> employeeList){
        Set<Id> accountIds = new Set<Id>();
        for(Employee__c employee : employeeList){
            accountIds.add( employee.Account__c);
        }
        List<Account> accounts = EmployeeService.getEmployeeRelatedAccount(accountIds);
        for(Account account : accounts){
            System.debug(account.Id);
            account.NumberOfEmployees = account.Employees__r.size();
        }
        if(!accounts.isEmpty()){
            update accounts;    //NOPMD
        }
    }

}