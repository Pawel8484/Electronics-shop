import { LightningElement, api, track } from 'lwc';
import getProductWrap from '@salesforce/apex/ES_ProductDetailsController.getProductWrapper';

export default class ES_ProductDetails extends LightningElement {

    @api recordId;
    name;
    family;

    connectedCallback() {
        this.getProductDetails();
    }

    getProductDetails() {
        getProductWrap({productId: this.recordId})
            .then((result) => {
                 console.log(result);
                 this.name = result.name;
                 this.family = result.productFamily;
            })
            .catch((error) => {
                console.error(error);
                this.showError(error.body.message);
            });
    }

}