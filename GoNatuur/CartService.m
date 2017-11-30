//
//  CartService.m
//  GoNatuur
//
//  Created by Ranosys on 01/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "CartService.h"
#import "CartDataModel.h"

static NSString *kCartListing=@"ranosys/get-cart-quote/mine";
static NSString *kGetLogindShippmentMethod=@"carts/mine/shipping-methods";
static NSString *kFetchCheckoutPromos=@"ranosys/checkoutpromo";
static NSString *kcheckoutShippingInformationManagementV1=@"carts/mine/shipping-information";
static NSString *kGetCheckoutPromo=@"ranosys/setcheckoutpromo";
static NSString *kSetPaymentMethod=@"carts/mine/selected-payment-method";
static NSString *kSetCheckoutOrder=@"carts/mine/order";
static NSString *kApplyCouponCode=@"carts/mine/coupons/";
static NSString *kCyberSourcePayment=@"carts/mine/payment-information";
static NSString *kCyberSourceGuestPayment=@"payment-information";
static NSString *kGetshippingMethod=@"carts/mine/estimate-shipping-methods";
static NSString *kClearCart=@"carts/mine";
static NSString *kClearCartGuest=@"guest-carts";
static NSString *kCartGuestListing=@"ranosys/get-cart-quote/guest?";

@implementation CartService

#pragma mark - Fetch shipping methods
- (void)getShippingMethod:(CartDataModel *)cartData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    NSMutableDictionary *tempDict=[[self setAddressMethod:[cartData.shippingAddressDict copy]] mutableCopy];
    [tempDict setObject:[NSNumber numberWithInt:0] forKey:@"same_as_billing"];
    NSDictionary *parameters = @{@"address" : [tempDict copy]};
    DLog(@"%@",parameters);
    
    if ((nil==[UserDefaultManager getValue:@"userId"])){
         [self post:[NSString stringWithFormat:@"guest-carts/%@/estimate-shipping-methods",[UserDefaultManager getValue:@"quoteId"]] parameters:parameters success:success failure:failure];
    }
    else {
        [self post:kGetshippingMethod parameters:parameters success:success failure:failure];
    }
}

#pragma mark - Fetch cart listing
- (void)getCartListing:(CartDataModel *)cartData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    if ((nil==[UserDefaultManager getValue:@"userId"])) {
         NSDictionary *parameters = @{@"quoteId" : [UserDefaultManager getValue:@"quoteId"]};
        //https://dev.gonatuur.com/en/rest/en/V1/ranosys/get-cart-quote/guest?&quoteId=7cd19b9fa980b338fa0cf666005bb5ad
        [self get:kCartGuestListing parameters:parameters onSuccess:success onFailure:failure];
    }
    else {
        [self post:kCartListing parameters:nil success:success failure:failure];
    }
}

#pragma mark - Remove item from cart
- (void)removeItemFromCart:(CartDataModel *)cartData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    if ((nil==[UserDefaultManager getValue:@"userId"])){
        [super deleteService:[NSString stringWithFormat:@"guest-carts/%@/items/%@",cartData.itemQuoteId,cartData.itemId] parameters:nil isBoolean:true success:success failure:failure];
    }
    else {
        [super deleteService:[NSString stringWithFormat:@"carts/mine/items/%@",cartData.itemId] parameters:nil isBoolean:true success:success failure:failure];
    }
    
}
#pragma mark - Fetch shippment methods
- (void)fetchShippmentMethods:(CartDataModel *)cartData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    if ((nil==[UserDefaultManager getValue:@"userId"])){
        [self get:[NSString stringWithFormat:@"guest-carts/%@/shipping-methods",[UserDefaultManager getValue:@"quoteId"]] parameters:nil onSuccess:success onFailure:failure];
    }
    else {
        [self get:kGetLogindShippmentMethod parameters:nil onSuccess:success onFailure:failure];
    }
}
#pragma mark - end

#pragma mark - Fetch checkout promos
- (void)fetchCheckoutPromos:(CartDataModel *)cartData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    
    //    if ((nil==[UserDefaultManager getValue:@"userId"])){
    //        [super deleteService:[NSString stringWithFormat:@"guest-carts/%@/items/%@",cartData.itemQuoteId,cartData.itemId] parameters:nil isBoolean:true success:success failure:failure];
    //    }
    //    else {
    [self get:kFetchCheckoutPromos parameters:nil onSuccess:success onFailure:failure];
    //    }
}
#pragma mark - end

#pragma mark - Set checkout promo
- (void)setCheckoutPromos:(CartDataModel *)cartData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{
                                 @"promoPoints":cartData.promoPoints,
                                 @"promoDiscountValue":cartData.promoDiscountValue
                                 };
    DLog(@"%@",parameters);
    [super post:kGetCheckoutPromo parameters:parameters success:success failure:failure];
}
#pragma mark - end

#pragma mark - Apply coupon code
- (void)applyCouponCode:(CartDataModel *)cartData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    if ((nil==[UserDefaultManager getValue:@"userId"])){
        [self put:[NSString stringWithFormat:@"guest-carts/%@/%@/%@",[UserDefaultManager getValue:@"quoteId"],@"coupons",cartData.couponCode] parameters:nil success:success failure:failure];
    }
    else {
        [self put:[NSString stringWithFormat:@"%@%@",kApplyCouponCode,cartData.couponCode] parameters:nil success:success failure:failure];
    }
}
#pragma mark - end

#pragma mark - Remove coupon code
- (void)removeCouponCode:(CartDataModel *)cartData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    if ((nil==[UserDefaultManager getValue:@"userId"])){
         [super deleteService:[NSString stringWithFormat:@"guest-carts/%@/%@",[UserDefaultManager getValue:@"quoteId"],@"coupons"] parameters:nil isBoolean:true success:success failure:failure];
    }
    else {
          [super deleteService:[NSString stringWithFormat:@"%@",kApplyCouponCode] parameters:nil isBoolean:true success:success failure:failure];
    }
}
#pragma mark - end

#pragma mark - Set payment method
- (void)setPaymentMethodService:(CartDataModel *)cartData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    NSDictionary *parameters;
    DLog(@"%@",parameters);
    
//    {"email":"yuu@tgh.com","paymentMethod":{"method":"paypal_express"}}
//    POST https://dev.gonatuur.com/en/rest/en/V1/guest-carts/43bd13fe1cf3ec7f4791f9eebedca89e/set-payment-informationhttp/1.1
    
    if ((nil==[UserDefaultManager getValue:@"userId"])){
        parameters = @{@"email":cartData.email,
                                     @"paymentMethod":@{
                                             @"method":cartData.paymentMethod
                                             }
                                     };
        [self put:[NSString stringWithFormat:@"guest-carts/%@/%@",[UserDefaultManager getValue:@"quoteId"],@"set-payment-information"] parameters:parameters success:success failure:failure];
    }
    else {
       parameters = @{  @"method":@{
                                             @"method":cartData.paymentMethod
                                             }
                                     };
      [super put:kSetPaymentMethod parameters:parameters success:success failure:failure];
    }
}
#pragma mark - end

#pragma mark - Set checkout order
- (void)setCheckoutOrderService:(CartDataModel *)cartData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{
                                 @"paymentMethod":@{
                                         @"method":cartData.paymentMethod
                                         }
                                 };
    DLog(@"%@",parameters);
    [super put:kSetCheckoutOrder parameters:parameters success:success failure:failure];
}
#pragma mark - end


#pragma mark - Cybersource
- (void)cyberSourcePaymentData:(CartDataModel *)cartData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{
                                 @"billingAddress":@{
                                         @"city":cartData.city,@"countryId":cartData.countryId,@"customerId":[UserDefaultManager getValue:@"userId"],@"firstname":cartData.firstName,@"lastname":cartData.lastName,@"postcode":cartData.postcode,@"region":cartData.region,@"regionCode":cartData.regionCode,@"saveInAddressBook":cartData.saveCard,@"street":cartData.street,@"telephone":cartData.telephone
                                         
                                         },@"email":cartData.email,@"paymentMethod":@{@"additional_data":@{@"cc_cid":cartData.ccId,@"cc_number":cartData.ccNumber,@"cc_type":cartData.ccType,@"expiration":@"",@"expiration_yr":cartData.expirationYear,@"save_card":cartData.saveCard,@"subscription_id":cartData.subscriptionID},@"method":cartData.method}};
    
   

    DLog(@"kCyberSourcePayment %@",parameters);
    if ((nil==[UserDefaultManager getValue:@"userId"])){
        [super postPayment:[NSString stringWithFormat:@"guest-carts/%@/%@",[UserDefaultManager getValue:@"quoteId"],kCyberSourceGuestPayment] parameters:parameters isBoolean:true success:success failure:success];
    }
    else {
        [super postPayment:kCyberSourcePayment parameters:parameters isBoolean:true success:success failure:failure];
    }
}
#pragma mark - end

#pragma mark - Set addresses and shipping methods
- (void)setUpdatedAddressShippingMethodsService:(CartDataModel *)cartData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    if ([cartData.selectedShippingMethod containsString:@"_"]) {
        cartData.selectedShippingMethod=[[cartData.selectedShippingMethod componentsSeparatedByString:@"_"] objectAtIndex:0];
    }
    NSDictionary *parameters = @{@"addressInformation" : @{
                                         @"shipping_address":[self setAddressMethod:[cartData.shippingAddressDict copy]],
                                         @"billing_address":[self setAddressMethod:[cartData.billingAddressDict copy]],
                                         @"shipping_method_code":cartData.selectedShippingMethod,
                                         @"shipping_carrier_code":cartData.selectedShippingMethod
                                         }
                                 };
    DLog(@"%@",parameters);
    if ((nil==[UserDefaultManager getValue:@"userId"])){
        [super post:[NSString stringWithFormat:@"guest-carts/%@/shipping-information",[UserDefaultManager getValue:@"quoteId"]] parameters:parameters success:success failure:failure];
    }
    else {
        [super post:kcheckoutShippingInformationManagementV1 parameters:parameters success:success failure:failure];
    }
    
}
#pragma mark - end

- (NSDictionary *)setAddressMethod:(NSDictionary *)tempDict {
    NSMutableArray *streetTempArray=[NSMutableArray new];
    for (NSString *street in tempDict[@"street"]) {
        [streetTempArray addObject:street];
    }
    if (streetTempArray.count<1) {
        [streetTempArray addObject:@""];
    }
    
    NSDictionary *parameters = @{@"region" : [UserDefaultManager checkStringNull:@"region" dictData:tempDict],
                                 @"region_id" : [UserDefaultManager getNumberValue:[tempDict objectForKey:@"region_id"] dictData:tempDict],
                                 @"region_code" : [UserDefaultManager checkStringNull:@"region_code" dictData:tempDict],
                                 @"country_id" : [UserDefaultManager checkStringNull:@"country_id" dictData:tempDict],
                                 @"company" : [UserDefaultManager checkStringNull:@"company" dictData:tempDict],
                                 @"telephone" : [UserDefaultManager checkStringNull:@"telephone" dictData:tempDict],
                                 @"fax" : [UserDefaultManager checkStringNull:@"fax" dictData:tempDict],
                                 @"postcode" : [UserDefaultManager checkStringNull:@"postcode" dictData:tempDict],
                                 @"city" : [UserDefaultManager checkStringNull:@"city" dictData:tempDict],
                                 @"firstname" : [UserDefaultManager checkStringNull:@"firstname" dictData:tempDict],
                                 @"lastname" : [UserDefaultManager checkStringNull:@"lastname" dictData:tempDict],
                                 @"email" : [UserDefaultManager checkStringNull:@"email" dictData:tempDict],
                                 @"customer_id": (nil!=[UserDefaultManager getValue:@"userId"]?[UserDefaultManager getValue:@"userId"]:[NSNumber numberWithInt:0]),
                                 @"street":[streetTempArray copy]
                                 };
    return parameters;
}
#pragma mark - end

#pragma mark - Remove coupon code
- (void)clearCart:(CartDataModel *)cartData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    if ((nil==[UserDefaultManager getValue:@"userId"])){
         [super postPayment:kClearCartGuest parameters:nil isBoolean:true success:success failure:success];
    }
    else {
        [super postPayment:kClearCart parameters:nil isBoolean:true success:success failure:failure];
    }
}
#pragma mark - end
@end
