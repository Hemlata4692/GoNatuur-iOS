//
//  LoginModel.m
//  GoNatuur
//
//  Created by Hemlata Khajanchi on 24/07/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "LoginModel.h"
#import "ConnectionManager.h"

@implementation LoginModel

#pragma mark - Shared instance
+ (instancetype)sharedUser{
    static LoginModel *loginUser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loginUser = [[[self class] alloc] init];
    });
    
    return loginUser;
}
#pragma mark - end

#pragma mark - Get authorization token
- (void)accessToken:(void (^)(LoginModel *))success onfailure:(void (^)(NSError *))failure {
    
    [[ConnectionManager sharedManager] getAccessToken:self onSuccess:^(LoginModel *userData) {
        if (success) {
            success (userData);
        }
    } onFailure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end

#pragma mark - Login user
- (void)loginUserOnSuccess:(void (^)(LoginModel *))success onfailure:(void (^)(NSError *))failure {
    
    [[ConnectionManager sharedManager] loginUser:self onSuccess:^(LoginModel *userData) {
        if (success) {

            success (userData);
        }
    } onFailure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end

#pragma mark - save device token
- (void)saveDeviceToken:(void (^)(LoginModel *))success onfailure:(void (^)(NSError *))failure {
    
    [[ConnectionManager sharedManager] sendDevcieToken:self onSuccess:^(LoginModel *userData) {
        if (success) {
            success (userData);
        }
    } onFailure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end

#pragma mark - Login as guest user
- (void)loginGuestUserOnSuccess:(void (^)(LoginModel *))success onfailure:(void (^)(NSError *))failure {
    
    [[ConnectionManager sharedManager] loginGuestUser:^(LoginModel *userData) {
        if (success) {
            
            success (userData);
        }
    } onFailure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end
@end
