import { LightningElement, api } from 'lwc';
import EMPTY_IMAGE from '@salesforce/resourceUrl/emptyImage';

export default class ES_PriceBookTile extends LightningElement {

	@api pricebook;
	appResources = {
		emptyImage: EMPTY_IMAGE,
	};

	get photoUrl() {
        return '/sfc/servlet.shepherd/version/download/' + this.pricebook.photoUrl;
    }

	handleSelectedPriceBook() {
    	const selectEvent = new CustomEvent('pricebookview', {
    		detail: this.pricebook
//    		detail: this.pricebook.id
    	});
    	this.dispatchEvent(selectEvent);
    }
}