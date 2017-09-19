//
//  ShareDataModel.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 19/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "ShareDataModel.h"
#import "ConnectionManager.h"

@implementation ShareDataModel
@synthesize imageURL;
@synthesize deeplinkURL;
@synthesize name;
@synthesize productDescription;

#pragma mark - Shared instance
+ (instancetype)sharedUser {
    static ShareDataModel *userData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userData = [[[self class] alloc] init];
    });
    return userData;
}
#pragma mark - end

#pragma mark - Earn points on share
- (void)getShareDataWebView:(void (^)(ShareDataModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] shareProductData:self onSuccess:^(ShareDataModel *userData) {
        if (success) {
            success (userData);
        }
    } onFailure:^(NSError *error) {
    }];
}
#pragma mark - end
@end
