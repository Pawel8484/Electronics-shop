({
    setupCarousel: function(component) {
            let arrows = component.get("v.arrows");
            let autoplay = component.get("v.autoplay");
            let autoplaySpeed = component.get("v.autoplaySpeed");
            let dots = component.get("v.dots");
            let infinite = component.get("v.infinite");
            let speed = component.get("v.speed");
            let serviceDispatcher = component.find("serviceDispatcher");
            let carouselContainer = component.find('carousel-container');

            setTimeout(function() {
                $(".carousel").not('.slick-initialized').slick({
                    centerMode: true,
                    autoplay: autoplay,
                    autoplaySpeed: autoplaySpeed,
                    arrows: arrows,
                    dots: dots,
                    infinite: true,
                    speed: speed,
                    slidesToShow: 4,
                    adaptiveHeight: false,
                    prevArrow: $('#prevArr'),
                    nextArrow: $('#nextArr'),
                    appendDots: $('#dots'),
                    draggable: true
                });
            }, 0);
        },

    getNewsPage: function(component, pageRequest) {
        const helper = this;
//        const action = component.get("c.getNews");
        const action = component.get("c.getHotNews");
        action.setParams({"searchParams": JSON.stringify(pageRequest)});
        action.setCallback(this,function(response) {
            const state = response.getState();
              if(state ==='SUCCESS'){
                  const newsPage = response.getReturnValue();
                  helper.parseNewsPage(newsPage);
                  component.set("v.newsPage", newsPage);
                  helper.setupCarousel(component);
              } else {
                  helper.handleErrors(response.getError());
              }
        });
        $A.enqueueAction(action);
    },

   parseNewsPage: function(newsPage) {
        for (const article of newsPage.articles) {
            article.publishedAt = new Date(article.publishedAt);
        }
    },
})