//  Controller for the Barcode Scanner Lightning component.
//  
//  This code is provided AS IS, with no warranty or guarantee of suitability for use.
//  Contact: john.meyer@salesforce.com


public with sharing class BarcodeScannerController {

    //  Runs a flow with the text from the scanned barcode passed in.
    //
    //  The parameters represent:
    //      flowApiName: the API name of the flow to execute
    //      recordId: the Id of the record, if the component is in a Lightning record page; null otherwise.
    //      barcodeText: the text scanned in from the barcode

    @AuraEnabled
    public static String runFlow (String flowApiName, Id recordId, String barcodeText) {
        try {
            Flow.Interview.createInterview(flowApiName, new Map<String,Object> { 'BarcodeText' => barcodeText, 'recordId' => recordId }).start();
            return null;
        } catch (Exception e) {
            return e.getMessage();
        }
    }


    //  Runs an Apex class with the text from the scanned barcode passed in.
    //
    //  The parameters represent:
    //      apexClassName: the name of the Apex class to execute. It must implement the BarcodeScannerApexItem interface.
    //      recordId: the Id of the record, if the component is in a Lightning record page; null otherwise.
    //      barcodeText: the text scanned in from the barcode.
    
    @AuraEnabled
    public static String runApex (String apexClassName, Id recordId, String barcodeText) {
        try {
            ((BarcodeScannerApexItem) Type.forName(apexClassName).newInstance()).execute(barcodeText, recordId);
            return null;
        } catch (Exception e) {
            return e.getMessage();
        }
    }
}
