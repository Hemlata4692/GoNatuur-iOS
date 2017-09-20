//
//  Webservice.h
//
//
//  Created by Hema on 11/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

////testing link
//#define WEB_BASE_URL                          @"http://gonatuur.local/rest/default/V1/"
//beta link
#define WEB_BASE_URL                          [NSString stringWithFormat:@"%@%@/rest/%@/V1/",BaseUrl,[UserDefaultManager getValue:@"Language"], [UserDefaultManager getValue:@"Language"]]

//http://gonatuur.local/rest/default/V1/integration/admin/token
//http://gonatuur.local/rest/default/V1/ranosys/customer/customer-login
@interface Webservice : NSObject

@property(nonatomic,retain) AFHTTPSessionManager *manager;
@property (readwrite, nonatomic, copy) id success;
@property (readwrite, nonatomic, copy) id failure;
@property (strong, nonatomic) NSString *retryPath;
@property (strong, nonatomic) NSDictionary *retryParameters;

//Singleton instance
+ (id)sharedManager;
//end

//Request with parameters
- (void)put:(NSString *)path parameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure;
- (void)post:(NSString *)path parameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure;
- (void)deleteService:(NSString *)path parameters:(NSDictionary *)parameters isBoolean:(BOOL)isBoolean success:(void (^)(id))success failure:(void (^)(NSError *))failure;
- (void)getConstantsData:(NSString *)path parameters:(NSDictionary *)parameters onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure;

//end

//Request with profile image
- (void)postImage:(NSString *)path parameters:(NSDictionary *)parameters image:(UIImage *)image success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//end

- (void)get:(NSString *)path parameters:(NSDictionary *)parameters onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure;

- (void)getSearchData:(NSString *)path parameters:(NSDictionary *)parameters onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure;

//Check response success
- (BOOL)isStatusOK:(id)responseObject;
//end


@end
