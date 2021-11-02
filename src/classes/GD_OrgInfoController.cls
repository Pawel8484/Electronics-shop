public with sharing class GD_OrgInfoController {

    public Boolean openModal {get; set; }

    public Integer getNumberOfApexClasses() {
        return [SELECT COUNT() FROM ApexClass];
    }

    public Integer getTotalLicenses() {
        List<AggregateResult> aggRes =[SELECT SUM(TotalLicenses)asSum FROM UserLicense];
        Object total = aggRes[0].get('asSum');
        return Integer.valueOf(total);
    }

    public Integer getUsersNumber() {
        List<AggregateResult> aggRes = [SELECT COUNT(Id)asUsersNo FROM User];
        Object usersNo = aggRes[0].get('asUsersNo');
        return Integer.valueOf(usersNo);
    }

    public Integer getActiveUsersNumber() {
        List<AggregateResult> aggRes = [SELECT COUNT(Id)asUsersNo FROM User WHERE isActive = true];
        Object activeUsersNo = aggRes[0].get('asUsersNo');
        return Integer.valueOf(activeUsersNo);
    }

    public List<User> getUsersList() {
        List<User> users = [SELECT Name, Username, TimeZoneSidKey, LastLoginDate FROM User];
        return users;
    }

    public String getSesId() {
        return UserInfo.getSessionId();
    }

    public void getSessionIdNumber() {
        openModal = true;
    }

    public PageReference close() {
        PageReference newpage = new PageReference(System.currentPageReference().getURL());
        newpage.setRedirect(true);
        return newpage;
    }
}