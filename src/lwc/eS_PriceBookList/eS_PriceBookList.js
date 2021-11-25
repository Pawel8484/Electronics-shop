import { LightningElement, api, wire, track } from 'lwc';
import EMPTY_IMAGE from '@salesforce/resourceUrl/emptyImage';
import getPriceBookWrappers from '@salesforce/apex/ES_PriceManagerController.getPriceBookWrappers';
import getProductWrappers from '@salesforce/apex/ES_PriceManagerController.getProductWrappers';

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

    error;
    priceValue;
    selectedUnit;
    columns = columns;
    isModalOpen = false;

    @wire(getProductWrappers)
    wiredProductWrappers({ error, data }) {
        if (data) {
            this.records = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.records = undefined;
        }
    };

    openModal(){
        this.isModalOpen = true;
    };

    closeModal(){
        this.isModalOpen = false;
    };

    saveNewPricebook(){

    };

    changeUnitHandler(event) {
        this.selectedUnit = event.target.value;
    };

     changePriceHandler(event){
        this.priceValue = event.target.value;
    };

    handleclick(){
        const el = this.template.querySelector('lightning-datatable');
//        console.log(el);
        const selected = el.getSelectedRows();
        console.log(selected);

        const selectedAfterPriceChange = new Array();
        for(const select of selected){
            selectedAfterPriceChange.push({"id": select.id, "name": select.name, "productFamily": select.productFamily, "standardPrice": select.standardPrice, "customPrice": select.customPrice + Number(this.priceValue)});
        }
        console.log(selectedAfterPriceChange);

        const updatedProductList = this.records.map(obj => selectedAfterPriceChange.find(o => o.name === obj.name) || obj);
        console.log(updatedProductList);
//        arr1.map(obj => arr2.find(o => o.id === obj.id) || obj);
        this.records = updatedProductList;
    };
}