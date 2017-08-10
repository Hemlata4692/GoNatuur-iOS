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
//#define BASE_URL                          @"http://gonatuur.local/rest/default/V1/"
//beta link
#define BASE_URL                          @"http://dev.gonatuur.com/en/rest/en/V1/"

//http://gonatuur.local/rest/default/V1/integration/admin/token
//http://gonatuur.local/rest/default/V1/ranosys/customer/customer-login
@interface Webservice : NSObject

@property(nonatomic,retain) AFHTTPSessionManager *manager;

//Singleton instance
+ (id)sharedManager;
//end

//Request with parameters
- (void)post:(NSString *)path parameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//end

//Request with profile image
- (void)postImage:(NSString *)path parameters:(NSDictionary *)parameters image:(UIImage *)image success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//end

- (void)get:(NSString *)path parameters:(NSDictionary *)parameters onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure;

//Check response success
- (BOOL)isStatusOK:(id)responseObject;
//end


@end
