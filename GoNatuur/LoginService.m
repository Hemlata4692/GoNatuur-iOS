//
//  LoginService.m
//  GoNatuur
//
//  Created by Hemlata Khajanchi on 24/07/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "LoginService.h"
#import "LoginModel.h"

static NSString *kAuthorizationToken=@"integration/admin/token";
static NSString *kLogin=@"ranosys/customer/customerLogin";
static NSString *kLoginAsGuest=@"ranosys/customer/guestLogin";
static NSString *kCMSPage=@"cmsPage/";
static NSString *kSaveDeviceToken=@"ranosys/saveDeviceToken";
static NSString *kSignUp=@"ranosys/customer/customerSignup";

@implementation LoginService

#pragma mark - Get authorization token
- (void)getAccessToken:(LoginModel *)accessToken onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure {
    [super get:@"storeViews" parameters:nil onSuccess:success onFailure:failure];
}
#pragma mark - end

#pragma mark - Login user service
- (void)loginUser:(LoginModel *)loginData onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure {
    [UserDefaultManager removeValue:@"Authorization"];
    NSDictionary *parameters = @{@"email" : loginData.email,
                                     @"password" : loginData.password,
                                     @"isSocialLogin" : loginData.isSocialLogin,
                                     @"countryCode" : [ConstantCode localeCountryCode]};
    [super post:kLogin parameters:parameters success:success failure:failure];
}
#pragma mark - end

#pragma mark - Login as guest user service
- (void)loginGuestUser:(void (^)(id))success onFailure:(void (^)(NSError *))failure {
    [UserDefaultManager removeValue:@"Authorization"];
    NSDictionary *parameters = @{@"countryCode" : [ConstantCode localeCountryCode]};
    [super post:kLoginAsGuest parameters:parameters success:success failure:failure];
}
#pragma mark - end

#pragma mark - CMS page service
- (void)CMSPageService:(LoginModel *)loginData onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure {
    [UserDefaultManager setValue:@"9e28chln10yp8bkporq87jkw8vrgi6f3" key:@"Authorization"];
    [super get:[NSString stringWithFormat:@"%@%@",kCMSPage,loginData.cmsPageType] parameters:nil onSuccess:success onFailure:failure];
}
#pragma mark - end

#pragma mark - Save device token service
- (void)saveDeviceTokenService:(LoginModel *)loginData onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"customerId" : [UserDefaultManager getValue:@"userId"],
                                 @"deviceType" : [NSNumber numberWithInt:2],
                                 @"deviceToken" : @"testtoken"};
    [UserDefaultManager setValue:@"9e28chln10yp8bkporq87jkw8vrgi6f3" key:@"Authorization"];
    [super post:kSaveDeviceToken parameters:parameters success:success failure:failure];
}
#pragma mark - end

#pragma mark - SignUp user service
- (void)signUpUserService:(LoginModel *)loginData onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure {
    [UserDefaultManager removeValue:@"Authorization"];
    NSDictionary *parameters = @{@"customer" : @{@"email" : loginData.email,
                                                 @"firstname" : loginData.firstName,
                                                 @"lastname" : loginData.lastName
                                         },
                                 @"password" : loginData.password
                                };
    [super post:kSignUp parameters:parameters success:success failure:failure];
}
#pragma mark - end
@end
