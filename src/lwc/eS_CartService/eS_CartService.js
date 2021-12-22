const productIds = [];

const addProduct = (productId) => {
    console.log('addProduct ' + productId);
    productIds.push(productId);
    sessionStorage.setItem("productIds", JSON.stringify(productIds));
    console.log(JSON.parse(sessionStorage.getItem("productIds")));

};

const removeProduct = (productId) => {
    console.log('removeProduct ' + productId);

//    productIds = JSON.parse(localStorage.getItem("productIds"));

    const productIds2 = productIds.filter(function(id) {
                               return id != productId
   });

   productIds = [...productIds2];

    sessionStorage.setItem("productIds", JSON.stringify(productIds));
    console.log('productIds: ' + productIds);
};

export {
    addProduct,
    removeProduct
};