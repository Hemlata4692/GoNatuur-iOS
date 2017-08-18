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
static NSString *kForgotPassword=@"ranosys/customer/forgotPassword";
static NSString *kResetPassword=@"ranosys/customer/resetPassword";

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
    [super post:kSaveDeviceToken parameters:parameters success:success failure:failure];
}
#pragma mark - end

#pragma mark - SignUp user service
- (void)signUpUserService:(LoginModel *)loginData onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure {
    [UserDefaultManager removeValue:@"Authorization"];
    NSDictionary *parameters;
    if ([loginData.isSocialLogin isEqual:@0]) {
        parameters = @{@"customer" : @{@"email" : loginData.email,
                                       @"firstname" : @"John",
                                       @"lastname" : @"Doe"
                                       },
                       @"password" : loginData.password,
                       @"isSocial":loginData.isSocialLogin,
                       @"profileImageUrl":@"",
                       @"socialType":[NSNumber numberWithInt:myDelegate.selectedLoginType],
                       @"socialUserId":@"",
                       @"redirectUrl":@""
                       };
    }
    else {
        parameters = @{@"customer" : @{@"email" : loginData.email,
                                       @"firstname" : @"John",
                                       @"lastname" : @"Doe"
                                       },
                       @"isSocial":loginData.isSocialLogin,
                       @"profileImageUrl":loginData.profilePicture,
                       @"socialType":[NSNumber numberWithInt:myDelegate.selectedLoginType],
                       @"socialUserId":loginData.socialUserId,
                       @"redirectUrl":@""
                       };
    }
    NSLog(@"sign up request social %@",parameters);
    [super post:kSignUp parameters:parameters success:success failure:failure];
}
#pragma mark - end

#pragma mark - Forgot password service
- (void)forgotPasswordService:(LoginModel *)loginData onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure {
    [UserDefaultManager removeValue:@"Authorization"];
    NSDictionary *parameters = @{@"email" : loginData.email,
                                 @"template" : @"email"
                                 };
    [super post:kForgotPassword parameters:parameters success:success failure:failure];
}
#pragma mark - end

#pragma mark - Reset password service
- (void)resetPasswordService:(LoginModel *)loginData onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure {
    [UserDefaultManager removeValue:@"Authorization"];
    NSDictionary *parameters = @{@"email" : loginData.email,
                                 @"password" : loginData.password,
                                 @"requestOTP" : loginData.otpNumber
                                 };
    [super post:kResetPassword parameters:parameters success:success failure:failure];
}
#pragma mark - end
@end
