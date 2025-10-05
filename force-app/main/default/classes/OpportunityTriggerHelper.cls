public with sharing class OpportunityTriggerHelper {

    public static void oppBeforeUpdate(Map<Id, Opportunity> triggerNewMap) {
        /* 
        Question 5 - When an opportunity is updated validate that the amount is greater than 5000.
        If amount < 5000, Error Message: 'Opportunity amount must be greater than 5000'
        */

        for(Opportunity oppValue : triggerNewMap.values()) {
            if(oppValue.Amount < 5000) {
                oppValue.Amount.addError('Opportunity amount must be greater than 5000');
            }
        }

        // Question 7 - When an opportunity is updated set the primary contact on the opportunity to the contact on the same account with the title of 'CEO'.

        Set<Id> accIds = new Set<Id>();
        for(Opportunity opp : triggerNewMap.values()) {
            if(opp.AccountId != null) {
                accIds.add(opp.AccountId);
            }
        }

        Map<Id, Contact> contactMap = new Map<Id, Contact>();
        if(!accIds.isEmpty()) {
            for(Contact contactRec : [
                SELECT
                    Id,
                    Title,
                    AccountId
                FROM Contact
                WHERE AccountId
                IN :accIds
                AND Title = 'CEO'
            ]) {
                contactMap.put(contactRec.AccountId, contactRec);
            }
        }

        for(Opportunity opp : triggerNewMap.values()) {
            if(opp.AccountId != null && contactMap.containsKey(opp.AccountId)) {
                opp.Primary_Contact__c = contactMap.get(opp.AccountId).Id;
            }
            else {
                opp.Primary_Contact__c = null;
            }
        }

    }

    public static void oppBeforeDelete(Map<Id, Opportunity> triggerOldMap) {
        /*
        Question 6 - When an opportunity is deleted prevent the deletion of a closed won opportunity if the account industry is 'Banking'.
	    Error Message: 'Cannot delete closed opportunity for a banking account that is won'
        */

        Set<Id> accIds = new Set<Id>();
        for(Opportunity opp : triggerOldMap.values()) {
            if(opp.AccountId != null) {
                accIds.add(opp.AccountId);
            }   
        }

        Map<Id, Account> accMap = new Map<Id, Account>();
        if(!accIds.isEmpty()) {
            accMap = new Map<Id, Account>   ([
                                            SELECT 
                                                Id,
                                                Industry
                                            FROM Account
                                            WHERE Id
                                            IN :accIds
                                            ]);
        }

        for(Opportunity oppIndustry : triggerOldMap.values()) {
            Account relatedAcc = accMap.get(oppIndustry.AccountId);
            if(oppIndustry.StageName == 'Closed Won' && relatedAcc.Industry == 'Banking') {
                oppIndustry.addError('Cannot delete closed opportunity for a banking account that is won');
            }
        }
        
    }

}