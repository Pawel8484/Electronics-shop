import { LightningElement, api } from 'lwc';

export default class ES_ProductTileExperienceCloud extends LightningElement {

    @api product;

    get photoUrl() {
        return '/sfc/servlet.shepherd/version/download/' + this.product.mainPicture;
    };

    handleSelectedProduct() {
        const selectEvent = new CustomEvent('productview', {
            detail: this.product
        });
        this.dispatchEvent(selectEvent);
    };

    get isCustomPriceLowerThanStandardPrice(){
        return this.product.customPrice < this.product.standardPrice;
    }
}