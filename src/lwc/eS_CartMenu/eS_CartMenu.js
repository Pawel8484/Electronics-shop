import { LightningElement } from 'lwc';
import { NavigationMixin } from "lightning/navigation";

export default class ES_CartMenu extends NavigationMixin(LightningElement) {
    handleCartMenuClick() {
        this.navigateToCart();
    }

    navigateToCart() {
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'Home'
            }
        });
    }
}