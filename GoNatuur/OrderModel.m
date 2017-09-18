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
@synthesize isOrderInvoice;
@synthesize isTrackShippment;
@synthesize orderInvoiceArray;
@synthesize trackArray;
@synthesize trackNumber;

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
        failure(error);
    }];
}
#pragma mark - end

#pragma mark - Cancel order
- (void)cancelOrderService:(void (^)(OrderModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] cancelOrderService:self onSuccess:^(OrderModel *orderData) {
        if (success) {
            success (orderData);
        }
    } onFailure:^(NSError *error) {
        failure(error);
    }];
}
#pragma mark - end

#pragma mark - Get ticket option
- (void)getTicketOption:(void (^)(OrderModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] getTicketOption:self onSuccess:^(OrderModel *orderData) {
        if (success) {
            success (orderData);
        }
    } onFailure:^(NSError *error) {
        failure(error);
    }];
}
#pragma mark - end

#pragma mark - Get order invoice
- (void)getOrderInvoiceOnSuccess:(void (^)(OrderModel *))success onfailure:(void (^)(NSError *))failure {    
    [[ConnectionManager sharedManager] getOrderInvoice:self onSuccess:^(OrderModel *orderData) {
        if (success) {
            success (orderData);
        }
    } onFailure:^(NSError *error) {
        
    }];
}
#pragma mark - end
@end
