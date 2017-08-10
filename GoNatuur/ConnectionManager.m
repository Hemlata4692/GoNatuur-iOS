//
//  ConnectionManager.m
//  GoNatuur
//
//  Created by Hemlata Khajanchi on 24/07/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "ConnectionManager.h"
#import "LoginService.h"
#import "LoginModel.h"

@implementation ConnectionManager

#pragma mark - Shared instance

+ (instancetype)sharedManager {
    static ConnectionManager *connectionManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        connectionManager = [[[self class] alloc] init];
    });
    return connectionManager;
}
#pragma mark - end

#pragma mark - Community code
- (void)getAccessToken:(LoginModel *)userData onSuccess:(void (^)(LoginModel *userData))success onFailure:(void (^)(NSError *))failure {
    LoginService *authToken = [[LoginService alloc] init];
    //parse data from server response and store in datamodel
    [authToken getAccessToken:userData onSuccess:^(id response) {

        
        success(response);
    } onFailure:^(NSError *error) {
        failure(error);
    }] ;
}
#pragma mark - end

#pragma mark - Login user
- (void)loginUser:(LoginModel *)userData onSuccess:(void (^)(LoginModel *userData))success onFailure:(void (^)(NSError *))failure {
    LoginService *loginService = [[LoginService alloc] init];
    [loginService loginUser:userData onSuccess:^(id response) {
//Parse data from server response and store in datamodel
        
        userData.userId=[[[response objectAtIndex:0] objectForKey:@"customer"] objectForKey:@"entity_id"];
        userData.accessToken=[[response objectAtIndex:0] objectForKey:@"api_key"];
        userData.followCount=[[response objectAtIndex:0] objectForKey:@"follow_count"];
        userData.notificationsCount=[[response objectAtIndex:0] objectForKey:@"notifications_count"];
        userData.quoteId=[[response objectAtIndex:0] objectForKey:@"quote_id"];
        userData.quoteCount=[[response objectAtIndex:0] objectForKey:@"quote_count"];
         userData.wishlistCount=[[response objectAtIndex:0] objectForKey:@"wishlist_count"];
        
        success(userData);
    } onFailure:^(NSError *error) {
        failure(error);
    }] ;
}
#pragma mark - end

#pragma mark - Login as guest user
- (void)loginGuestUser:(LoginModel *)userData onSuccess:(void (^)(id userData))success onFailure:(void (^)(NSError *))failure {
    LoginService *loginService = [[LoginService alloc] init];
    [loginService loginGuestUser:^(id response) {
        //Parse data from server response and store in datamodel
        userData.quoteId=[[response objectAtIndex:0] objectForKey:@"quote_id"];
        success(userData);
    } onFailure:^(NSError *error) {
        failure(error);
    }] ;
}
#pragma mark - end

#pragma mark - Send device token
- (void)sendDevcieToken:(LoginModel *)userData onSuccess:(void (^)(LoginModel *userData))success onFailure:(void (^)(NSError *))failure {

}

@end
