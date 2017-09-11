//
//  OrderService.m
//  GoNatuur
//
//  Created by Monika on 9/8/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "OrderService.h"
static NSString *kOrderListing=@"orders";

@implementation OrderService

#pragma mark - Get order listing
- (void)getOrderListing:(OrderModel *)orderData onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"searchCriteria" : @{@"filter_groups" : @[
                                                               @{
                                                                   @"filters":@[
                                                                           @{@"field":@"customer_id",
                                                                             @"value":[UserDefaultManager getValue:@"userId"],
                                                                             @"condition_type": @"eq"
                                                                             }
                                                                           ]
                                                                   }
                                                               ],
                                                       @"sort_orders" : @[
                                                               @{@"field":@"created_at",
                                                                 @"direction":@"DESC"
                                                                 }
                                                               ],
                                                       @"page_size" : @"0",
                                                       @"current_page" : @"0"
                                                       }
                                 };
    NSLog(@"order list request %@",parameters);
    [super post:kOrderListing parameters:parameters success:success failure:failure];
}
#pragma mark - end

@end
