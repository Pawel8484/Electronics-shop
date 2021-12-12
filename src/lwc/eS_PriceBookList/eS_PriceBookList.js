import { LightningElement, api, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import EMPTY_IMAGE from '@salesforce/resourceUrl/emptyImage';
import getPriceBookWrappers from '@salesforce/apex/ES_PriceManagerController.getPriceBookWrappers';
import getProductWrappers from '@salesforce/apex/ES_PriceManagerController.getProductWrappers';
import savePriceBookWithProducts from '@salesforce/apex/ES_PriceManagerController.savePriceBookWithProducts';
import checkIfNewPricebookOverlapWithOther from '@salesforce/apex/ES_PriceManagerController.checkIfNewPricebookOverlapWithOther';
import {refreshApex} from '@salesforce/apex';

import Create_new_Price_Book from '@salesforce/label/c.Create_new_Price_Book';
import Price_Book_Name from '@salesforce/label/c.Price_Book_Name';
import Enter_Price_Book_name_you_are_looking_for from '@salesforce/label/c.Enter_Price_Book_name_you_are_looking_for';
import Start_Date from '@salesforce/label/c.Start_Date';
import End_Date from '@salesforce/label/c.End_Date';
import Update_Price_Book from '@salesforce/label/c.Update_Price_Book';
import Price_Book_name2 from '@salesforce/label/c.Price_Book_name2';
import Enter_new_Price_Book_name from '@salesforce/label/c.Enter_new_Price_Book_name';
import Attach_image from '@salesforce/label/c.Attach_image';
import Is_Active from '@salesforce/label/c.Is_Active';
import Enter_value from '@salesforce/label/c.Enter_value';
import Change_Price from '@salesforce/label/c.Change_Price';
import Close from '@salesforce/label/c.Close';
import Save from '@salesforce/label/c.Save';
import An_error_occurred_while_loading_the_list from '@salesforce/label/c.An_error_occurred_while_loading_the_list';
import Name from '@salesforce/label/c.Name';
import Family from '@salesforce/label/c.Family';
import Standard_Price from '@salesforce/label/c.Standard_Price';
import Operation_completed_successfully from '@salesforce/label/c.Operation_completed_successfully';
import New_Price from '@salesforce/label/c.New_Price';
import Enter_minus_sign_before_number_if_you_want_to_decrease_price from '@salesforce/label/c.Enter_minus_sign_before_number_if_you_want_to_decrease_price';

const columns = [
    { label: Name, fieldName: 'name' },
    { label: Family, fieldName: 'productFamily' },
    { label: Standard_Price, fieldName: 'standardPrice'},
    { label: New_Price, fieldName: 'customPrice'},
];

export default class ES_PriceBookList extends LightningElement {

	@wire(getPriceBookWrappers, {searchName: '$searchName', searchStartDate: '$searchStartDate', searchEndDate: '$searchEndDate'}) pricebooks;

	appResources = {
		emptyImage: EMPTY_IMAGE,
	};

	label = {
        Create_new_Price_Book,
        Price_Book_Name,
        Enter_Price_Book_name_you_are_looking_for,
        Start_Date,
        End_Date,
        Update_Price_Book,
        Price_Book_name2,
        Enter_new_Price_Book_name,
        Attach_image,
        Is_Active,
        Enter_value,
        Change_Price,
        Close,
        Save,
        An_error_occurred_while_loading_the_list,
        Enter_minus_sign_before_number_if_you_want_to_decrease_price
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
    columns = columns;
    isModalOpen = false;
    startRecords = {};

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
        this.startRecords = this.records;
    };

    openModal(){
        this.isModalOpen = true;
    };

    closeModal(){
        this.isModalOpen = false;
        this.pricebookId = null;
        this.selectedUnit = 'percent';
    };

    saveNewPricebook() {
        const pricebook = this.buildPricebook();
        const pricebookToJSON = JSON.stringify(pricebook);
        const recordsToJSON = JSON.stringify(this.records);

        if (this.isValidForm()) {
            checkIfNewPricebookOverlapWithOther({pricebook: pricebookToJSON})
                .then(result => {
                this.records = this.isEmpty(this.pricebook.id) ? this.startRecords : this.records;
                    return savePriceBookWithProducts({pricebook: pricebookToJSON, products: recordsToJSON});
                })
            .then(result => {
                this.showSuccess(Operation_completed_successfully);
                refreshApex(this.pricebooks);
                this.isModalOpen = false;
                this.selectedUnit = 'percent';
            })
            .catch(error => {
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

    get today() {
        const today = new Date();
        const newDate = this.isEmpty(this.pricebook.validFrom) ? today : new Date(this.pricebook.validFrom);

        if(today > newDate){
            return this.pricebook.validFrom;
     }
        return today.toISOString().split('T')[0];
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
    };

    changeProductsPrice(){
        const el = this.template.querySelector('lightning-datatable');
        const selectedRows = el.getSelectedRows();

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
        const updatedProductList = this.records.map(obj => changedRecords.find(o => o.name === obj.name) || obj);
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
            }
            case 'amount': {
                const result = Math.round(row.customPrice + Number(this.priceValue));
                if(result > 0){
                    return result;
                }
                return 0;
            }
        }
    };

    handlePriceBookView(event) {
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
    };

    handleSearchEndDateChange(event) {
        this.searchEndDate = event.target.value;
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
    };

    isEmpty(value) {
        return value === null || value === undefined || value === '';
    }
}