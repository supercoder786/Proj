public with sharing class ChatController {
   
    
    
   @AuraEnabled(cacheable=true)
    public static List<Person__c> getUsers() {
        return [SELECT Id, Name, Username__c FROM Person__c];
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Chat__c> getChatMessages(String otheruserName, String myuserName) {
        List<Chat__c> messages = new List<Chat__c>();
        // Query and populate messages based on userId
        messages = [SELECT Id, Message__c, Sender__c, Receiver__c FROM Chat__c WHERE (Sender__c = :otheruserName AND Receiver__c = :myuserName) OR (Sender__c = :myuserName AND Receiver__c = :otheruserName) ORDER BY CreatedDate];
        
        return messages;
    }
    
    @AuraEnabled
    public static Boolean saveChatMessage(String message, String senderId, String receiverId) {
        
        try {  
            // Person__c sender = [Select Id ,Name from Person__c Where Id=: senderId ] ;
            // Person__c receiver = [Select Id ,Name from Person__c Where Id=: receiverId ] ;
            Chat__c chatMessage = new Chat__c();
            chatMessage.Message__c = message;
            chatMessage.Sender__c = senderId;
            chatMessage.Receiver__c = receiverId;
            chatMessage.Name = 'Chat between ' + senderId + ' and ' + receiverId; // Modify as per your naming convention
    
            insert chatMessage;
             Chat_Message__e event = new Chat_Message__e(
                Sender__c = senderId,
                Receiver__c = receiverId,
                Message__c = message
            );
            EventBus.publish(event);
            return true;
        } catch (Exception e) {
            throw new AuraHandledException('Error saving chat message: ' + e.getMessage());
        }
    }
}