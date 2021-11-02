global with sharing class WrapDoctor {

    public String error { get; set; }
    public List<Doctor__c> result { get; set; }

    public WrapDoctor(){
        error = '';
        result = new List<Doctor__c>();
    }
}