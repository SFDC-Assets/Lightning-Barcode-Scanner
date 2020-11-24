//  Template class for executing arbitrary Apex cade as part of the Barcode Scanner Lightning component.
//
//  If you wish to use this template, make a copy of it as any changes to this file will be overwritten in a package update.
//  
//  This code is provided AS IS, with no warranty or guarantee of suitability for use.
//  Contact: john.meyer@salesforce.com


public without sharing class BarcodeScannerApexTemplate implements BarcodeScannerApexItem {

    // Executes Apex code with the text of the scanned barcode as input.
    //
    // The parameters represent:
    //    barCodeText: the text of the scanned barcode.
    //    recordId: the Id of the record, if the component is in a Lightning record page; null otherwise.

    public static void execute (String barcodeText, Id recordId) {
        
        //  Change anything you want in here.  Just be careful of Salesforce governor limits.

        insert new FeedItem (
            ParentId = UserInfo.getUserId(),
            Body = 'BarcodeScannerApexTemplate: record Id "' + String.valueOf(recordId) + '" received barcode text: ' + barcodeText
        );
    }
}