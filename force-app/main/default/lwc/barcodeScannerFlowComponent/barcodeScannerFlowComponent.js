//  Javascript controller for the Barcode Scanner Lightning component.
//
//  This code is provided AS IS, with no warranty or guarantee of suitability for use.
//  Contact: john.meyer@salesforce.com

import { LightningElement, api } from 'lwc';
import { FlowAttributeChangeEvent } from 'lightning/flowSupport';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getBarcodeScanner } from 'lightning/mobileCapabilities';

export default class BarcodeScannerFlowComponent extends LightningElement {
	scanner;
	scanButtonDisabled = false;

	@api scannedBarcode = '';
	@api buttonLabel = 'Scan Barcode';
	@api successMessage = 'Success!';

	connectedCallback() {
		this.scanner = getBarcodeScanner();
		this.scanButtonDisabled = this.scanner === null || !this.scanner.isAvailable();
	}

	handleBeginScanClick(event) {
		this.scannedBarcode = '';
		if (this.scanner != null && this.scanner.isAvailable()) {
			this.scanner
				.beginCapture({
					barcodeTypes: [
						this.scanner.barcodeTypes.CODE_128,
						this.scanner.barcodeTypes.CODE_39,
						this.scanner.barcodeTypes.CODE_93,
						this.scanner.barcodeTypes.DATA_MATRIX,
						this.scanner.barcodeTypes.EAN_13,
						this.scanner.barcodeTypes.EAN_8,
						this.scanner.barcodeTypes.ITF,
						this.scanner.barcodeTypes.PDF_417,
						this.scanner.barcodeTypes.QR,
						this.scanner.barcodeTypes.UPC_E
					]
				})
				.then((result) => {
					this.dispatchEvent(
						new ShowToastEvent({
							message: this.successMessage,
							variant: 'success'
						})
					);
					this.scannedBarcode = result.value;
					this.dispatchEvent(new FlowAttributeChangeEvent('scannedBarcode', result.value));
				})
				.catch((error) => {
					this.dispatchEvent(
						new ShowToastEvent({
							title: 'Barcode Scan Error',
							message: JSON.stringify(error),
							variant: 'error',
							mode: 'sticky'
						})
					);
				})
				.finally(() => {
					this.scanner.endCapture();
				});
		}
	}
}
