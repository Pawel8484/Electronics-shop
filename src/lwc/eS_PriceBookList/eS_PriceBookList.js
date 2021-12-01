import { LightningElement, api, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import EMPTY_IMAGE from '@salesforce/resourceUrl/emptyImage';
import getPriceBookWrappers from '@salesforce/apex/ES_PriceManagerController.getPriceBookWrappers';
import getProductWrappers from '@salesforce/apex/ES_PriceManagerController.getProductWrappers';
import savePriceBookWithProducts from '@salesforce/apex/ES_PriceManagerController.savePriceBookWithProducts';
import checkIfNewPricebookOverlapWithOther from '@salesforce/apex/ES_PriceManagerController.checkIfNewPricebookOverlapWithOther';
import {refreshApex} from '@salesforce/apex';

const columns = [
    { label: 'Name', fieldName: 'name' },
    { label: 'Family', fieldName: 'productFamily' },
    { label: 'Standard Price', fieldName: 'standardPrice'},
    { label: 'New Price', fieldName: 'customPrice'},
];

export default class ES_PriceBookList extends LightningElement {

	@wire(getPriceBookWrappers, {searchName: '$searchName', searchStartDate: '$searchStartDate', searchEndDate: '$searchEndDate'}) pricebooks;


	appResources = {
		emptyImage: EMPTY_IMAGE,
	};

    @track records;

    searchName = '';
    searchStartDate = '1900-01-01T00:00:00.000Z';
    searchEndDate = '2100-01-01T00:00:00.000Z';

    pricebooks;

    pricebook = {};
    pricebookId = '';
    @api pricebookName;
    startDate;
    endDate;
    uploadedFile;
    isActiveBox;
    priceValue;
    selectedUnit = 'percent';
//    today = new Date().toISOString().split('T')[0];

    get today() {
        const today = new Date();
        const newDate = this.isEmpty(this.pricebook.validFrom) ? today : new Date(this.pricebook.validFrom);

        if(today > newDate){
            return this.pricebook.validFrom;
     }
        return today.toISOString().split('T')[0];
    };

    columns = columns;
    isModalOpen = false;

    @wire(getProductWrappers, {pricebookId: '$pricebookId'})
    wiredProductWrappers({ error, data }) {
        if (data) {
            this.records = data;
        } else if (error) {
            this.showError(error.body.message);
            this.records = [];
        }
    };

    addNewPriceBook(){
        this.pricebookId = null;
        this.pricebookName = '';
        this.startDate = '';
        this.endDate = '';
        this.uploadedFile = '';
        this.selectedUnit = 'percent';
        this.isActiveBox = false;
        this.isModalOpen = true;
    };

    openModal(){
        this.isModalOpen = true;
    };

    closeModal(){
        this.isModalOpen = false;
    };

    saveNewPricebook() {
        const pricebook = this.buildPricebook();
        const pricebookToJSON = JSON.stringify(pricebook);
        const recordsToJSON = JSON.stringify(this.records);
        console.log(pricebookToJSON);

        if (this.isValidForm()) {

//            this.isNewPricebookOverlapWithOther(pricebook);

            checkIfNewPricebookOverlapWithOther({pricebook: pricebookToJSON})
                .then(result => {
                    return savePriceBookWithProducts({pricebook: pricebookToJSON, products: recordsToJSON});
                })
            .then(result => {
                this.showSuccess('Operation completed successfully');
                refreshApex(this.pricebooks);
                this.closeModal();
            })
            .catch(error => {
                console.error(error);
                this.showError(error.body.message);
            });

        }
    };

    buildPricebook() {
        return {
           id: this.pricebookId,
           name: this.pricebookName,
           photoUrl: this.uploadedFile,
           validFrom: this.startDate,
           validTo: this.endDate,
           isActive: this.isActiveBox
       };
    };

    isValidForm() {
        const allValid = [
            ...this.template.querySelectorAll('lightning-input[data-id="pricebook-input"]'),
        ].reduce((validSoFar, inputCmp) => {
            inputCmp.reportValidity();
            return validSoFar && inputCmp.checkValidity();
        }, true);

        return allValid;
    };

    isNewPricebookOverlapWithOther(pricebook){
            checkIfNewPricebookOverlapWithOther({pricebook: pricebookToJSON})
            .then(result => {
            console.log(result);
            })
            .catch(error => {
            console.error(error);
            this.showError(error.body.message);
            });
    };

    changePricebookNameHandler(event){
        this.pricebookName = event.target.value;
    };

    changeStartDateHandler(event){
        this.startDate = event.target.value;
    };

    changeEndDateHandler(event){
        this.endDate = event.target.value;
    };

    changeUnitHandler(event) {
        this.selectedUnit = event.target.value;
    };

     changePriceHandler(event){
        this.priceValue = event.target.value;
    };

     changeIsActiveHandler(event){
        this.isActiveBox = event.target.checked;
        alert(isActiveBox);
    };

    changeProductsPrice(){
        const el = this.template.querySelector('lightning-datatable');
//        console.log(el);
        const selectedRows = el.getSelectedRows();
        console.log(selectedRows);

        const changedRecords = [];
        for(const row of selectedRows){
            changedRecords.push(
                {
                    "id": row.id,
                    "name": row.name,
                    "productFamily": row.productFamily,
                    "standardPrice": row.standardPrice,
                    "customPrice": this.calculatePrice(row),
                    "pbeId": row.pbeId
                }
            );
        }
        console.log(changedRecords);

        const updatedProductList = this.records.map(obj => changedRecords.find(o => o.name === obj.name) || obj);
        console.log(updatedProductList);
//        arr1.map(obj => arr2.find(o => o.id === obj.id) || obj);
        this.records = updatedProductList;
    };

    calculatePrice(row) {
        switch (this.selectedUnit) {
            case 'percent':
            default: {
                const result = Math.round(row.customPrice + (row.customPrice * (Number(this.priceValue)/100)));
                if(result > 0){
                    return result;
                }
                return 0;
//                return Math.round(row.customPrice + (row.customPrice * (Number(this.priceValue)/100)));
            }
            case 'amount': {
                const result = Math.round(row.customPrice + Number(this.priceValue));
                if(result > 0){
                    return result;
                }
                return 0;
//                return Math.round(row.customPrice + Number(this.priceValue));
            }
        }
    };

    handlePriceBookView(event) {
//        this.pricebookId = event.detail;
        this.pricebook = event.detail;
        this.pricebookId = event.detail.id;
        this.pricebookName = event.detail.name;
        this.startDate = event.detail.validFrom;
        this.endDate = event.detail.validTo;
        this.uploadedFile = event.detail.photoUrl;
        this.isActiveBox = event.detail.isActive;
        this.openModal();
    };

    handleSearchNameChange(event) {
        window.clearTimeout(this.delayTimeout);
        const searchName = event.target.value;
        this.delayTimeout = setTimeout(() => {
            this.searchName = searchName;
        }, 300);
    };

    handleSearchStartDateChange(event) {
        this.searchStartDate = event.target.value;
        alert(event.target.value);
    };

    handleSearchEndDateChange(event) {
        this.searchEndDate = event.target.value;
        alert(event.target.value);
    };

    showError(message) {
        this.showToast('Error', message, 'error');
    };

    showSuccess(message) {
        this.showToast('Success', message, 'success');
    };

    showToast(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(evt);
    };

    handleUploadFinished(event) {
        const uploadedFiles = event.detail.files;
        this.uploadedFile = uploadedFiles[0].contentVersionId;
//        alert('No. of files uploaded: ' + uploadedFile.val);
    };

    isEmpty(value) {
        return value === null || value === undefined || value === '';
    }
}