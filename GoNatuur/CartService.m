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
- (void)getCartListing:(CartDataModel *)cartData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    [self get:kCartListing parameters:nil onSuccess:success onFailure:failure];
}
@end
