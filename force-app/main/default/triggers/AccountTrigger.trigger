trigger AccountTrigger on Account (before insert, after insert) {

    if(Trigger.isBefore && Trigger.isInsert) {
        AccountTriggerHelper.accountBeforeInsert(Trigger.new);
    }

    if(Trigger.isAfter && Trigger.isInsert) {
        AccountTriggerHelper.accountAfterInsert(Trigger.newMap);
    }
}