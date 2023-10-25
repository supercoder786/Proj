public with sharing class ChatController {

    @AuraEnabled(cacheable=true)
    public static List<Chat__c> getChatMessages(String otheruserName, String myuserName) {
        List<Chat__c> messages = new List<Chat__c>();
        // Query and populate messages based on userId
        messages = [SELECT Id, Message__c, Sender__c, Receiver__c FROM Chat__c WHERE (Sender__c = :otheruserName AND Receiver__c = :myuserName) OR (Sender__c = :myuserName AND Receiver__c = :otheruserName) ORDER BY CreatedDate];
        
        return messages;
    }
    
    @AuraEnabled
    public static Boolean saveChatMessage(String message, String senderName, String receiverName) {
        
        try {  
            // Person__c sender = [Select Id ,Name from Person__c Where Id=: senderId ] ;
            // Person__c receiver = [Select Id ,Name from Person__c Where Id=: receiverId ] ;
            Chat__c chatMessage = new Chat__c();
            chatMessage.Message__c = message;
            chatMessage.Sender__c = senderName;
            chatMessage.Receiver__c = receiverName;
            chatMessage.Name = 'Chat between ' + senderName + ' and ' + receiverName; // Modify as per your naming convention
    
            insert chatMessage;
            return true;
        } catch (Exception e) {
            throw new AuraHandledException('Error saving chat message: ' + e.getMessage());
        }
    }
    
    // public class ChatUser {
    //     @AuraEnabled public Id id;
    //     @AuraEnabled public String username;
    //     @AuraEnabled public String profilePic;
    // }
    
    // public class ChatMessage {
    //     @AuraEnabled public Id id;
    //     @AuraEnabled public String text;
    //     @AuraEnabled public Boolean isCurrentUser;
    // }
}