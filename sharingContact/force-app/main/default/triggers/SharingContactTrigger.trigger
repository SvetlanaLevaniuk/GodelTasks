trigger SharingContactTrigger on Contact (after insert) {
    if (trigger.isInsert) {
        SharingContactTriggerHelper.addAccessForSharingContacts(trigger.new);
    }
}