//
//  OrderModel.m
//  GoNatuur
//
//  Created by Monika on 9/8/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "OrderModel.h"
#import "ConnectionManager.h"

@implementation OrderModel
//Order listing
@synthesize purchaseOrderId;
@synthesize orderDate;
@synthesize shippingAddress;
@synthesize BillingAddress;
@synthesize orderStatus;
@synthesize orderPrice;
@synthesize orderListingArray;

#pragma mark - Shared instance
+ (instancetype)sharedUser{
    static OrderModel *orderData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        orderData = [[[self class] alloc] init];
    });
    return orderData;
}
#pragma mark - end

#pragma mark - Get order listing
- (void)getOrderListing:(void (^)(OrderModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] getOrderListing:self onSuccess:^(OrderModel *orderData) {
        if (success) {
            success (orderData);
        }
    } onFailure:^(NSError *error) {
        
    }];
}
#pragma mark - end

@end
