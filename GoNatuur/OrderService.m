//
//  OrderService.m
//  GoNatuur
//
//  Created by Monika on 9/8/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "OrderService.h"
#import "OrderModel.h"

static NSString *kOrderListing=@"orders";
static NSString *kCancelOrder=@"ranosys/orders";
static NSString *kGetTicketOption=@"ranosys/customer/getOrderTicketOptions?orderId=";
static NSString *kOrderInvoice=@"invoices";
static NSString *kTrackShippment=@"shipments";

@implementation OrderService

#pragma mark - Get order listing
- (void)getOrderListing:(OrderModel *)orderData onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure {
    NSDictionary *parameters;
    if ([orderData.isOrderDetailService isEqualToString:@"1"]) {
        parameters = @{@"searchCriteria" : @{@"filter_groups" : @[
                                                                   @{
                                                                       @"filters":@[
                                                                               @{@"field":@"entity_id",
                                                                                 @"value":orderData.orderId,
                                                                                 @"condition_type": @"eq"
                                                                                 }
                                                                               ]
                                                                       }
                                                                   ],
                                                           @"sort_orders" : @[
                                                                   @{@"field":@"created_at",
                                                                     @"direction":DESC
                                                                     }
                                                                   ],
                                                           @"page_size" : orderData.pageSize,
                                                           @"current_page" : orderData.currentPage
                                                           }
                                     };
        DLog(@"order detail request %@",parameters);
    }
    else {
        parameters = @{@"searchCriteria" : @{@"filter_groups" : @[
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
                                                                 @"direction":DESC
                                                                 }
                                                               ],
                                                       @"page_size" : orderData.pageSize,
                                                       @"current_page" : orderData.currentPage
                                                       }
                                 };
        DLog(@"order list request %@",parameters);
    }
    
    [super post:kOrderListing parameters:parameters success:success failure:failure];
}
#pragma mark - end

#pragma mark - Cancel order
- (void)cancelOrderService:(OrderModel *)orderData onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure {
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
                                                                 @"direction":DESC
                                                                 }
                                                               ],
                                                       @"page_size" : @"0",
                                                       @"current_page" : @"0"
                                                       }
                                 };
    NSLog(@"order list request %@",parameters);
    [super post:[NSString stringWithFormat:@"%@/%@/cancel",kCancelOrder,orderData.purchaseOrderId] parameters:parameters success:success failure:failure];
}
#pragma mark - end

#pragma mark - Get ticket option
- (void)getTicketOption:(OrderModel *)orderData onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure {
    [super get:[NSString stringWithFormat:@"%@%@",kGetTicketOption,orderData.orderId] parameters:nil onSuccess:success onFailure:failure];
}
#pragma mark - end

#pragma mark - Get order invoice
- (void)getOrderInvoice:(OrderModel *)orderData onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"searchCriteria" : @{@"filter_groups" : @[
                                                               @{
                                                                   @"filters":@[
                                                                           @{@"field":@"order_id",
                                                                             @"value":orderData.orderId,
                                                                             @"condition_type": @"eq"
                                                                             }
                                                                           ]
                                                                   }
                                                               ],
                                                       @"sort_orders" : @[
                                                               @{@"field":@"entity_id",
                                                                 @"direction":DESC
                                                                 }
                                                               ],
                                                       @"page_size" : @"0",
                                                       @"current_page" : @"0"
                                                       }
                                 };
    NSLog(@"order invoice request %@",parameters);
    if (orderData.isTrackShippment) {
        [super post:kTrackShippment parameters:parameters success:success failure:failure];
    }
    else {
        [super post:kOrderInvoice parameters:parameters success:success failure:failure];
    }
}
#pragma mark - end
@end
