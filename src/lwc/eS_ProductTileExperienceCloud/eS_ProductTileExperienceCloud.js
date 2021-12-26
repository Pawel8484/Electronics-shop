import { LightningElement, api, track } from 'lwc';
import cartService from 'c/eS_CartService';

export default class ES_ProductTileExperienceCloud extends LightningElement {

    @track markedState = false;
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

    handleAddProduct(event){
        event.stopPropagation();
        this.markedState = !this.markedState;
        this.markedState ? cartService.addProduct(this.product.id) : cartService.removeProduct(this.product.id);
    }
}