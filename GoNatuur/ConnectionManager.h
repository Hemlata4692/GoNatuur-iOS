//
//  ConnectionManager.h
//  GoNatuur
//
//  Created by Hemlata Khajanchi on 24/07/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LoginModel;

@interface ConnectionManager : NSObject

//Singleton method
+ (instancetype)sharedManager;
//Authentication token
- (void)getAccessToken:(LoginModel *)userData onSuccess:(void (^)(LoginModel *userData))success onFailure:(void (^)(NSError *))failure;
//Login user
- (void)loginUser:(LoginModel *)userData onSuccess:(void (^)(LoginModel *userData))success onFailure:(void (^)(NSError *))failure;
//Save device token
- (void)sendDevcieToken:(LoginModel *)userData onSuccess:(void (^)(LoginModel *userData))success onFailure:(void (^)(NSError *))failure;
@end
