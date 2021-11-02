public with sharing class GD_REST_API_Endpoints {

    public static String getDoctors(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://bri-dev-ed.my.salesforce.com/doctors');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        String strResponse = '';
        system.debug('Status code' + response.getStatusCode());
        system.debug('Body' + response.getBody());
        return strResponse;
    }

}