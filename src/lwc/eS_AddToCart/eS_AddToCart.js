import { LightningElement, api, track } from 'lwc';
import cartService from 'c/eS_CartService';

import standardTemplate from './eS_AddToCart.html';
import detailTemplate from './eS_AddToCartDetail.html';

export default class ES_ProductTileExperienceCloud extends LightningElement {
    @api productId;
    @api variant = 'standard';

    @track markedState = false;

    render() {
        return this.variant === 'detail' ? detailTemplate : standardTemplate;
    }

    connectedCallback() {
        if (cartService.hasProduct(this.productId)) {
            this.markedState = true;
        }
    }

    handleAddProduct(event){
        event.stopPropagation();
        this.markedState = !this.markedState;
        this.markedState ? cartService.addProduct(this.productId) : cartService.removeProduct(this.productId);
    }
}