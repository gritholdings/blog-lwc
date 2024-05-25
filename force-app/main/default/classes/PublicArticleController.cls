public without sharing class PublicArticleController {
    @AuraEnabled(cacheable=true)
    public static List<Article__c> selectTop() {
        Datetime now = Helper.now;
        List<Article__c> articles = [SELECT Id, Title__c
            FROM Article__c
            WHERE Published_Timestamp__c < :now AND Indexes__c INCLUDES ('Top')
            ORDER BY Published_Timestamp__c DESC LIMIT 20];
        return articles;
    }

    @AuraEnabled(cacheable=true)
    public static List<Article__c> selectMoreInTopicNameByArticle(String articleId) {
        Article__c selectedArticle = [SELECT Topic__r.Id, Published_Timestamp__c
            FROM Article__c WHERE Id = :articleId];
        Id selectedArticleTopicId = selectedArticle.Topic__r.Id;
        Datetime selectedArticlePublishedTimestamp = selectedArticle.Published_Timestamp__c;
        List<Article__c> articles = [SELECT Id, Title__c, Banner_Image__c, Published_Timestamp__c
            FROM Article__c
            WHERE Topic__c = :selectedArticleTopicId
                AND Published_Timestamp__c < :selectedArticlePublishedTimestamp
            ORDER BY Published_Timestamp__c DESC LIMIT 8];
        return articles;
    }
}