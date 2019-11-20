trigger ContactTrigger on Contact (before insert, before update, after insert) {
    if (trigger.isBefore) {
        LinkAccountToContactHendler.linkAccountToContact(trigger.new);
    }
    if (trigger.isAfter) {
        SharingContactTriggerHelper.addAccessForSharingContacts(trigger.new);
    }
}