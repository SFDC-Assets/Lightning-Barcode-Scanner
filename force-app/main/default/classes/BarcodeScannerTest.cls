//  Test class and metbods for the Barcode Scanner Lightning component.
//
//  This code is provided AS IS, with no warranty or guarantee of suitability for use.
//  Contact: john.meyer@salesforce.com

@isTest
private without sharing class BarcodeScannerTest {

    @isTest
    private static void runTests () {

        System.Test.startTest();

        System.assertEquals(null, BarcodeScannerController.runFlow('Barcode_Scanner_Template', 'Text'));
        System.assertNotEquals(null, BarcodeScannerController.runFlow('Bad_Flow_Name', 'Text'));
        System.assertEquals(null, BarcodeScannerController.runApex('BarcodeScannerApexTemplate', 'Text'));
        System.assertNotEquals(null, BarcodeScannerController.runApex('BadApexClassName', 'Text'));
    
        System.Test.stopTest();
    }
}