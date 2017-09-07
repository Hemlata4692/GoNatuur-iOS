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
@end
