//
//  NotificationService.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 16/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "NotificationService.h"
#import "NotificationDataModel.h"

static NSString *kNotificationList=@"ranosys/notifications/getList";

@implementation NotificationService

#pragma mark - Fetch search keywords
- (void)getUserNotificationData:(NotificationDataModel *)searchData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"criteria" : @{@"filter_groups" : @[
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
                                                         @"page_size" : @"10",
                                                         @"current_page" : @"1"
                                                         }
                                   };
    NSLog(@"notification list request %@",parameters);
    //  [super post:kSearchSuggestions parameters:parameters success:success failure:failure];
    [super post:kNotificationList parameters:parameters success:success failure:failure];
}
#pragma mark - end
@end
