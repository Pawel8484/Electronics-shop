import { LightningElement, api, track } from 'lwc';
const QUANTITY_OPTIONS = [
    {value: "1", label:'1'},
    {value: "2", label:'2'},
    {value: "3", label:'3'},
    {value: "4", label:'4'}
];

export default class ES_CartItem extends LightningElement {

    @api item;
    quantity = "1";

    get quantityOptions() {
        return QUANTITY_OPTIONS;
    }

    get photoUrl() {
        return '/sfc/servlet.shepherd/version/download/' + this.item.product.mainPicture;
    };

    handleQuantityChange(event) {
        this.quantity = event.detail.value;
        const quantityChangeEvent = new CustomEvent('quantitychange', {
            detail: {
                id: this.item.id,
                quantity: parseInt(this.quantity)
            }
        });
        this.dispatchEvent(quantityChangeEvent);
    }

    handleDelete() {
        const event = new CustomEvent('delete', {
            detail: this.item.id
        });
        this.dispatchEvent(event);
    }
}