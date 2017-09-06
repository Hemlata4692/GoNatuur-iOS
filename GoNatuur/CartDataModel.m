//
//  CartDataModel.m
//  GoNatuur
//
//  Created by Ranosys on 01/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "CartDataModel.h"
#import "ConnectionManager.h"

@implementation CartDataModel
@synthesize itemId;
@synthesize itemName;
@synthesize itemPrice;
@synthesize itemQty;
@synthesize itemSku;
@synthesize itemQuoteId;
@synthesize itemList;
@synthesize cartListResponse;

- (id)copyWithZone:(NSZone *)zone {
    CartDataModel *another = [[CartDataModel alloc] init];
    another.itemId= [self.itemId copyWithZone: zone];
    another.itemName= [self.itemName copyWithZone: zone];
    another.itemPrice= [self.itemPrice copyWithZone: zone];
    another.itemQty= [self.itemQty copyWithZone: zone];
    another.itemSku= [self.itemSku copyWithZone: zone];
    another.itemQuoteId= [self.itemQuoteId copyWithZone: zone];
    another.itemList= [self.itemList copyWithZone: zone];
    another.cartListResponse= [self.cartListResponse copyWithZone: zone];
    return another;
}

#pragma mark - Shared instance
+ (instancetype)sharedUser {
    static CartDataModel *data = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        data = [[[self class] alloc] init];
    });
    return data;
}
#pragma mark - end

#pragma mark - Cart listing data
- (void)getCartListingData:(void (^)(CartDataModel *))success onfailure:(void (^)(NSError *))failure{
    [[ConnectionManager sharedManager] getCartListing:self onSuccess:^(CartDataModel *userData) {
        if (success) {
            success (userData);
        }
    } onFailure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end

#pragma mark - Remove item from cart
- (void)removeItemFromCart:(void (^)(CartDataModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] removeItemFromCart:self onSuccess:^(CartDataModel *userData) {
        if (success) {
            success (userData);
        }
    } onFailure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end
@end
