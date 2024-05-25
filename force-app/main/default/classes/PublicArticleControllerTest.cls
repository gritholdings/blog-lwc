@isTest
public with sharing class PublicArticleControllerTest {
    @isTest
    static void selectMoreInTopicNameByArticleTest() {
        // Article0, Published_Timestamp__c = TODAY
        // Article1, Published_Timestamp__c = TODAY+1
        // Article2, Published_Timestamp__c = TODAY-1
        // Article3, Published_Timestamp__c = TODAY-2
        Integer totalInstances = 4;
        Topic__c topic = new Topic__c(Name = 'Test Topic');
        insert topic;
        Helper.now = DateTime.newInstance(2100, 5, 1, 23, 59, 59);
        List<Article__c> articles = new List<Article__c>();
        for (Integer i=0; i<totalInstances; i++) {
            articles.add(new Article__c(Name = 'Article ' + i, Topic__c = topic.Id));
        }
        articles[0].Published_Timestamp__c = Helper.now;
        articles[1].Published_Timestamp__c = Helper.now.addDays(1);
        articles[2].Published_Timestamp__c = Helper.now.addDays(-1);
        articles[3].Published_Timestamp__c = Helper.now.addDays(-2);
        insert articles;
        List<Article__c> results = PublicArticleController.selectMoreInTopicNameByArticle(articles[0].Id);
        Assert.areEqual(2, results.size(), 'Expected 2 past articles to be returned');
        Assert.areNotEqual(articles[0].Id, results[0].Id, 'The provided article should not be in the result');
        for(Article__c article : results) {
            Assert.areEqual(topic.Name, article.Topic__r.Name, 'All articles should belong to the same topic');
            Assert.isTrue(articles[0].Published_Timestamp__c > article.Published_Timestamp__c,
                'All returned articles should have a timestamp before the provided article');
        }
    }
}