public with sharing class AccountSearchResults {

    @AuraEnabled
    public static List<Account> getAccounts(String accountCountry, String accountName){
        System.debug('accountCountry' + accountCountry + ' accountName: ' + accountName);
        String sName = String.escapeSingleQuotes('%' + accountName + '%');
        System.debug('getAccounts:' + sName);
            return [SELECT id, Name, BillingStreet, BillingCity, BillingCountry FROM Account WHERE Name LIKE :sName AND BillingCountry = :accountCountry];

    }

    public static String generateID(){
        List<String> characters = new List<String>{'a','b','c','d','e','f','g','h', 'i','j','k','l','m','n','o','p','q','r','s','t','u','v','w', 'x','y','z','1','2','3','4','5','6','7','8','9','0' };
        String randomText = '';
        for(Integer i=0;i<18;i++){
            String randomChars = characters[Math.Round(Math.Random() * characters.size())];
            randomText += randomChars;
        }
        System.debug(randomText);
    return randomText;
    }
}