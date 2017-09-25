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
//Set checkout order
- (void)applyCouponCodeService:(CartDataModel *)cartData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure;
//Remove coupon code
- (void)removeCouponCodeService:(CartDataModel *)cartData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure;
@end
