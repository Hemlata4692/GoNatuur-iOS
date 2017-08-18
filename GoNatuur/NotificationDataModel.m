//
//  NotificationDataModel.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 16/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "NotificationDataModel.h"
#import "ConnectionManager.h"

@implementation NotificationDataModel
@synthesize notificationId;
@synthesize notificationMessage;
@synthesize notificationStatus;
@synthesize notificationType;//to be redirected on which screen
@synthesize targetId;// it will be the id of resective details, listing, category screen
@synthesize notificationListArray;
@synthesize totalCount;
@synthesize pageCount;
//1 => 'product_listing',
//2 => 'product_details',
//3 => 'events_listing',
//4 => 'events_details',
//5 => 'order_confirmation'

#pragma mark - Shared instance
+ (instancetype)sharedUser{
    static NotificationDataModel *data = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        data = [[[self class] alloc] init];
    });
    return data;
}
#pragma mark - end

#pragma mark - Notification lsit
- (void)getUserNotification:(void (^)(NotificationDataModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] getNotificationListingData:self onSuccess:^(NotificationDataModel *userData) {
        if (success) {
            success (userData);
        }
    } onFailure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end

#pragma mark - Mark as read
- (void)markNotificationRead:(void (^)(NotificationDataModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] markNotificationAsRead:self onSuccess:^(NotificationDataModel *userData) {
        if (success) {
            success (userData);
        }
    } onFailure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end
@end
