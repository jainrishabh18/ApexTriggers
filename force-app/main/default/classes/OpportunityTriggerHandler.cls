public with sharing class OpportunityTriggerHandler {
    
    public static void beforeInsert(List<Opportunity> newList) {
        updateDescriptionRelatedToAmount(newList);
        updateDescriptionOnStage(newList, NULL);
    }
    public static void afterInsert(List<Opportunity> newList) {
        updateOpportunityAmount(newList);
    }
    
    public static void beforeUpdate(List<Opportunity> newList, Map<Id, Opportunity> oldMap) { //NOPMD
        updateDescriptionOnStage(newList, oldMap);
        errorOnReasonFieldNotPopulated(newList, oldMap);
    }
    
    public static void afterUpdate(List<Opportunity> newList, Map<Id, Opportunity> oldMap) { //NOPMD
        createTaskOnStageUpdate(newList, oldMap);
    }
    
    public static void beforeDelete(List<Opportunity> oldList) { //NOPMD
        removeOpportunityIfSystemAdministrator(oldList);
    }
    
    public static void afterDelete(List<Opportunity> oldList) { //NOPMD
        
    }
    
    // update's description if amount > 100000
    private static void updateDescriptionRelatedToAmount(List<Opportunity> opportunities) { //NOPMD
        for(Opportunity opportunitie: opportunities) {
            if(opportunitie.Amount != NULL && opportunitie.Amount > 100000) {
               	opportunitie.Description = 'Hot Opportunity';
            }
        }
    }
    // updates opportunity amount => recent opportunity amount field in Accounts
    private static void updateOpportunityAmount(List<Opportunity> opportunityList) {
        
        List<Account> accounts = new List<Account>();

        for(Opportunity opportunitie: opportunityList) {
            if( opportunitie.AccountId != NULL && opportunitie.Amount != NULL) {
                Account account = new Account();
                account.id = opportunitie.AccountId;
                account.Recent_Opportunity_Amount__c = opportunitie.Amount;
                accounts.add(account);
            }
        }
        if(!accounts.isEmpty()) {
            update accounts;            //NOPMD
        }
    }
// Scenerio 2 and Scenerio 26
    private static void updateDescriptionOnStage(List<Opportunity> opportunities, Map<Id, Opportunity> oldOppportunitiesMap) { //NOPMD
        for(Opportunity opportunitie: opportunities) { 
            //update case
            if(oldOppportunitiesMap != NULL && opportunitie.StageName != NULL) {
                if(opportunitie.StageName != oldOppportunitiesMap.get(opportunitie.Id).StageName && opportunitie.StageName == 'Closed Won') {
                    opportunitie.Description = 'Opp is Closed Won';
                } else if(opportunitie.StageName != oldOppportunitiesMap.get(opportunitie.Id).StageName && opportunitie.StageName == 'Closed Lost') {
                    opportunitie.Description = 'Opp is Closed Lost';
                } else {
                    opportunitie.Description = 'Opp is Closed Open';
                }
            } else if(opportunities!= NULL && opportunitie.StageName != NULL) {
                if(opportunitie.StageName == 'Closed Won') {
                    opportunitie.Description = 'Opp is Closed Won';
                } else if(opportunitie.StageName == 'Closed Lost') {
                    opportunitie.Description = 'Opp is Closed Lost';
                } else {
                    opportunitie.Description = 'Opp is Open';
                }
            }
        }
    }
// Scenerio 7
    private static void createTaskOnStageUpdate(List<Opportunity> opportunities, Map<Id, Opportunity> oldOppportunitiesMap) {
        
        List<Task> insertTaskList = new List<Task>();
        for(Opportunity opportunitieInstance: opportunities) {
            if(opportunitieInstance.StageName != oldOppportunitiesMap.get(opportunitieInstance.Id).StageName) {
                Task relatedTask = new Task();
                relatedTask.WhatId = opportunitieInstance.Id;
                relatedTask.ownerId = opportunitieInstance.ownerId;
                relatedTask.Subject ='Call';
                relatedTask.Priority ='Low';
                relatedTask.Status ='In Progress';
                insertTaskList.add(relatedTask);
            }
        }
        if(!insertTaskList.isEmpty()) {
            insert insertTaskList; //NOPMD
        }
    }
// Scenerio 12
    private static void errorOnReasonFieldNotPopulated(List<Opportunity> opportunities, Map<Id, Opportunity> oldOppportunitiesMap) {
        for(Opportunity opportunitieInstance: opportunities) {
            if(opportunitieInstance.StageName != oldOppportunitiesMap.get(opportunitieInstance.Id).StageName) {
                if(opportunitieInstance.StageName == 'Closed Lost' && opportunitieInstance.Closed_Lost_Reason__c == NULL){
                    opportunitieInstance.addError('Please populate Closed Lost Reason');
                }
            }
        }
    }

// Scenerio 14
    private static void removeOpportunityIfSystemAdministrator(List<Opportunity> opportunities) {
        Id systemAdministratorId = UserInfo.getProfileId();
        Profile profileName = [SELECT Name,Id FROM Profile WHERE Id =: systemAdministratorId LIMIT 1]; //NOPMD
        for(Opportunity opportunity : opportunities) {
            if((opportunity.StageName == 'Closed Won' || opportunity.StageName == 'Closed Lost') && profileName.Name != 'System Administrator') {
                 opportunity.addError('No Access for Deletion');
            }
        }
    }
// Scenerio 23
    public static List<Account> updateOpportunityRelatedAccounts(Set<Id> AccountIds) { //NOPMD
        List<Account> accounts = new List<Account>();
        AggregateResult[] groupedResults = [SELECT AccountId, Sum(Amount)annulRevenue FROM Opportunity  WHERE AccountId IN: AccountIds GROUP BY AccountId]; //NOPMD
        for (AggregateResult variable : groupedResults) {
            String accountId = String.valueOf(variable.get('AccountId'));
            Integer annualRevenue = Integer.valueOf(variable.get('annulRevenue'));
            accounts.add(new Account(Id = accountId, AnnualRevenue = annualRevenue));
        }
        return accounts;
    }
// 
}