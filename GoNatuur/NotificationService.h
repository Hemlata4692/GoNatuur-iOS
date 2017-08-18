//
//  NotificationService.h
//  GoNatuur
//
//  Created by Ranosys-Mac on 16/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NotificationDataModel;

@interface NotificationService : Webservice

//Fetch notifications
- (void)getUserNotificationData:(NotificationDataModel *)searchData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure;
//Mark as read
- (void)markNotification:(NotificationDataModel *)notiData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure;
@end
