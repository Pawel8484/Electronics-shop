import { LightningElement, api, wire, track } from 'lwc';
import getProductsWrap from '@salesforce/apex/ES_ProductSearchExpCloudController.getProductsWrapper';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ES_ProductListExperience extends NavigationMixin(LightningElement) {

    @track products;
    product;
    productId;
//    searchName = '';
//    searchMinPrice = 0;
//    searchMaxPrice = null;

    searchRequest = {
        searchName: '',
        minPrice: 0,
        maxPrice: null,
        category: null,
        brands: []
    };

     get options() {
        return [
            { label: 'Apple', value: 'Apple' },
            { label: 'Dell', value: 'Dell' },
        ];
    }

     get categoryOptions() {
        return [
            { label: 'Mobile Phone', value: 'Mobile Phone' },
            { label: 'Laptop', value: 'Laptop' },
        ];
    }
//    @wire(getProductsWrap, {searchName: '$searchName', searchMinPrice: '$searchMinPrice', searchMaxPrice: '$searchMaxPrice'})
//        wiredProductsWrap({ error, data }) {
//            if (data) {
//                this.products = data;
//            } else if (error) {
//                this.showError(error.body.message);
//                this.products = [];
//            }
//        };

    connectedCallback() {
        this.getProducts();
    }

    getProducts() {
        getProductsWrap({searchRequestJson: JSON.stringify(this.searchRequest)})
            .then((result) => {
                 console.log(result);
                 this.products = result;
            })
            .catch((error) => {
                console.error(error);
                this.showError(error.body.message);
            });
    }

    handleSearchNameChange(event) {
        window.clearTimeout(this.delayTimeout);
        const searchName = event.target.value;
        this.delayTimeout = setTimeout(() => {
            this.searchRequest.searchName = searchName;
            console.log(searchName);
            this.getProducts();
        }, 300);
    };

    handleSearchMinPrice(event) {
        window.clearTimeout(this.delayTimeout);
        const searchMinPrice = this.minPriceValue(event.target.value);
        this.delayTimeout = setTimeout(() => {
            this.searchRequest.minPrice = searchMinPrice;
            console.log(searchMinPrice);
            this.getProducts();
        }, 300);
    };

    handleSearchMaxPrice(event) {
        window.clearTimeout(this.delayTimeout);
        const searchMaxPrice = this.maxPriceValue(event.target.value);
        this.delayTimeout = setTimeout(() => {
            this.searchRequest.maxPrice = searchMaxPrice;
            console.log(searchMaxPrice);
            this.getProducts();
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

//    minPriceValue(minPrice){
//        if(minPrice == ''){
//            return 0;
//        }
//        return minPrice;
//    }

    minPriceValue(minPrice){
        return minPrice == '' ? 0 : minPrice;
    }

    maxPriceValue(maxPrice){
        return maxPrice == '' ? null : maxPrice;
    }

    handleBrandsChange(e) {
        this.searchRequest.brands = e.detail.value;
        console.log(this.searchRequest.brands);
    }

    handleCategoryChange(e) {
        this.searchRequest.brands = e.detail.value;
        console.log(this.searchRequest.brands);
    }
}