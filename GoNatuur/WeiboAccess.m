//
//  WeiboAccess.m
//  Weibo-OAuth
//
//  Created by 杨建亚 on 15/1/13.
//  Copyright (c) 2015年 Dwarven. All rights reserved.
//

#import "WeiboAccess.h"
#import "WeiboSDK.h"

#define kAppKey         @"1897886621"

#define kRedirectURI    @"http://www.sina.com"

NSInteger const WeiboStatusCodeAuthDeny = WeiboSDKResponseStatusCodeAuthDeny;

@interface NSMutableDictionary (setObjectWithOutNil)

- (void)setObjectWithOutNil:(id)anObject forKey:(id<NSCopying>)aKey;

@end

@implementation NSMutableDictionary (setObjectWithOutNil)

- (void)setObjectWithOutNil:(id)anObject forKey:(id<NSCopying>)aKey{
    if (anObject) {
        [self setObject:anObject forKey:aKey];
    }
}

@end

@interface WeiboAccess ()<WeiboSDKDelegate>{
    void(^_result)(BOOL,id);
}

@end

@implementation WeiboAccess

+ (WeiboAccess *)defaultAccess{
    static WeiboAccess * __access = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __access = [[WeiboAccess alloc] init];
    });
    return __access;
}

+ (void)enableDebugMode:(BOOL)enabled{
    [WeiboSDK enableDebugMode:enabled];
}

+ (BOOL)registerApp{
    return [WeiboSDK registerApp:kAppKey];
}

+ (BOOL)handleOpenURL:(NSURL *)url{
    return [WeiboSDK handleOpenURL:url delegate:[WeiboAccess defaultAccess]];
}

- (void)login:(void (^)(BOOL, id))result{
    _result = result;
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURI;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}

#pragma mark - weibo sdk delegate

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    if ([response isKindOfClass:[WBAuthorizeResponse class]])
    {
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setObjectWithOutNil:@"Certification results" forKey:@"title"];
        [dic setObjectWithOutNil:[NSNumber numberWithInteger:response.statusCode] forKey:WEIBO_STATUS_CODE];
        [dic setObjectWithOutNil:[(WBAuthorizeResponse *)response userID] forKey:@"userID"];
        [dic setObjectWithOutNil:[(WBAuthorizeResponse *)response accessToken] forKey:@"accessToken"];
        [dic setObjectWithOutNil:response.userInfo forKey:@"userInfo"];
        [dic setObjectWithOutNil:response.requestUserInfo forKey:@"requestUserInfo"];
        [dic setObjectWithOutNil:[(WBAuthorizeResponse *)response expirationDate] forKey:@"expirationDate"];
        _result(response.statusCode == 0 ? YES : NO,dic);
    }else{
        _result(NO,nil);
    }
}

//email

//https://api.weibo.com/2/account/profile/email.json?access_token=2.004B4TqGyY87OCb6ad6835b57M8RMC

//API LINKS
//http://open.weibo.com/wiki/Users/show/en
//http://open.weibo.com/wiki/API%E6%96%87%E6%A1%A3/en

@end
