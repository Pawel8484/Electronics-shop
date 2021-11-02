public with sharing class NewsService {

    public static NewsPageResponse getNews(NewsPageRequest newsPageRequest) {
        if (newsPageRequest.dataSource == 'api') {
            return getExternalNews(newsPageRequest);
        }

        return getSalesforceNews(newsPageRequest);
    }

    private static NewsPageResponse getExternalNews(NewsPageRequest newsPageRequest) {
        String term = String.escapeSingleQuotes('%' + newsPageRequest.term + '%').replaceAll(' ', '%20');
        String category = categoryVerification(newsPageRequest.category);
        String startDate = newsPageRequest.startDate;
        String endDate = newsPageRequest.endDate;
//        2838b617ac40491ebd73a29887b07728
        NewsApp__c setting = NewsApp__c.getInstance();
        String apiKey = setting.apiKey__c;
        HttpRequest httpRequest = new HttpRequest();
        httpRequest.setEndpoint('https://newsapi.org/v2/everything?q=' + term + '%20AND%20' + category + '&from=' + startDate +
                '&to=' + endDate + '&language=en&domains=reuters.com,amp.theguardian.com,businessinsider.com,calgaryherald.com,eu.usatoday.com,espn.com,washingtonpost.com,cbssports.com,' +
                'thefilmstage.com,ksl.com,insider.com,edition.cnn.com,thehill.com,foxbusiness.com&sortBy=publishedAt&apiKey=' + apiKey);
        httpRequest.setMethod('GET');

        String strResponse = null;

        try {
            Http http = new Http();
            HttpResponse httpResponse = http.send(httpRequest);
            if (httpResponse.getStatusCode() == 200) {
                strResponse = httpResponse.getBody();
                System.debug('RESPONSE' + httpResponse.getBody());
            } else {
                throw new CalloutException(httpResponse.getBody());
            }

        } catch (Exception ex) {
            throw ex;
        }
        NewsPageResponse pageResponse = new NewsPageResponse();
        pageResponse = (NewsPageResponse) JSON.deserialize(strResponse, NewsPageResponse.class);
        for (Article article : pageResponse.articles) {
            article.iconUrl = getIconUrl(article.url);
            article.description = article.description.replaceAll('(<([^>]+)>)','');
            article.content = article.content.replaceAll('\\[.*\\]','');
            article.content = article.content.replaceAll('(<([^>]+)>)','');
        }
//            return (NewsPageResponse) JSON.deserialize(strResponse, NewsPageResponse.class);
        return pageResponse;
    }

    private static String categoryVerification(String category){
        if(category == 'all' || category == 'Select category...'){
            return '%a%';
        }
        return '%' + category +'%';
    }

    private static NewsPageResponse getSalesforceNews(NewsPageRequest newsPageRequest) {
//        List<Article__c> articles = [SELECT Title__c, Author__c, PublishedAt__c, Description__c, UrlToImage__c, Content__c, Url__c, IconUrl__c FROM Article__c];
        List<Article__c> articles = [SELECT Title__c, Author__c, PublishedAt__c, Description__c, UrlToImage__c, Content__c, Url__c, IconUrl__c FROM Article__c WHERE Id IN (SELECT Article__c FROM ArticleUser__c WHERE User__c = :Userinfo.getUserId())];

        NewsPageResponse pageResponse = new NewsPageResponse();
        pageResponse.totalResults = articles.size();
        pageResponse.articles = new List<Article>();

        for (Article__c article : articles) {
            pageResponse.articles.add(new Article(article));
        }

        return pageResponse;
    }

    public static NewsPageResponse getHotNews(NewsPageRequest newsPageRequest) {
        String category = newsPageRequest.category;
        NewsApp__c setting = NewsApp__c.getInstance();
        String apiKey = setting.apiKey__c;
        HttpRequest httpRequest = new HttpRequest();
        httpRequest.setEndpoint('https://newsapi.org/v2/top-headlines?country=us' + '&category=' + category + '&apiKey='+ apiKey);
        httpRequest.setMethod('GET');
        System.debug(httpRequest);

        String strResponse = null;

        try {
            Http http = new Http();
            HttpResponse httpResponse = http.send(httpRequest);
            if (httpResponse.getStatusCode() == 200) {
                strResponse = httpResponse.getBody();
                System.debug('RESPONSE' + strResponse);
            } else {
                throw new CalloutException(httpResponse.getBody());
            }

        } catch (Exception ex) {
            throw ex;
        }
        NewsPageResponse pageResponse = new NewsPageResponse();
        pageResponse = (NewsPageResponse) JSON.deserialize(strResponse, NewsPageResponse.class);
        for (Article article : pageResponse.articles) {
            article.iconUrl = getIconUrl(article.url);
        }
        return pageResponse;

    }

    private static String getIconUrl(String url) {
        String urlIcon = url;
        if (urlIcon.contains('https://')) {
            urlIcon = urlIcon.replaceFirst('^(https?://)', '').split('/')[0];
            urlIcon = 'https://' + urlIcon + '/favicon.ico';
        } else if (urlIcon.contains('http://www')) {
            urlIcon = urlIcon.replaceFirst('^(http?://)', 'http://').split('/')[0];
            urlIcon = 'http://' + urlIcon + '/favicon.ico';
        }
        return urlIcon;
    }

//    public static Boolean isArticleSaved(String articleUrl) {
//        return [SELECT COUNT() FROM Article__c WHERE Url__c = :articleUrl] > 0;
    public static Boolean isArticleSaved(String articleUrl) {
        String articleId = [SELECT Id FROM Article__c WHERE Url__c = :articleUrl LIMIT 1].Id;
        System.debug('Article ID: ' + articleId);
        return [SELECT COUNT() FROM ArticleUser__c WHERE Article__c = :articleId AND User__c = :userInfo.getUserId()] > 0;
    }

    public static void saveSelectedArticle(Article downloadArticle) {
        System.debug([SELECT COUNT() FROM Article__c WHERE Url__c = :downloadArticle.url]);
        if([SELECT COUNT() FROM Article__c WHERE Url__c = :downloadArticle.url] > 0){
            ArticleUser__c articleUser = new ArticleUser__c();
//            articleUser.Article__c = downloadArticle.id;
            articleUser.Article__c = [SELECT Id FROM Article__c WHERE Url__c = :downloadArticle.url LIMIT 1].Id;
            articleUser.User__c = userInfo.getUserId();
            insert articleUser;
        } else {
            Article__c article = new Article__c();
            article.Title__c = downloadArticle.title;
            article.Author__c = downloadArticle.author;
            article.PublishedAt__c = Datetime.valueOf(downloadArticle.publishedAt.replace('T', ' '));
            article.Description__c = downloadArticle.description;
            article.UrlToImage__c = downloadArticle.urlToImage;
            article.Content__c = downloadArticle.content;
            article.Url__c = downloadArticle.url;
            article.IconUrl__c = getIconUrl(downloadArticle.url);
            insert article;
            ArticleUser__c articleUser = new ArticleUser__c();
            articleUser.Article__c = article.Id;
            articleUser.User__c = userInfo.getUserId();
            insert articleUser;
        }
    }

    public static void deleteSelectedArticle(String selectedArticleId){
        ArticleUser__c articleUser = [SELECT User__c, Article__c FROM ArticleUser__c WHERE User__c = :userInfo.getUserId() AND Article__c = :selectedArticleId];
//        Article__c article = [SELECT Id, Url__c FROM Article__c WHERE Id = :selectedArticleId];
//        delete article;
        delete articleUser;
    }

    public static Article findSavedArticle(String articleId){
        Article__c salesforceArticle = [SELECT Id, Title__c, Author__c, PublishedAt__c, Description__c, UrlToImage__c, Content__c, Url__c, IconUrl__c FROM Article__c WHERE Id = :articleId];
        return new Article(salesforceArticle);
    }

    public static Boolean isArticleInDatabase(Article downloadArticle){
        return [SELECT COUNT() FROM ArticleUser__c WHERE Article__c IN (SELECT Id FROM Article__c WHERE Url__c = :downloadArticle.url) AND User__c = :userInfo.getUserId()] > 0;
    }

    public static void sendNotification(String articleId, String userId){
        String pageRefString = '{"type":"standard__component","attributes":{"componentName":"c__articleDetails"},"state":{"c__articleId":"' + articleId + '"}}';
        Messaging.CustomNotification notification = new Messaging.CustomNotification();
        notification.setBody('Click here for more information');
        notification.setTitle('I found good article');
        notification.setSenderId(Userinfo.getUserId());
        CustomNotificationType type = [SELECT Id FROM CustomNotificationType WHERE DeveloperName = 'MyCustomNotification'];
        notification.setNotificationTypeId(type.id);
//        notification.setTargetId(articleId);
        notification.setTargetPageRef(pageRefString);

        notification.send(new Set<String> { userId });
    }

    public static void saveShareArticle(Article downloadArticle) {
            Article__c article = new Article__c();
            article.Title__c = downloadArticle.title;
            article.Author__c = downloadArticle.author;
        System.debug('Jestem tu');
            article.PublishedAt__c = Datetime.valueOf(downloadArticle.publishedAt.replace('T', ' '));
            article.Description__c = downloadArticle.description;
            article.UrlToImage__c = downloadArticle.urlToImage;
            article.Content__c = downloadArticle.content;
            article.Url__c = downloadArticle.url;
            article.IconUrl__c = getIconUrl(downloadArticle.url);
            insert article;
            ArticleUser__c articleUser = new ArticleUser__c();
            articleUser.Article__c = article.Id;
            articleUser.User__c = userInfo.getUserId();
            insert articleUser;
            String pageRefString = '{"type":"standard__component","attributes":{"componentName":"c__articleDetails"},"state":{"c__articleId":"' + article.id + '"}}';
            Messaging.CustomNotification notification = new Messaging.CustomNotification();
            notification.setBody('Click here for more information');
            notification.setTitle('I found good article');
            notification.setSenderId(Userinfo.getUserId());
            CustomNotificationType type = [SELECT Id FROM CustomNotificationType WHERE DeveloperName = 'MyCustomNotification'];
            notification.setNotificationTypeId(type.id);
            notification.setTargetPageRef(pageRefString);

            notification.send(new Set<String> { '00509000009xxgwAAA' });

    }

    public static List<User> getSubscribers(String articleId){
                List<User> userss = [SELECT Id, Username FROM User WHERE Id IN (SELECT User__c FROM ArticleUser__c WHERE Article__c = :articleId)];
        System.debug('userss ' + userss);
        return userss;
    }

    public class NewsPageRequest {
        public String term;
        public String category;
        public String startDate;
        public String endDate;
        public String dataSource;
    }

    public class NewsPageResponse {
        @AuraEnabled
        public Integer totalResults;
        @AuraEnabled
        public List<Article> articles;
    }

    public class Article {
        @AuraEnabled
        public String id;
        @AuraEnabled
        public String title;
        @AuraEnabled
        public String author;
        @AuraEnabled
        public String description;
        @AuraEnabled
        public String publishedAt;
        @AuraEnabled
        public String urlToImage;
        @AuraEnabled
        public String content;
        @AuraEnabled
        public String url;
        @AuraEnabled
        public String iconUrl;

        public Article(Article__c article) {
            this.id = article.Id;
            this.title = article.Title__c;
            this.author = article.Author__c;
            this.publishedAt = String.valueOf(article.PublishedAt__c);
            this.description = article.Description__c;
            this.urlToImage = article.UrlToImage__c;
            this.content = article.Content__c;
            this.url = article.Url__c;
            this.iconUrl = article.IconUrl__c;
        }
    }
}