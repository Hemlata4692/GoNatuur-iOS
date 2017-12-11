//
//  CartService.h
//  GoNatuur
//
//  Created by Ranosys on 01/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CartDataModel;
@interface CartService : Webservice

//Fetch shipping methods
- (void)getShippingMethod:(CartDataModel *)cartData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure;
//Fetch cart listing
- (void)getCartListing:(CartDataModel *)reviewData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure;
//Remove item from cart
- (void)removeItemFromCart:(CartDataModel *)cartData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure;
//Fetch shippment methods
- (void)fetchShippmentMethods:(CartDataModel *)cartData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure;
//Fetch checkout promos
- (void)fetchCheckoutPromos:(CartDataModel *)cartData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure;
//Set addresses and shipping methods
- (void)setUpdatedAddressShippingMethodsService:(CartDataModel *)cartData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure;
//Set checkout promo
- (void)setCheckoutPromos:(CartDataModel *)cartData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure;
//Set payment method
- (void)setPaymentMethodService:(CartDataModel *)cartData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure;
//Set checkout order
- (void)setCheckoutOrderService:(CartDataModel *)cartData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure;
//Coupon code
- (void)applyCouponCode:(CartDataModel *)cartData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure;
//remove
- (void)removeCouponCode:(CartDataModel *)cartData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure;
//cybersource
- (void)cyberSourcePaymentData:(CartDataModel *)cartData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure;
//Remove coupon code
- (void)clearCart:(CartDataModel *)cartData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure;
//Billing address
- (void)setUpdatedBillingAddressMethodsService:(CartDataModel *)cartData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure;
- (void)fetchPaymentMethodsOnService:(CartDataModel *)cartData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure;
@end
