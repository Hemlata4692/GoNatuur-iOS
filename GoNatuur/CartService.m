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
    
//    if ((nil==[UserDefaultManager getValue:@"userId"])){
//        [super deleteService:[NSString stringWithFormat:@"guest-carts/%@/items/%@",cartData.itemQuoteId,cartData.itemId] parameters:nil isBoolean:true success:success failure:failure];
//    }
//    else {
    [super post:kGetLogindShippmentMethod parameters:nil success:success failure:failure];
//    }
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

#pragma mark - Set addresses and shipping methods
- (void)setUpdatedAddressShippingMethodsService:(CartDataModel *)cartData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"addressInformation" : @{
                                         @"shipping_address":[self setAddressMethod:[cartData.shippingAddressDict copy]],
                                         @"billing_address":[self setAddressMethod:[cartData.billingAddressDict copy]],
                                         @"shipping_method_code":cartData.selectedShippingMethod,
                                         @"shipping_carrier_code":cartData.selectedShippingMethod
                                         }
                                 };
        DLog(@"%@",parameters);
    [super post:kcheckoutShippingInformationManagementV1 parameters:parameters success:success failure:failure];
}
#pragma mark - end

- (NSDictionary *)setAddressMethod:(NSDictionary *)tempDict {
    NSMutableArray *streetTempArray=[NSMutableArray new];
    for (NSString *street in tempDict[@"street"]) {
        [streetTempArray addObject:street];
    }
    NSDictionary *parameters = @{@"id" : [UserDefaultManager getNumberValue:@"id" dictData:tempDict],
                                 @"region" : [tempDict[@"region"] objectForKey:@"region"],
                                 @"region_id" : [tempDict[@"region"] objectForKey:@"region_id"],
                                 @"region_code" : [tempDict[@"region"] objectForKey:@"region_code"],
                                 @"country_id" : [UserDefaultManager checkStringNull:@"country_id" dictData:tempDict],
                                 @"company" : [UserDefaultManager checkStringNull:@"company" dictData:tempDict],
                                 @"telephone" : tempDict[@"telephone"],
                                 @"fax" : [UserDefaultManager checkStringNull:@"fax" dictData:tempDict],
                                 @"postcode" : tempDict[@"postcode"],
                                 @"city" : tempDict[@"city"],
                                 @"firstname" : tempDict[@"firstname"],
                                 @"lastname" : tempDict[@"lastname"],
                                 @"email" : tempDict[@"email"],
                                 @"customer_id": [UserDefaultManager getValue:@"userId"],
                                 @"street":[streetTempArray copy]
                                 };
    return parameters;
}
@end
