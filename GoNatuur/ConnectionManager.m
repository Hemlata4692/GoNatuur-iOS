//
//  ConnectionManager.m
//  GoNatuur
//
//  Created by Hemlata Khajanchi on 24/07/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "ConnectionManager.h"
#import "LoginService.h"

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
        NSMutableArray *dataArray=[response mutableCopy];
        NSString *code=[[dataArray objectAtIndex:0] objectForKey:@"code"];
//        userData.code = response[@"code"];
//        userData.baseUrl = response[@"url"];
//        [UserDefaultManager setValue:userData.baseUrl key:@"baseUrl"];
        success(response);
    } onFailure:^(NSError *error) {
        failure(error);
    }] ;
}
#pragma mark - end

#pragma mark - Login user
- (void)loginUser:(LoginModel *)userData onSuccess:(void (^)(LoginModel *userData))success onFailure:(void (^)(NSError *))failure {
//    LoginService *loginService = [[LoginService alloc] init];
//    [loginService loginUser:userData onSuccess:^(id response) {
        //parse data from server response and store in datamodel
//        userData.apiKey=response[@"ApiKey"];
//        userData.userId=response[@"UserID"];
//        userData.userName=response[@"Username"];
//        userData.userImage=response[@"UserAvatar"];
//        userData.userThumbnailImage=response[@"UserAvatarThumb"];
//        success(userData);
//    } onFailure:^(NSError *error) {
//        failure(error);
//    }] ;
}
#pragma mark - end

#pragma mark - Send device token
- (void)sendDevcieToken:(LoginModel *)userData onSuccess:(void (^)(LoginModel *userData))success onFailure:(void (^)(NSError *))failure {
//    LoginService *deviceToken = [[LoginService alloc] init];
//    [deviceToken saveDeviceToken:userData onSuccess:^(id response) {
//        //send device token to server for push notification
//        success(userData);
//    } onFailure:^(NSError *error) {
//        failure(error);
//    }] ;
}

@end
