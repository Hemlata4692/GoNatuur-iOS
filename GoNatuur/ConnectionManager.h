//
//  ConnectionManager.h
//  GoNatuur
//
//  Created by Hemlata Khajanchi on 24/07/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LoginModel;
@class DashboardDataModel;

@interface ConnectionManager : NSObject

//Singleton method
+ (instancetype)sharedManager;
//Authentication token
- (void)getAccessToken:(LoginModel *)userData onSuccess:(void (^)(LoginModel *userData))success onFailure:(void (^)(NSError *))failure;
//Login user
- (void)loginUser:(LoginModel *)userData onSuccess:(void (^)(LoginModel *userData))success onFailure:(void (^)(NSError *))failure;
//Save device token
- (void)sendDevcieToken:(LoginModel *)userData onSuccess:(void (^)(LoginModel *userData))success onFailure:(void (^)(NSError *))failure;
//Login as guest user
- (void)loginGuestUser:(LoginModel *)userData onSuccess:(void (^)(id userData))success onFailure:(void (^)(NSError *))failure;
//CMS page service
- (void)CMSPageService:(LoginModel *)userData onSuccess:(void (^)(id userData))success onFailure:(void (^)(NSError *))failure;
//Get category listing
- (void)getCategoryListing:(DashboardDataModel *)userData onSuccess:(void (^)(DashboardDataModel *userData))success onFailure:(void (^)(NSError *))failure;
//Get dashboard data
- (void)getDashboardData:(DashboardDataModel *)userData onSuccess:(void (^)(DashboardDataModel *userData))success onFailure:(void (^)(NSError *))failure;
//Get currency data
- (void)getDefaultCurrency:(DashboardDataModel *)userData onSuccess:(void (^)(DashboardDataModel *userData))success onFailure:(void (^)(NSError *))failure;
//SignUp user service
- (void)signUpUserService:(LoginModel *)userData onSuccess:(void (^)(id userData))success onFailure:(void (^)(NSError *))failure;
@end
