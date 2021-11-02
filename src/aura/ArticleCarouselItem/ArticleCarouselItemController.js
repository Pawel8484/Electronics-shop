({
        selectedArticle: function(component, event, helper) {
            const hotObject = component.get('v.article');
//            console.log(articleObject);
            const hotNewsTransfer = component.getEvent("hotNewsTransfer");

                hotNewsTransfer.setParams({
                    hotNewsObject: hotObject
                });
//                console.log('Before fire: ' + hotNewsObject);

                hotNewsTransfer.fire();
        },

        imageError: function(component,event,helper){
              event.target.src = 'https://www.generationsforpeace.org/wp-content/uploads/2018/03/empty.jpg';
             },
})