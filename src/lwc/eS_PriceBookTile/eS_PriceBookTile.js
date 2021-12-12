import { LightningElement, api } from 'lwc';
import EMPTY_IMAGE from '@salesforce/resourceUrl/emptyImage';

import Name from '@salesforce/label/c.Name';
import Is_Active from '@salesforce/label/c.Is_Active';
import Start_Date from '@salesforce/label/c.Start_Date';
import End_Date from '@salesforce/label/c.End_Date';

export default class ES_PriceBookTile extends LightningElement {

	@api pricebook;
	appResources = {
		emptyImage: EMPTY_IMAGE,
	};

	label = {
        Start_Date,
        End_Date,
        Is_Active,
        Name,
        };

	get photoUrl() {
        return '/sfc/servlet.shepherd/version/download/' + this.pricebook.photoUrl;
    };

	handleSelectedPriceBook() {
    	const selectEvent = new CustomEvent('pricebookview', {
    		detail: this.pricebook
    	});
    	this.dispatchEvent(selectEvent);
    }
}