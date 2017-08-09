//
//  LoginService.m
//  GoNatuur
//
//  Created by Hemlata Khajanchi on 24/07/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//


static NSString *kAuthorizationToken=@"integration/admin/token";
static NSString *kLogin=@"ranosys/customer/customerLogin";


#import "LoginService.h"
#import "LoginModel.h"

@implementation LoginService

#pragma mark - Get authorization token
- (void)getAccessToken:(LoginModel *)accessToken onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure {
    [super get:@"storeViews" parameters:nil onSuccess:success onFailure:failure];
}
#pragma mark - end

#pragma mark - Login user service
- (void)loginUser:(LoginModel *)loginData onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"email" : loginData.email,
                                     @"password" : loginData.password,
                                     @"isSocialLogin" : loginData.isSocialLogin,
                                     @"countryCode" : [ConstantCode localeCountryCode]};
    [super post:kLogin parameters:parameters success:success failure:failure];
}
#pragma mark - end

#pragma mark - Login as guest user service
- (void)loginGuestUser:(void (^)(id))success onFailure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"countryCode" : [ConstantCode localeCountryCode]};
    [super post:kLogin parameters:parameters success:success failure:failure];
}
#pragma mark - end
@end
