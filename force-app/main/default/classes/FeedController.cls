public with sharing class FeedController {
    //to fetch All Feeds 
    @AuraEnabled(cacheable=true)
    public static List<Feed__c> getFeeds() {
           
        return [SELECT Id, Name, Post_Content__c, Post_Image__c, CreatedDate,Likes__c FROM Feed__c ORDER BY CreatedDate DESC];
   
    }

    


    @AuraEnabled(cacheable=true)
    public static List<Feed__c> getIndividualFeeds(String username) {
        //here i used nested queries because we only had a username saved in our cookies
        //By using it we can get creator name and then from creator name we can get only the feeds posted by that creator 
        return [SELECT Id, Name, Post_Content__c,Post_Image__c FROM Feed__c WHERE Creator__c = :[SELECT Name FROM Person__c WHERE Username__c = :username]];
    }
    


    

    
        @AuraEnabled
        public static String createFeedRecord(String feedContent, String base64, String filename, String username) {
            try {
                String imageLink = '<p><img src="data:image/jpeg;base64,' + base64 + '" alt="rtaImage.jpeg"></img></p>';
    
                Person__c feedcreator = [SELECT Id,Name from Person__c WHERE Username__c =: username LIMIT 1  ]; 
                Feed__c newFeed = new Feed__c();
                newFeed.Name = feedcreator.Name;
                newFeed.Post_Content__c = feedContent;
                newFeed.Post_Image__c = imageLink;
                newFeed.Creator__c = feedcreator.Id;
                newFeed.Likes__c = 0;
                insert newFeed;
                return newFeed.Id;
            } catch (Exception ex) {
                throw new AuraHandledException('Error creating feed: ' + ex.getMessage());
            }
        }


       

        // @AuraEnabled
        // public static void updateLikes(String feedId, Boolean status) {
        //     System.debug('Updating likes for feedId: ' + feedId);
        //     try {
        //         // Your update logic here
        //         Feed__c feed = [SELECT Likes__c FROM Feed__c WHERE Id = :feedId LIMIT 1];

        //         if (feed != null) {

        //             if(status){
        //                 feed.Likes__c += 1;
        //             }else{
        //                 feed.Likes__c -=  1 ;
        //             }
                    
        //             update feed;
        //         }
        //             System.debug('Likes updated successfully.');
        //     } catch (Exception ex) {
        //         System.debug('Error updating likes: ' + ex.getMessage());
        //         throw new AuraHandledException('Error updating likes: ' + ex.getMessage());
        //     }
            
        // }

    @AuraEnabled
    public static Decimal addLike(String feedId) {
        try {
            Feed__c feed = [SELECT Likes__c FROM Feed__c WHERE Id = :feedId LIMIT 1];
            if (feed != null) {
                feed.Likes__c += 1; // Increment the number of likes
                update feed;
                return feed.Likes__c; // Return the updated number of likes
            }
            return 0; // Return 0 if the feed is not found
        } catch (Exception ex) {
            throw new AuraHandledException('Error adding like: ' + ex.getMessage());
        }
    }

    @AuraEnabled
    public static Decimal removeLike(String feedId) {
        try {
            Feed__c feed = [SELECT Likes__c FROM Feed__c WHERE Id = :feedId LIMIT 1];
            if (feed != null) {
                if (feed.Likes__c > 0) {
                    feed.Likes__c -= 1; // Decrement the number of likes if it's greater than 0
                    update feed;
                }
                return feed.Likes__c; // Return the updated number of likes as Decimal
            }
            return 0; // Return 0 as Decimal if the feed is not found
        } catch (Exception ex) {
            throw new AuraHandledException('Error removing like: ' + ex.getMessage());
        }
    }


    


        
}