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
@end
