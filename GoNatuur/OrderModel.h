//
//  OrderModel.h
//  GoNatuur
//
//  Created by Monika on 9/8/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderModel : NSObject
//Order listing
@property (strong, nonatomic) NSString *purchaseOrderId;
@property (strong, nonatomic) NSString *orderDate;
@property (strong, nonatomic) NSString *shippingAddress;
@property (strong, nonatomic) NSString *BillingAddress;
@property (strong, nonatomic) NSString *orderStatus;
@property (strong, nonatomic) NSString *orderPrice;
@property (strong, nonatomic) NSString *currencyCode;
@property (strong, nonatomic) NSString *billingAddressId;
@property (strong, nonatomic) NSMutableArray *orderListingArray;

//Singleton instanse
+ (instancetype)sharedUser;

//Order listing data
- (void)getOrderListing:(void (^)(OrderModel *))success onfailure:(void (^)(NSError *))failure;

@end
