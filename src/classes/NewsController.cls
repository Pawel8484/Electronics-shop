public with sharing class NewsController {

    @AuraEnabled
    public static NewsService.NewsPageResponse getNews(String searchParams) {
        try {
            NewsService.NewsPageRequest newsPageRequest = (NewsService.NewsPageRequest) JSON.deserialize(searchParams, NewsService.NewsPageRequest.class);
            return NewsService.getNews(newsPageRequest);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static NewsService.NewsPageResponse getHotNews(String searchParams) {
        try {
            NewsService.NewsPageRequest newsPageRequest = (NewsService.NewsPageRequest) JSON.deserialize(searchParams, NewsService.NewsPageRequest.class);
            return NewsService.getHotNews(newsPageRequest);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void saveSelectedArticle(String selectedArticle) {
        NewsService.Article downloadArticle = (NewsService.Article) JSON.deserialize(selectedArticle, NewsService.Article.class);
        NewsService.saveSelectedArticle(downloadArticle);
    }

    @AuraEnabled
    public static Boolean isArticleSaved(String articleUrl) {
            return NewsService.isArticleSaved(articleUrl);
    }

    @AuraEnabled
    public static void deleteSelectedArticle(String selectedArticleId) {
        NewsService.deleteSelectedArticle(selectedArticleId);
    }

    @AuraEnabled
    public static void sendNotification(String articleId, String userId) {
        NewsService.sendNotification(articleId, userId);
    }

    @AuraEnabled
    public static NewsService.Article findSavedArticle(String articleId) {
        return NewsService.findSavedArticle(articleId);
    }

    @AuraEnabled
    public static Boolean isArticleInDatabase(String selectedArticle) {
        NewsService.Article downloadArticle = (NewsService.Article) JSON.deserialize(selectedArticle, NewsService.Article.class);
        return NewsService.isArticleInDatabase(downloadArticle);
    }

    @AuraEnabled
    public static void saveShareArticle(String selectedArticle) {
        NewsService.Article downloadArticle = (NewsService.Article) JSON.deserialize(selectedArticle, NewsService.Article.class);
        NewsService.saveShareArticle(downloadArticle);
    }

    @AuraEnabled
    public static List<User> getSubscribers(String articleId){
        System.debug('To Tu' + articleId);
        return NewsService.getSubscribers(articleId);
    }
}