trigger OpportunityTrigger on Opportunity (before update, before delete) {

    if(Trigger.isBefore && Trigger.isUpdate) {
        OpportunityTriggerHelper.oppBeforeUpdate(Trigger.newMap);
    }

    if(Trigger.isBefore && Trigger.isDelete) {
        OpportunityTriggerHelper.oppBeforeDelete(Trigger.oldMap);
    }

}