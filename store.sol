// SPDX-License-Identifier: MIT 

// Simple smart contract for online store on Solidity | created by oleh0xchain 


pragma solidity ^0.8.28;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract store is Ownable {


    // @notice: buyer => product_id => quantity 
    mapping (address => mapping(uint256 => uint256)) public userPurchase; 
    // @notice: product_id => quantity 
    mapping (uint256 => uint256) private product_purchase; 
    // @notice: buyer => Purchase
    mapping(address => Purchase[]) private userPurchases;
    // @notice: discountCode => discountAmount 
    mapping(string => uint256 ) private discountCodes; 

    struct Product {
        string name; 
        uint256 id; 
        uint256 stock; 
        uint256 price; 
    }

    struct Purchase{
        
        uint256 productID; 
        uint256 quantity; 
        uint256 paidPrice; 
        uint256 timeStamp; 
    }

    uint256 totalRevenue; 

    Product[] private products; 

    event PurchaseMade(address buyer, uint256 id, uint256 quantity, uint256 paidPrice);   
    event ReturnMade (address buyer, uint256 id, uint256 quantity, uint256 returnPrice);

    error IdAlreadyExist(); 
    error IdDoesNotExist();
    error OutOfStock(); 
    error NotEnoughFunds();
    error QuantityCantBeZero(); 
    error ThereIsNoProducts();
    error UserHasNoPurchases(); 
    error CantRefundAfter24hours(); 
    error DontHaveMoneyForReturn();
    error InvalidDiscountAmount(); 
    error DiscountCodeExist(); 
    error CodeDoesNotExist(); 

    constructor() Ownable(msg.sender) {}

    function buy(uint256 _id, uint256 _quantity, string calldata discountCode) payable external {
    
        require(_quantity > 0, QuantityCantBeZero());
        require(getStock(_id) >= _quantity, OutOfStock());
        uint256 discount = discountCodes[discountCode]; 
        uint256 totalPrice = getPrice(_id) * _quantity;

        if(discount>0){
            totalPrice = (totalPrice * (100-discount)/100);
        }

        require(msg.value >=  totalPrice, NotEnoughFunds());

        //buy 
        _buyProcess(msg.sender, _id, _quantity, totalPrice);

        if(msg.value > totalPrice){
        payable(msg.sender).transfer(msg.value - totalPrice);
        }

    }

    function batchBuy(uint256[] calldata _ids, uint256[] calldata _quantitys, string calldata discountCode) payable external {
        require(_ids.length == _quantitys.length, "Arrays length mismatch");
        uint256 totalPrice = 0;

        for(uint256 i = 0; i < _ids.length;i++){
            uint256 q = _quantitys[i]; 
            uint256 id = _ids[i];
            
            require(q > 0, QuantityCantBeZero());
            require(getStock(id) >= q, OutOfStock());

            totalPrice += getPrice(id) * q;

        }

       uint256 discount = discountCodes[discountCode]; 

        if(discount>0){
            totalPrice = (totalPrice * (100-discount)/100);
        }

        require(msg.value >=  totalPrice, NotEnoughFunds());

        for(uint256 i = 0; i<_ids.length;i++){

            uint256 q = _quantitys[i]; 
            uint256 id = _ids[i];
            _buyProcess(msg.sender, id, q, totalPrice);
        }

        if(msg.value > totalPrice){
        payable(msg.sender).transfer(msg.value - totalPrice);
        }

    }

    function _buyProcess(address buyer, uint256 _id, uint256 _quantity, uint256 _paidPrice ) internal {
        Product storage product = findProduct(_id);
        product.stock -= _quantity; 
        userPurchase[buyer][_id] += _quantity; 
        product_purchase[_id] += _quantity; 
        totalRevenue += _paidPrice; 
        userPurchases[buyer].push(Purchase(_id, _quantity, _paidPrice, block.timestamp));
        emit PurchaseMade(buyer, _id, _quantity, _paidPrice);
    }

    function refund() public  {

        require(userPurchases[msg.sender].length > 0, UserHasNoPurchases());
        
        Purchase storage lastPurchase = userPurchases[msg.sender][userPurchases[msg.sender].length-1];
        Product storage product = findProduct(lastPurchase.productID);


        require(block.timestamp - lastPurchase.timeStamp <= 1 days, CantRefundAfter24hours());

        userPurchase[msg.sender][lastPurchase.productID] -= lastPurchase.quantity;

        product_purchase[lastPurchase.productID] -= lastPurchase.quantity;

        totalRevenue -= lastPurchase.paidPrice;
        product.stock += lastPurchase.quantity;
         
        require(address(this).balance >= lastPurchase.paidPrice, DontHaveMoneyForReturn());
        payable(msg.sender).transfer(lastPurchase.paidPrice);

        emit ReturnMade(msg.sender, lastPurchase.productID, lastPurchase.quantity, lastPurchase.paidPrice);

        userPurchases[msg.sender].pop();

    }

    function Withdraw() external onlyOwner(){
        
        uint256 balance  = address(this).balance;
        require(balance > 0, "Not enough money");

       payable(owner()).transfer(balance); 
    }


    function addProduct(string calldata _name, uint256 _id, uint256 _stock, uint256 _price) external onlyOwner(){ 

        require(!isIdExist(_id), IdAlreadyExist());
        products.push(Product(_name, _id, _stock, _price));
    }

    function addDiscountCode(string calldata code, uint256 discountAmount) external onlyOwner {

        require(discountAmount > 0 && discountAmount <= 90, InvalidDiscountAmount());
        require(discountCodes[code] == 0, DiscountCodeExist());

        discountCodes[code] = discountAmount; 
        
    }

     function deleteDiscountCode(string calldata code) external onlyOwner {

       require(discountCodes[code] > 0, CodeDoesNotExist());
       
       delete discountCodes[code]; 
        
    }

    function deleteProduct(uint256 _id) external onlyOwner{
        (bool status, uint256 index) = findIndexById(_id);
        require(status, IdDoesNotExist());
        products[index] = products[products.length - 1]; 
        products.pop();
    }

    function updatePrice(uint256 _id, uint256 _price) external onlyOwner {
       Product storage product = findProduct(_id); // reference to products[index] element 
       product.price = _price; 
    }

    function updateStock(uint256 _id, uint256 _stock) external onlyOwner {
        Product storage product = findProduct (_id); 
        product.stock = _stock; 
    }

    function getTopSellingProducts() public view returns (uint256 topSellingProductID, uint256 topSales){

        require(products.length>0,ThereIsNoProducts ());

         topSales = 0;
         topSellingProductID = products[0].id; 

        for (uint256 i =0;i<products.length;i++){
            uint256 productID = products[i].id; 
            uint256 sales = product_purchase[productID]; 

            if(sales > topSales){
                topSales = sales; 
                topSellingProductID = productID; 
            }
        }

        return (topSellingProductID, topSales);
    }

    function getUserPurchases(address buyer) public view returns (Purchase[] memory){
        return userPurchases[buyer]; 
    }

    function getProducts() public view returns (Product[] memory){
        return products; 
    }

    function getPrice(uint256 _id) public view returns (uint256){
          Product storage product = findProduct (_id); 
          return product.price; 
    }

    function getStock(uint256 _id) public view returns (uint256){
          Product storage product = findProduct (_id); 
          return product.stock; 
    }

    function getTotalRevenue() public view returns (uint256){
        return totalRevenue; 
    }

    function findProduct(uint256 _id) internal view returns (Product storage product){
        for (uint i = 0; i <products.length; i++){
            if(products[i].id == _id){
                return products[i];
            }
        }
        revert IdDoesNotExist(); 
    }

    function isIdExist(uint256 _id) internal view returns (bool ){
        for (uint256 i = 0; i < products.length; i++){
            if(products[i].id == _id){ return true; }
        }

        return false; 
    }
    
    function findIndexById(uint256 _id) internal view returns (bool, uint256){
        for (uint256 i = 0; i < products.length; i++){
            if(products[i].id == _id){ return (true, i); }
        }
        return(false, 0);
    }
}