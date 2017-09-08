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
static NSString *kGetShippmentMethod=@"carts/mine/estimate-shipping-methods";
static NSString *kFetchCheckoutPromos=@"ranosys/checkoutpromo";

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
    NSMutableArray *streetTempArray=[NSMutableArray new];
    for (NSString *street in cartData.shippingAddressDict[@"street"]) {
        [streetTempArray addObject:street];
    }
    NSDictionary *parameters = @{@"id" : [self getNumberValue:@"id" dictData:cartData.shippingAddressDict],
                                 @"region" : [cartData.shippingAddressDict[@"region"] objectForKey:@"region"],
                                 @"region_id" : [cartData.shippingAddressDict[@"region"] objectForKey:@"region_id"],
                                 @"region_code" : [cartData.shippingAddressDict[@"region"] objectForKey:@"region_code"],
                                 @"country_id" : [self checkStringNull:@"country_id" dictData:cartData.shippingAddressDict],
                                 @"company" : [self checkStringNull:@"company" dictData:cartData.shippingAddressDict],
                                 @"telephone" : cartData.shippingAddressDict[@"telephone"],
                                 @"fax" : [self checkStringNull:@"fax" dictData:cartData.shippingAddressDict],
                                 @"postcode" : cartData.shippingAddressDict[@"postcode"],
                                 @"city" : cartData.shippingAddressDict[@"city"],
                                 @"firstname" : cartData.shippingAddressDict[@"firstname"],
                                 @"lastname" : cartData.shippingAddressDict[@"lastname"],
                                 @"email" : cartData.shippingAddressDict[@"email"],
                                 @"customer_id": [self getNumberValue:@"customer_id" dictData:cartData.shippingAddressDict],
                                 @"street":[streetTempArray copy]
                                 };
    DLog(@"%@",parameters);
    [super post:kGetShippmentMethod parameters:@{@"address":[parameters copy]} success:success failure:failure];
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

- (NSNumber *)getNumberValue:(NSString *)key dictData:(NSDictionary *)dictData {
    if ((nil==dictData[key])||[dictData[key] isKindOfClass:[NSString class]]) {
        return [NSNumber numberWithInt:0];
    }
    return [NSNumber numberWithInt:[dictData[key] intValue]];
}

- (NSString *)checkStringNull:(NSString *)key dictData:(NSDictionary *)dictData {
    if (nil==dictData[key]) {
        return @"";
    }
    return dictData[key];
}

@end
