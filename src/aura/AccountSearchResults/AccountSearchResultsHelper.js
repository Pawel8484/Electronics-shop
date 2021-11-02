({
    onSearch : function(component, data) {
        const action = component.get("c.getAccounts");
        action.setParams(
            {"accountCountry":data.accountId,
            "accountName":data.accountName}
        );
        action.setCallback(this,function(response) {
            const state= response.getState();
            if(state==='SUCCESS'){
                component.set("v.accounts", response.getReturnValue());
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },

    selectAll: function(component) {
        const tiles = component.find('accountTile');
        if (Array.isArray(tiles)) {
            for (const tile of tiles) {
                tile.select();
            }
        } else {
            tiles.select();
        }
    },

    deselect: function(component) {
        const tiles = component.find('accountTile');
        if (Array.isArray(tiles)) {
             for (const tile of tiles) {
                 tile.deselect();
             }
        } else {
            tiles.deselect();
        }
    },

    invert: function(component) {
         const tiles = component.find('accountTile');
         if (Array.isArray(tiles)) {
              for (const tile of tiles) {
                  tile.toggle();
              }
         } else {
             tiles.toggle();
         }
    },

    activate: function(component) {
         const tiles = component.find('accountTile');
         if (Array.isArray(tiles)) {
              for (const tile of tiles) {
                  tile.activate();
              }
         } else {
             tiles.activate();
         }
    },

    remove: function(component) {
         const tiles = component.find('accountTile');
         const selectedAccountsIds = [];

         if (Array.isArray(tiles)) {
              for (const tile of tiles) {
                  const isSelected = tile.isSelected();
                  if (isSelected) {
                      const accountId = tile.get('v.accountId');
                      selectedAccountsIds.push(accountId);
                  }
              }
         } else {
             const isSelected = tiles.isSelected();
             if (isSelected) {
               const accountId = tile.get('v.accountId');
               selectedAccountsIds.push(accountId);
             }
         }

         const accounts = component.get('v.accounts');
         const filteredAccounts = accounts.filter(function(account) {
             return !selectedAccountsIds.includes(account.Id);
         });

         component.set('v.accounts', filteredAccounts);
    },

    clone: function(component) {
         const tiles = component.find('accountTile');
         const accounts = component.get('v.accounts');

         if (Array.isArray(tiles)) {
              for (const tile of tiles) {
                  const isSelected = tile.isSelected();
                  if (isSelected) {
                      const account = tile.get('v.account');
                      const clonedAccount = JSON.parse(JSON.stringify(account));
                      clonedAccount.Id = this.generateId();
                      accounts.push(clonedAccount);
                  }
              }
         } else {
             const isSelected = tiles.isSelected();
             if (isSelected) {
                 const account = tile.get('v.account');
                 const clonedAccount = JSON.parse(JSON.stringify(account));
                 clonedAccount.Id = this.generateId();
                 accounts.push(clonedAccount);
             }
         }

         component.set('v.accounts', accounts);
    },

   generateId: function() {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
    var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
    return v.toString(16);
  });
}
})