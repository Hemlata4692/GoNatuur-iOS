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
static NSString *kMArkNotificationRead=@"ranosys/notifications/markAsReaded";


@implementation NotificationService

#pragma mark - Fetch notification list
- (void)getUserNotificationData:(NotificationDataModel *)notiData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
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
                                                                   @"direction":DESC
                                                                   }
                                                                 ],
                                                         @"page_size" : @"10",
                                                         @"current_page" : notiData.pageCount
                                                         }
                                   };
    NSLog(@"notification list request %@",parameters);
    [super post:kNotificationList parameters:parameters success:success failure:failure];
}
#pragma mark - end

#pragma mark - Mark as read
- (void)markNotification:(NotificationDataModel *)notiData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"notificationId":notiData.notificationId,
                                                 @"status" : @"1",
                                 };
    
    NSLog(@"notification read request %@",parameters);
    [super post:kMArkNotificationRead parameters:parameters success:success failure:failure];
}
#pragma mark - end
@end
