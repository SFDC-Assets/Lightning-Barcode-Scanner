//  Controller for the Barcode Scanner Lightning component.
//  
//  This code is provided AS IS, with no warranty or guarantee of suitability for use.
//  Contact: john.meyer@salesforce.com


public with sharing class BarcodeScannerController {

    //  Runs a flow with the text from the scanned barcode passed in.
    //
    //  The parameters represent:
    //      flowApiName: the API name of the flow to execute
    //      barcodeText: the text scanned in from the barcode

    @AuraEnabled
    public static String runFlow (String flowApiName, String barcodeText) {
        try {
            Flow.Interview.createInterview(flowApiName, new Map<String,Object> { 'BarcodeText' => barcodeText }).start();
            return null;
        } catch (Exception e) {
            return e.getMessage();
        }
    }


    //  Runs an Apex class with the text from the scanned barcode passed in.
    //
    //  The parameters represent:
    //      apexClassName: the name of the Apex class to execute. It must implement the BarcodeScannerApexItem interface.
    //      barcodeText: the text scanned in from the barcode
    
    @AuraEnabled
    public static String runApex (String apexClassName, String barcodeText) {
        try {
            ((BarcodeScannerApexItem) Type.forName(apexClassName).newInstance()).execute(barcodeText);
            return null;
        } catch (Exception e) {
            return e.getMessage();
        }
    }
}
