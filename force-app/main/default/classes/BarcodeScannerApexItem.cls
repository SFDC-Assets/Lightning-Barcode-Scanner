//  Interface describing the Apex cleanup task for the Barcode Scanner Lightning component.
//  
//  This code is provided AS IS, with no warranty or guarantee of suitability for use.
//  Contact: john.meyer@salesforce.com

//  Refer to the BarcodeScannerCustomApex class for more information and a template for creating your own
//  custom Apex classes that work with the DemoCleanup framework.

public interface BarcodeScannerApexItem {

    // Executes Apex code with the text of the scanned barcode as input.
    //
    // The parameters represent:
    //    barCodeText: the text of the scanned barcode.
    //    recordId: set to the Id of the record, if the component is in a Lightning record page; null otherwise.

    void execute (String barCodeText, Id recordId);
}
