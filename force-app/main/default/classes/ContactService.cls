public class ContactService {
    public static List<Contact> getContactsByEmail(Set<String> emailIds) {
        List<Contact> contacts = [SELECT Id, Email FROM contact WHERE Email IN: emailIds];  //NOPMD
        return !contacts.isEmpty() ? contacts : NULL;
    }
}