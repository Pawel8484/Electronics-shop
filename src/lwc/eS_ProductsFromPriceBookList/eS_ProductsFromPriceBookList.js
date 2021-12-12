import { LightningElement, wire, track } from 'lwc';
//import fetchDataHelper from './fetchDataHelper';
import getProductWrappers from '@salesforce/apex/ES_PriceManagerController.getProductWrappers';
const columns = [
    { label: 'Name', fieldName: 'name' },
    { label: 'Family', fieldName: 'productFamily' },
    { label: 'Standard Price', fieldName: 'standardPrice' },
    { label: 'New Price', fieldName: 'customPrice' },

//    { label: 'Balance', fieldName: 'amount', type: 'currency' },
//    { label: 'CloseAt', fieldName: 'closeAt', type: 'date' },
];

export default class ES_ProductsFromPriceBookList extends LightningElement {
//    data = [];
//    @wire(getProductWrappers) data;
    columns = columns;

//    async connectedCallback() {
//        const data = await getProductWrappers;
//        const data = await fetchDataHelper({ amountOfRecords: 100 });
//        this.data = data;
//    }

    @track records;
    @track error;

    @wire(getProductWrappers)
    wiredProductWrappers({ error, data }) {
        if (data) {
            this.records = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.records = undefined;
        }

}
}