//
//  CartDataModel.h
//  GoNatuur
//
//  Created by Ranosys on 01/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CartDataModel : NSObject
@property (strong, nonatomic) NSNumber *itemId;
@property (strong, nonatomic) NSString *itemName;
@property (strong, nonatomic) NSNumber *itemPrice;
@property (strong, nonatomic) NSNumber *itemQty;
@property (strong, nonatomic) NSString *itemSku;
@property (strong, nonatomic) NSString *itemDescription;
@property (strong, nonatomic) NSString *itemImageUrl;
@property (strong, nonatomic) NSNumber *itemQuoteId;
@property (strong, nonatomic) NSNumber *checkoutImpactPoint;
@property (strong, nonatomic) NSMutableArray *itemList;
@property (strong, nonatomic) NSMutableDictionary *billingAddressDict;
@property (strong, nonatomic) NSMutableDictionary *extensionAttributeDict;
@property (strong, nonatomic) NSMutableDictionary *shippingAddressDict;
@property (strong, nonatomic) NSString *selectedShippingMethod;
@property (strong, nonatomic) NSMutableDictionary *customerDict;
@property (strong, nonatomic) NSMutableArray *customerSavedAddressArray;
@property (strong, nonatomic) NSMutableArray *shippmentMethodsArray;
@property (strong, nonatomic) NSMutableArray *checkoutPromosArray;
@property (strong, nonatomic) id cartListResponse;
@property (strong, nonatomic) NSString *promoPoints;
@property (strong, nonatomic) NSString *promoDiscountValue;
@property (strong, nonatomic) NSString *paymentMethod;
@property (strong, nonatomic) NSMutableDictionary *checkoutFinalData;
@property (strong, nonatomic) NSNumber *totalImpactPoints;
@property (strong, nonatomic) NSNumber *impactPoints;
@property (strong, nonatomic) NSNumber *productImpactPoint;
@property (strong, nonatomic) NSNumber *isRedeemProduct;
@property (strong, nonatomic) NSNumber *isRedeemProductExist;
@property (strong, nonatomic) NSNumber *isSimpleProductExist;
@property (strong, nonatomic) NSString *couponCode;
@property (strong, nonatomic) NSString *isCouponApplied;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *expirationMonth;

@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *cyberSourceOrderId;
@property (strong, nonatomic) NSString *countryId;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *postcode;
@property (strong, nonatomic) NSString *region;
@property (strong, nonatomic) NSString *regionCode;
@property (strong, nonatomic) NSString *sabeInAddress;
@property (strong, nonatomic) NSString *street;
@property (strong, nonatomic) NSString *telephone;
@property (strong, nonatomic) NSString *ccId;
@property (strong, nonatomic) NSString *ccNumber;
@property (strong, nonatomic) NSString *ccType;
@property (strong, nonatomic) NSString *expirationYear;
@property (strong, nonatomic) NSString *saveCard;
@property (strong, nonatomic) NSString *subscriptionID;
@property (strong, nonatomic) NSString *method;
@property (strong, nonatomic) NSString *clearCartEnabled;
@property (strong, nonatomic) NSString *orderIncrementId;
//Singleton instanse
+ (instancetype)sharedUser;

//Cart listing data
- (void)getCartListingData:(void (^)(CartDataModel *))success onfailure:(void (^)(NSError *))failure;
//Remove item from cart
- (void)removeItemFromCart:(void (^)(CartDataModel *))success onfailure:(void (^)(NSError *))failure;
//Fetch shippment methods
- (void)fetchShippmentMethodsOnSuccess:(void (^)(CartDataModel *))success onfailure:(void (^)(NSError *))failure;
//Fetch checkout promos
- (void)fetchCheckoutPromosOnSuccess:(void (^)(CartDataModel *))success onfailure:(void (^)(NSError *))failure;
//Set addresses and shipping methods
- (void)setUpdatedAddressShippingMethodsOnSuccess:(void (^)(CartDataModel *))success onfailure:(void (^)(NSError *))failure;
//Set checkout promo
- (void)setCheckoutPromosOnSuccess:(void (^)(CartDataModel *))success onfailure:(void (^)(NSError *))failure;
//Set payment method
- (void)setPaymentMethodOnSuccess:(void (^)(CartDataModel *))success onfailure:(void (^)(NSError *))failure;
//Set checkout order
- (void)setCheckoutOrderOnSuccess:(void (^)(CartDataModel *))success onfailure:(void (^)(NSError *))failure;
//Coupon code
- (void)applyCouponCode:(void (^)(CartDataModel *))success onfailure:(void (^)(NSError *))failure;
//remove
- (void)removeCouponCode:(void (^)(CartDataModel *))success onfailure:(void (^)(NSError *))failure;
//cybersource
- (void)setCyberSourcePaymentData:(void (^)(CartDataModel *))success onfailure:(void (^)(NSError *))failure;
//Get shipping method data
- (void)getShippingMethodData:(void (^)(CartDataModel *))success onfailure:(void (^)(NSError *))failure;
//Clear cart
- (void)clearCart:(void (^)(CartDataModel *))success onfailure:(void (^)(NSError *))failure;

@end
