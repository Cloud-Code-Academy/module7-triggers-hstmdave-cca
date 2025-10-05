public with sharing class AccountTriggerHelper {
    
    public static void accountBeforeInsert(List<Account> triggerNew) {
        // Question 1 - Assigning Type if it is null
        for(Account assignType : triggerNew) {
            if(assignType.Type != null) {
                continue;
            }
            assignType.Type = 'Prospect';
        }
        
        // Question 2 - Check if shipping address is populated and copy to billing address if so
        for(Account copyAddress : triggerNew) {
            if(
                copyAddress.ShippingStreet == null &&
                copyAddress.ShippingCity == null &&
                copyAddress.ShippingState == null &&
                copyAddress.ShippingPostalCode == null &&
                copyAddress.ShippingCountry == null
            ) {
                continue;
            }
            copyAddress.BillingStreet = copyAddress.ShippingStreet;
            copyAddress.BillingCity = copyAddress.ShippingCity;
            copyAddress.BillingState = copyAddress.ShippingState;
            copyAddress.BillingPostalCode = copyAddress.ShippingPostalCode;
            copyAddress.BillingCountry = copyAddress.ShippingCountry;            
        }

        // Question 3 - Update rating to 'Hot' if the Phone, Website, and Fax ALL have a value.
        for(Account assignRating : triggerNew) {
            if(assignRating.Phone == null || assignRating.Website == null || assignRating.Fax == null) {
                continue;
            }
            assignRating.Rating = 'Hot';
        }
    }

    public static void accountAfterInsert(Map<Id, Account> triggerNewMap) {
        /* Question 4 - When an account is inserted create a contact related to the account with the following default values:
            * LastName = 'DefaultContact'
            * Email = 'default@email.com'
        */
        List<Contact> newContacts = new List<Contact>();
        for(Id mapKey : triggerNewMap.keySet()) {
            Contact contactRecord = new Contact();
            contactRecord.LastName = 'DefaultContact';
            contactRecord.Email = 'default@email.com';
            contactRecord.AccountId = mapKey;
            newContacts.add(contactRecord);
        }
        if(!newContacts.isEmpty()) {
            insert newContacts;
        }

    }
}


