const addProduct = (productId) => {
    const listOfProducts = JSON.parse(sessionStorage.getItem('productsIds')) || [];
    listOfProducts.push(productId);
    console.log('listOfProducts', listOfProducts);
    sessionStorage.setItem("productsIds", JSON.stringify(listOfProducts));
};

const removeProduct = (productId) => {
    const listOfProducts = JSON.parse(sessionStorage.getItem('productsIds')) || [];

    const modifiedListOfProducts = listOfProducts.filter(id => id!== productId);
    console.log('modifiedListOfProducts', modifiedListOfProducts);

    sessionStorage.setItem("productsIds", JSON.stringify(modifiedListOfProducts));
};

//const isEmpty = (value) => {
//    return value === undefined || value === null || value === '';
//}

export {
    addProduct,
    removeProduct
};