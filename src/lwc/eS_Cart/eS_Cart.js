import { LightningElement, track } from 'lwc';
import { NavigationMixin } from "lightning/navigation";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import cartService from 'c/eS_CartService';
import getCart from '@salesforce/apex/ES_CartController.getCart';

export default class ES_CartMenu extends NavigationMixin(LightningElement) {
    @track cart = {};

    connectedCallback() {
        this.getCartItems();
    }

    getCartItems() {
        const productIds = cartService.getProducts();
        getCart({productIds: productIds})
            .then((result) => {
                this.cart = JSON.parse(JSON.stringify(result));
                this.calculateTotalPrice();
            })
            .catch((error) => {
                this.showError(error);
            });
    }

    calculateTotalPrice() {
        let totalPrice = 0;
        let totalCustomPrice = 0;
        let totalQuantity = 0;

        for (const cartItem of this.cart.items) {
            totalPrice += (cartItem.product.standardPrice * cartItem.quantity);
            totalCustomPrice += (cartItem.product.customPrice * cartItem.quantity);
            totalQuantity += cartItem.quantity;
        }

        this.cart.totalPrice = totalPrice;
        this.cart.totalCustomPrice = totalCustomPrice;
        this.cart.totalQuantity = totalQuantity;
    }

    handleQuantityChange(event) {
        const cartItem = this.cart.items.find(item => item.id === event.detail.id);
        cartItem.quantity = event.detail.quantity;
        this.calculateTotalPrice();
    }

    handleItemDelete(event) {
        cartService.removeProduct(event.detail);
        this.getCartItems();
    }

    showError(message) {
        this.showToast('Error', message, 'error');
    };

    showSuccess(message) {
        this.showToast('Success', message, 'success');
    };

    showToast(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(evt);
    };
}