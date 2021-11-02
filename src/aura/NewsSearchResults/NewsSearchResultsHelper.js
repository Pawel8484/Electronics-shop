({
    getNewsPage: function(component, pageRequest) {
        const helper = this;
        const action = component.get("c.getNews");
        action.setParams({"searchParams": JSON.stringify(pageRequest)});
        action.setCallback(this,function(response) {
            const state = response.getState();
              if(state ==='SUCCESS'){
                  const newsPage = response.getReturnValue();
                  this.parseNewsPage(newsPage);
                  component.set("v.newsPage", newsPage);
              } else {
                  this.handleErrors(response.getError());
              }
        });
        $A.enqueueAction(action);
    },

    handleErrors: function(errors) {
        if (errors) {
            if (errors[0] && errors[0].message) {
                this.showError(errors[0].message);
            }
        } else {
            this.showError('Unknown error');
        }
    },

    showError: function(error) {
        const toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Server Error",
            "message": error,
            "type": "error"
        });
        toastEvent.fire();
    },

    parseNewsPage: function(newsPage) {
        for (const article of newsPage.articles) {
            article.publishedAt = new Date(article.publishedAt);
        }
    },

    showSpinner: function(component) {
        component.set('v.showSpinner', true);
    },

    hideSpinner: function(component) {
        component.set('v.showSpinner', false);
    },
})