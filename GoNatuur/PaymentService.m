//
//  PaymentService.m
//  GoNatuur
//
//  Created by Ranosys on 19/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "PaymentService.h"
static NSString *kCardListing=@"ranosys/cybersource/getList";

@implementation PaymentService

#pragma mark- Get card listing
- (void)getCardListing:(PaymentModel *)orderData onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure {
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
                                                               @{@"field":@"card_id",
                                                                 @"direction":@"ASC"
                                                                 }
                                                               ],
                                                       @"page_size" : @"0",
                                                       @"current_page" : @"0"
                                                       }
                                 };
    NSLog(@"card list request %@",parameters);
    [super post:kCardListing parameters:parameters success:success failure:failure];
}
#pragma mark- end
@end
