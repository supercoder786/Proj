public with sharing class news_api {
    
    private static final String NEWS_API = 'https://newsapi.org/v2/top-headlines';
    private static final String API_KEY = 'a31db59c55a04ec598074c7c0eefe912';

    @AuraEnabled(cacheable=true)
    public static List<NewsItem> getNews(String category) {
        String apiUrl = NEWS_API + '?country=us&category=' + category + '&apiKey=' + API_KEY;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(apiUrl);
        request.setMethod('GET');

        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            NewsApiResponse apiResponse = (NewsApiResponse) JSON.deserialize(response.getBody(), NewsApiResponse.class);
            return apiResponse.articles;
        }
        return new List<NewsItem>();
    }

    @AuraEnabled(cacheable=true)
    public static List<NewsItem> getallNews() {
        String apiUrl = NEWS_API + '?country=us&apiKey=' + API_KEY;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(apiUrl);
        request.setMethod('GET');

        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            NewsApiResponse apiResponse = (NewsApiResponse) JSON.deserialize(response.getBody(), NewsApiResponse.class);
            return apiResponse.articles;
        }
        return new List<NewsItem>();
    }

    // Inner class to map the News API response
    public class NewsApiResponse {
        public List<NewsItem> articles;
    }

    // Inner class to represent a single news item
    public class NewsItem {
        @AuraEnabled
        public String title;
        @AuraEnabled
        public String description;
        @AuraEnabled
        public String url;
        // @AuraEnabled
        // public String urlToImage;
        // Add more fields as needed
    }
}