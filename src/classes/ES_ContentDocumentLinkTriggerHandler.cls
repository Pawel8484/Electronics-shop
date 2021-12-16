public with sharing class ES_ContentDocumentLinkTriggerHandler extends TriggerHandler {
    private static final String PRODUCT_PREFIX = Product2.SObjectType.getDescribe().getKeyPrefix();

    protected override void beforeInsert() {
        shareFilesWithExternalUsers((List<ContentDocumentLink>) Trigger.new);
    }

    public void shareFilesWithExternalUsers(ContentDocumentLink[] contentDocumentLinks) {
        for (ContentDocumentLink cdl : contentDocumentLinks) {
            if ((String.valueOf(cdl.LinkedEntityId)).startsWith(PRODUCT_PREFIX)) {
                cdl.ShareType = 'I';
                cdl.Visibility = 'AllUsers';
            }
        }
    }
}