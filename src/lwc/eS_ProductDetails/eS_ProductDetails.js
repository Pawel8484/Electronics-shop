import { LightningElement, api, track } from 'lwc';
import getProductWrap from '@salesforce/apex/ES_ProductDetailsController.getProductWrapper';

export default class ES_ProductDetails extends LightningElement {

    @api recordId;
    name;
    family;
    display;
    processor;
    camera;
    memory;
    battery;
    operatingSystem;
    customPrice;

    connectedCallback() {
        this.getProductDetails();
    }

    getProductDetails() {
        getProductWrap({productId: this.recordId})
            .then((result) => {
                 console.log(result);
                 this.name = result.name;
                 this.family = result.productFamily;
                 this.display = result.display;
                 this.processor = result.processor;
                 this.camera = result.camera;
                 this.memory = result.memory;
                 this.battery = result.battery;
                 this.operatingSystem = result.operatingSystem;
                 this.customPrice = result.customPrice;
            })
            .catch((error) => {
                console.error(error);
                this.showError(error.body.message);
            });
    }

}