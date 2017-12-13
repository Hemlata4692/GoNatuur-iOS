//
//  OrderService.h
//  GoNatuur
//
//  Created by Monika on 9/8/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OrderModel;

@interface OrderService : Webservice

//Get order listing
- (void)getOrderListing:(OrderModel *)orderData onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure;
//Cancel order
- (void)cancelOrderService:(OrderModel *)orderData onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure;
//Get ticket option
- (void)getTicketOption:(OrderModel *)orderData onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure;
// Get order invoice
- (void)getOrderInvoice:(OrderModel *)orderData onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure;
// Return order service
- (void)getOrderStatusReturnData:(OrderModel *)orderData onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure;
@end
