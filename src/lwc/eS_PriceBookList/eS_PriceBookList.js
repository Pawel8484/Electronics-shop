import { LightningElement, api, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import EMPTY_IMAGE from '@salesforce/resourceUrl/emptyImage';
import getPriceBookWrappers from '@salesforce/apex/ES_PriceManagerController.getPriceBookWrappers';
import getProductWrappers from '@salesforce/apex/ES_PriceManagerController.getProductWrappers';
import savePriceBookWithProducts from '@salesforce/apex/ES_PriceManagerController.savePriceBookWithProducts';

const columns = [
    { label: 'Name', fieldName: 'name' },
    { label: 'Family', fieldName: 'productFamily' },
    { label: 'Standard Price', fieldName: 'standardPrice' },
    { label: 'New Price', fieldName: 'customPrice' },
];

export default class ES_PriceBookList extends LightningElement {

	@wire(getPriceBookWrappers) pricebooks;
	appResources = {
		emptyImage: EMPTY_IMAGE,
	};

    @track records;

    pricebookId = '';
    @api pricebookName;
    startDate;
    endDate;
    priceValue;
    selectedUnit = 'percent';
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
        this.pricebookId = '';
        this.pricebookName = '';
        this.startDate = '';
        this.endDate = '';
        this.isModalOpen = true;
    };

    openModal(){
        this.isModalOpen = true;
    };

    closeModal(){
        this.isModalOpen = false;
    };

    saveNewPricebook() {
        const pricebook = {
            id: this.pricebookId,
            name: this.pricebookName,
            validFrom: this.startDate,
            validTo: this.endDate
        };
        const pricebookToJSON = JSON.stringify(pricebook);
        const recordsToJSON = JSON.stringify(this.records);
        console.log(recordsToJSON);

        console.log(pricebook.id);
        alert(pricebook.toString());
        savePriceBookWithProducts({pricebook: pricebookToJSON, products: recordsToJSON})
        .then(result => {
            console.log(result);
        })
        .catch(error => {
            console.error(error);
            this.showError(error.body.message);
        });
        this.closeModal();
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
                return row.customPrice + (row.customPrice * (Number(this.priceValue)/100));
            }
            case 'amount': {
                return row.customPrice + Number(this.priceValue);
            }
        }
    };

    handlePriceBookView(event) {
//        this.pricebookId = event.detail;
        this.pricebookId = event.detail.id;
        this.pricebookName = event.detail.name;
        this.startDate = event.detail.validFrom;
        this.endDate = event.detail.validTo;
//
        this.openModal();
    };

    showError(message) {
        this.showToast('Error', message, 'error');
    };

    showToast(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(evt);
    };
}