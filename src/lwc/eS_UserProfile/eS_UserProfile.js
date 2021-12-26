import {LightningElement, wire} from 'lwc';
import {NavigationMixin} from "lightning/navigation";
import {getRecord, getFieldValue} from 'lightning/uiRecordApi';

import USER_ID from '@salesforce/user/Id';
import USER_NAME_FIELD from '@salesforce/schema/User.Name';

//import PROFILE from '@salesforce/label/c.Profile';
//import LOGOUT from '@salesforce/label/c.Logout';

const MENU_ITEMS = [
    {
        id: 'profile',
        label: 'PROFILE',
        pageRef: {
            type: 'standard__recordPage',
            attributes: {
                objectApiName: 'User',
                recordId: USER_ID,
                actionName: 'view'
            }
        }
    },
    {
        id: 'logout',
        label: 'LOGOUT',
        pageRef: {
            type: "comm__loginPage",
            attributes: {
                actionName: "logout"
            }
        }
    }
];

export default class SelfServiceProfileMenu extends NavigationMixin(LightningElement) {
    @wire(getRecord, { recordId: USER_ID, fields: [USER_NAME_FIELD] })
    user;

    get username() {
        return getFieldValue(this.user.data, USER_NAME_FIELD);
    }

    get menuItems() {
        return MENU_ITEMS;
    }

    toggleUserMenu() {
        this.template.querySelector('.customer-dropdown').classList.toggle('open')
    }

    handleItemSelect(event) {
        const targetId = event.target.dataset.id;
        let pageReference = this.getMenuItem(targetId).pageRef;
        this[NavigationMixin.Navigate](pageReference);
        this.toggleUserMenu();
    }

    getMenuItem(id) {
        for (let menuItem of this.menuItems) {
            if (menuItem.id === id) {
                return menuItem;
            }
        }
    }
}