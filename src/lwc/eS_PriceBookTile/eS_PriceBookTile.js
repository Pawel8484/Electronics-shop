import { LightningElement, api } from 'lwc';
import EMPTY_IMAGE from '@salesforce/resourceUrl/emptyImage';
export default class ES_PriceBookTile extends LightningElement {
	@api pricebook;
	appResources = {
		emptyImage: EMPTY_IMAGE,
	};
}