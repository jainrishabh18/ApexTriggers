public with sharing class ContactSelector {
    public static List<Contact> fetchContactRelatedToAccount(Set<Id> accountIds) {
        List<Contact> contacts = [Select Id, Phone, AccountId FROM Contact WHERE AccountId IN : accountIds]; //NOPMD
        System.debug('contacts : ' + contacts);
        return !contacts.isEmpty() ? contacts :NULL;
    }
}