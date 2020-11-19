![Creative Commons License](https://img.shields.io/badge/license-Creative%20Commons-success) ![Released](https://img.shields.io/badge/status-Released-success) ![Code Coverage](https://img.shields.io/badge/code%20coverage-100%25-success)

<h1 align="center">LIGHTNING BARCODE SCANNER</h1>
<p align="center">
This package contains a Lightning component and other support to scan barcodes and optionally run Salesforce flows or Apex classes.
</p>

## Summary

As of Winter '21, Salesforce supports native barcode scanning on supported devices. This Lightning Web Component allows a user to scan a barcode and either open a scanned URL or take action on the scanned text.

**NOTE**: *Barcode scanning capability as of this writing is still in beta in Salesforce, with all of the caveats associated with that. All of my demo components are demo quality only, although I try to make them as good as possible (see the disclaimer below). As always, use at your own risk.*

## Installation and Setup

Read the disclaimer below and click on the **Install the Package** link. This will install all the components, flows, Apex classes, and other metadata to your org.

When installing, select the "Compile only the Apex in the package" option under the Advanced Options.

Assign the `Barcode Scanner` permission set to anyone who needs to use the component.

Once the package is deployed, you will need to create a Lightning app page with the Lightning App Builder and drag the `Barcode Scanner` custom component on the page where you would like to place it.

Users can configure almost all of the strings in the component, including the card title, button label, and instruction text.

The component supports several action types:

- **URL Scanning**: scans a URL that your device supports and opens it on your device.
- **Flow Execution**: scans arbitary text which can be passed to the `BarcodeText` input variable in an autolaunched flow that you specify.
- **Apex Execution**: scans arbitary text which can be passed to an Apex class that you specify. The Apex class must implement the `BarcodeScannerApexItem` interface.

### Salesforce Mobile Links

If you create a URL that begins with `salesforce1://`, you can view Salesforce records (as well as edit, follow, and download them) directly inside the Salesforce Mobile app. For a complete discussion of how to format URLs with this scheme, [check out the documentation](https://resources.docs.salesforce.com/sfdc/pdf/salesforce1_url_schemes.pdf).

## Creating and Embedding Barcodes

There are numerous free barcode generators around the web that you can use to generate barcode images for your demos. For example, you can embed a barcode for a record Id into a Salesforce VisualForce email template using merge fields like this:
```
<apex:image id="theImage" value="https://api.qrserver.com/v1/create-qr-code/?size=150x150&data={!Id}" width="150" height="150" />
```
Similarly, you can create formula fields inside your Salesforce records using syntax like:
```
IMAGE('https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=' & Id, Name, 150, 150)
```

## How to Deploy This Package to Your Org

I am a pre-sales Solutions Engineer for [Salesforce](https://www.salesforce.com) and I develop solutions for my customers to demonstrate the capabilities of the amazing Salesforce platform. _This package represents functionality that I have used for demonstration purposes and the content herein is definitely not ready for actual production use; specifically, it has not been tested extensively nor has it been written with security and access controls in mind. By installing this package, you assume all risk for any consequences and agree not to hold me or my company liable._ If you are OK with that ...

[Install the Package](https://login.salesforce.com/packaging/installPackage.apexp?p0=04t2E000003ocEcQAI)

## Acknowledgements

Thanks to Salesforce Platform specialist Troy Hedges for suggesting the flow and Apex connections.

## Maintainer

[John Meyer / johnsfdemo](https://github.com/johnsfdemo)
