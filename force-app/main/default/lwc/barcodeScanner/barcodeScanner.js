//  Javascript controller for the Barcode Scanner Lightning component.
//
//  This code is provided AS IS, with no warranty or guarantee of suitability for use.
//  Contact: john.meyer@salesforce.com

import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getBarcodeScanner } from 'lightning/mobileCapabilities';
import runFlow from '@salesforce/apex/BarcodeScannerController.runFlow';
import runApex from '@salesforce/apex/BarcodeScannerController.runApex';

export default class BarcodeScanner extends NavigationMixin(LightningElement) {
	scanner;
	scannedBarcode = '';
	scanButtonDisabled = false;
	scanComplete = false;

	get showComponent() {
		return this.scanner.isAvailable && !this.hideComponentIfNoScanner;
	}
	get showDebugWindow() {
		return this.debug && this.scanComplete;
	}
	get instructionTextStyle() {
		return `color:${this.instructionsColor};`;
	}
	get missingFlowName() {
		return this.actionType === 'Run a Flow' && (this.flowApiName === null || this.flowApiName === '');
	}
	get missingApexClass() {
		return this.actionType === 'Run Apex' && (this.apexClassName === null || this.apexClassName === '');
	}

	@api hideComponentIfNoScanner = false;
	@api cardTitle = 'Barcode Scanner';
	@api buttonLabel = 'Scan Barcode';
	@api instructions = 'Press the button below to open the camera. Position a barcode in the scanner window to scan it.';
	@api instructionsColor = '#888888';
	@api debug = false;
	@api actionType = 'Scan a URL';
	@api flowApiName = null;
	@api apexClassName = null;
	@api successMessage = 'Success!';

	connectedCallback() {
		this.scanner = getBarcodeScanner();
		this.scanButtonDisabled =
			this.scanner === null || !this.scanner.isAvailable() || this.missingFlowName || this.missingApexClass;
	}

	renderedCallback() {
		if (this.missingFlowName)
			this.dispatchEvent(
				new ShowToastEvent({
					message: 'You must specify a flow name if the action type is "Run a Flow".',
					variant: 'error',
					mode: 'sticky'
				})
			);
		else if (this.missingApexClass)
			this.dispatchEvent(
				new ShowToastEvent({
					message: 'You must specify an Apex class name if the action type is "Run Apex".',
					variant: 'error',
					mode: 'sticky'
				})
			);
	}

	handleBeginScanClick(event) {
		this.scannedBarcode = '';
		this.scanComplete = false;
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
					this.scannedBarcode = result.value;
					this.handleBarCode();
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
					this.scanComplete = true;
				});
		}
	}

	handleBarCode() {
		switch (this.actionType) {
			case 'Scan a URL':
				this[NavigationMixin.Navigate]({
					type: 'standard__webPage',
					attributes: {
						url: decodeURIComponent(this.scannedBarcode)
					}
				});
				break;
			case 'Run a Flow':
				runFlow({
					flowApiName: this.flowApiName,
					barcodeText: this.scannedBarcode
				}).then((result) => {
					if (result === null) {
						this.dispatchEvent(
							new ShowToastEvent({
								message: this.successMessage,
								variant: 'success',
								mode: 'sticky'
							})
						);
					} else {
						this.dispatchEvent(
							new ShowToastEvent({
								title: `There was a problem running flow "${this.flowApiName}"`,
								message: result,
								variant: 'error',
								mode: 'sticky'
							})
						);
					}
				});
				break;
			case 'Run Apex':
				runApex({
					apexClassName: this.apexClassName,
					barcodeText: this.scannedBarcode
				}).then((result) => {
					if (result === null) {
						this.dispatchEvent(
							new ShowToastEvent({
								message: this.successMessage,
								variant: 'success',
								mode: 'sticky'
							})
						);
					} else {
						this.dispatchEvent(
							new ShowToastEvent({
								title: `There was a problem running Apex class "${this.apexClassName}"`,
								message: result,
								variant: 'error',
								mode: 'sticky'
							})
						);
					}
				});
				break;
		}
	}
}
