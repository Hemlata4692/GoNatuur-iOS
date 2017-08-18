//
//  NotificationDataModel.h
//  GoNatuur
//
//  Created by Ranosys-Mac on 16/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationDataModel : NSObject
@property (strong, nonatomic) NSString *notificationId;
@property (strong, nonatomic) NSString *notificationMessage;
@property (strong, nonatomic) NSString *notificationStatus;
@property (strong, nonatomic) NSString *notificationType;
@property (strong, nonatomic) NSString *targetId;
@property (strong, nonatomic) NSString *totalCount;
@property (strong, nonatomic) NSNumber *pageCount;
@property (strong, nonatomic) NSMutableArray *notificationListArray;

//Singleton method
+ (instancetype)sharedUser;

//Fetch notifications
- (void)getUserNotification:(void (^)(NotificationDataModel *))success onfailure:(void (^)(NSError *))failure;

//Mark notification as read
- (void)markNotificationRead:(void (^)(NotificationDataModel *))success onfailure:(void (^)(NSError *))failure;
@end
