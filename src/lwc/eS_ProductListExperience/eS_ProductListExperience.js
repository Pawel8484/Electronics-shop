import { LightningElement, api, wire, track } from 'lwc';
import getProductsWrap from '@salesforce/apex/ES_ProductSearchExpCloudController.getProductsWrapper';
import { NavigationMixin } from 'lightning/navigation';

export default class ES_ProductListExperience extends NavigationMixin(LightningElement) {

    @track products;
    product;
    productId;
    searchName = '';

    @wire(getProductsWrap, {searchName: '$searchName'})
        wiredProductsWrap({ error, data }) {
            if (data) {
                this.products = data.products;

            } else if (error) {
                this.showError(error.body.message);
                this.products = [];
            }
        };

    handleSearchNameChange(event) {
        window.clearTimeout(this.delayTimeout);
        const searchName = event.target.value;
        this.delayTimeout = setTimeout(() => {
            this.searchName = searchName;
            console.log(searchName);
        }, 300);
    };

//    navigateToProduct() {
//        this[NavigationMixin.Navigate]({
//            type: 'standard__recordPage',
//            attributes: {
//                recordId: product.id,
//                objectApiName: 'Product2',
//                actionName: 'view'
//            }
//        });
//    };

    navigateToProduct(product) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: product.id,
                objectApiName: 'Product2',
                actionName: 'view'
            }
        });
    };

    handleProductView(event) {
        this.navigateToProduct(event.detail);
    };

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