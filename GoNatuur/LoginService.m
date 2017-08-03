//
//  LoginService.m
//  GoNatuur
//
//  Created by Hemlata Khajanchi on 24/07/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//


static NSString *kAuthorizationToken=@"integration/admin/token";


#import "LoginService.h"
#import "LoginModel.h"

@implementation LoginService

#pragma mark - Get authorization token
- (void)getAccessToken:(LoginModel *)accessToken onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure
{
//    NSDictionary *parameters = @{@"username" : accessToken.username,
//                                 @"password" : accessToken.password};
    //storeViews
    [super get:@"storeViews" parameters:nil onSuccess:success onFailure:failure];
//    [super post:kAuthorizationToken parameters:nil success:success failure:failure];
}
#pragma mark - end
@end
