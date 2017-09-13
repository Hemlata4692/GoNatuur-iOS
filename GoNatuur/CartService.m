//
//  CartService.m
//  GoNatuur
//
//  Created by Ranosys on 01/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "CartService.h"
#import "CartDataModel.h"

static NSString *kCartListing=@"carts/mine";
static NSString *kGetLogindShippmentMethod=@"carts/mine/shipping-methods";
static NSString *kFetchCheckoutPromos=@"ranosys/checkoutpromo";
static NSString *kcheckoutShippingInformationManagementV1=@"carts/mine/shipping-information";
static NSString *kGetCheckoutPromo=@"ranosys/setcheckoutpromo";

@implementation CartService

#pragma mark - Fetch cart listing
- (void)getCartListing:(CartDataModel *)cartData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    
    if ((nil==[UserDefaultManager getValue:@"userId"])){
        [self get:[NSString stringWithFormat:@"guest-carts/%@/items",[UserDefaultManager getValue:@"quoteId"]] parameters:nil onSuccess:success onFailure:failure];
    }
    else {
        [self get:kCartListing parameters:nil onSuccess:success onFailure:failure];
    }
}

#pragma mark - Remove item from cart
- (void)removeItemFromCart:(CartDataModel *)cartData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {

    if ((nil==[UserDefaultManager getValue:@"userId"])){
        [super deleteService:[NSString stringWithFormat:@"guest-carts/%@/items/%@",cartData.itemQuoteId,cartData.itemId] parameters:nil isBoolean:true success:success failure:failure];
    }
    else {
        [super deleteService:[NSString stringWithFormat:@"%@/items/%@",kCartListing,cartData.itemId] parameters:nil isBoolean:true success:success failure:failure];
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
@end
