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

#pragma mark - Save user service
- (void)saveUserProfileServiceData:(ProfileModel *)profileData onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure {    
    NSDictionary *parameters = @{@"customer" : @{@"email" : profileData.email,
                                                                 @"lastname" : profileData.lastName,
                                                                 @"firstname" : profileData.firstName,
                                                                 @"id":[UserDefaultManager getValue:@"userId"],
                                                                 @"website_id":profileData.websiteId,
                                                   @"store_id":profileData.storeId,
                                                 @"group_id":profileData.groupId,
                                                                 @"addresses" : profileData.addressArray,
                                                                 @"custom_attributes":profileData.customAttributeArray
                                                                 }
                                                               
                                 };
    DLog(@"save user profile request %@",parameters);
    [super put:kUserProfile parameters:parameters success:success failure:failure];
}

#pragma mark - end
@end
