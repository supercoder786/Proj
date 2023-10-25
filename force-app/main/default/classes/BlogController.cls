public with sharing class BlogController {
    @AuraEnabled(cacheable=true)
    public static List<Blog__c> getBlogs(){
        try {
            return [SELECT Id, Name, Content__c, Timestamp__c, Likes__c, Author__c, Blog_Image__c FROM Blog__c ORDER BY CreatedDate DESC];
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    // @AuraEnabled(cacheable=true)
    // public static Blog__c getSingleblog(String blogId){
    //     try {
    //         return [SELECT Id, Name, Content__c, Timestamp__c, Likes__c, Author__c,Blog_Image__c FROM Blog__c WHERE Id =: blogId LIMIT 1 ];
            
    //     } catch (Exception e) {
    //         throw new AuraHandledException(e.getMessage());
    //     }
    // }


    @AuraEnabled(cacheable=true)
    public static void createBlog(String name, String author, String content) {
        Blog__c blog = new Blog__c();
        blog.Name = name;

        blog.Content__c = content;
        insert blog;
    }
    @AuraEnabled(cacheable=true)
    public static List<Blog__c>  getIndividualBlogs(String username) {
        return [SELECT Id, Name,Content__c, Blog_Image__c FROM Blog__c WHERE Author__c = :[SELECT Name FROM Person__c WHERE Username__c = :username]];
    }
    @AuraEnabled

    public static String createBlogRecord(String blogName,String blogContent, String base64, String filename, String loggedInUser) {

        try {

            String imageLink = '<p><img src="data:image/jpeg;base64,' + base64 + '" alt="rtaImage.jpeg"></img></p>';

 

            Person__c authorRecord = [SELECT Id,Name FROM Person__c WHERE Username__c = :loggedInUser LIMIT 1];

 

            Blog__c newBlog = new Blog__c();

            newBlog.Name = blogName;

            newBlog.Content__c = blogContent;

            newBlog.Blog_Image__c = imageLink;

            newBlog.Author__c = authorRecord.Id;

            insert newBlog;

            return newBlog.Id;

        } catch (Exception ex) {

            throw new AuraHandledException('Error creating Blog: ' + ex.getMessage());

        }

    }


    @AuraEnabled(cacheable=true)
    public static Blog__c getSingleblog(String blogId){
        try {
            return [SELECT Id,Name, Content__c,Author__c,Blog_Image__c FROM Blog__c WHERE Id =: blogId LIMIT 1 ];

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

     @AuraEnabled(cacheable=true)
    public static Person__c getName(String recId){
         try {
            return [SELECT Id, Name FROM Person__c WHERE Id =: recId LIMIT 1 ];

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

    }
}