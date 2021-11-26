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
    pricebookName;
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

    openModal(){
        this.isModalOpen = true;
    };

    closeModal(){
        this.isModalOpen = false;
    };

    saveNewPricebook() {
        const pricebook = {
            name: this.pricebookName
//            validFrom: '',
//            validTo: ''
        };
        const pricebookToJSON = JSON.stringify(pricebook);
        const recordsToJSON = JSON.stringify(this.records);

        savePriceBookWithProducts({pricebook: pricebookToJSON, products: recordsToJSON})
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
                    "customPrice": this.calculatePrice(row)
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
        this.pricebookId = event.detail;
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