//
//  ProfileService.m
//  GoNatuur
//
//  Created by Monika on 8/29/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "ProfileService.h"
#import "ProfileModel.h"

static NSString *kChangePassword=@"customers/me/password";
static NSString *kCountryCode=@"directory/countries";
static NSString *kUserProfile=@"customers/me";

@implementation ProfileService

#pragma mark - Change password service
- (void)changePasswordService:(ProfileModel *)profileData onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"currentPassword" : profileData.currentPassword,
                                 @"newPassword" : profileData.changePassword
                                 };
    [super put:kChangePassword parameters:parameters success:success failure:failure];
}
#pragma mark - end

#pragma mark - Get country code service
- (void)getCountryCodeService:(ProfileModel *)profileData onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure {
    [super get:kCountryCode parameters:nil onSuccess:success onFailure:failure];
}
#pragma mark - end

#pragma mark - Get user service
- (void)getUserProfileServiceData:(ProfileModel *)profileData onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure {
    [super get:kUserProfile parameters:nil onSuccess:success onFailure:failure];
}
#pragma mark - end

#pragma mark - Get user service
- (void)saveAndUpdateAddress:(ProfileModel *)profileData onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"currentPassword" : profileData.currentPassword,
                                 @"newPassword" : profileData.changePassword
                                 };
    [super post:kUserProfile parameters:parameters success:success failure:failure];
}
#pragma mark - end
@end
