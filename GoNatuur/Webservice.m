//
//  Webservice.m
//  
//
//  Created by Hema on 11/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//


#import "Webservice.h"
#import "NullValueChecker.h"

@implementation Webservice
@synthesize manager;

#pragma mark - Singleton instance
+ (id)sharedManager {
    static Webservice *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        manager = [[AFHTTPSessionManager manager] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    }
    return self;
}
#pragma mark - end

#pragma mark - AFNetworking method
//Request with parameters
- (void)post:(NSString *)path parameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    if ([UserDefaultManager getValue:@"Authorization"] != NULL) {
        //[UserDefaultManager getValue:@"Authorization"]
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[UserDefaultManager getValue:@"Authorization"]] forHTTPHeaderField:@"Authorization"];
    }
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager POST:path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        responseObject=(NSMutableDictionary *)[NullValueChecker checkArrayForNullValue:[responseObject mutableCopy]];
        success(responseObject);
    } failure:^(NSURLSessionDataTask * task, NSError * _Nonnull error) {
        NSLog(@"error.localizedDescription %@",error.localizedDescription);
        [myDelegate stopIndicator];
        if (error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] != nil) {
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]
                                                                 options:kNilOptions error:&error];
            NSLog(@"json %@",json);
            [self isStatusOK:json];
        } else {
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert showWarning:nil title:@"Alert" subTitle:error.localizedDescription closeButtonTitle:@"Ok" duration:0.0f];
        }
    }];
}

//Request with profile image
- (void)postImage:(NSString *)path parameters:(NSDictionary *)parameters image:(UIImage *)image success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    if ([UserDefaultManager getValue:@"Authorization"] != NULL) {
        //[UserDefaultManager getValue:@"Authorization"]
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[UserDefaultManager getValue:@"Authorization"]] forHTTPHeaderField:@"Authorization"];
    }
    manager.securityPolicy.allowInvalidCertificates = YES;
    NSData *imageData = UIImageJPEGRepresentation(image, 0.3);
    [manager POST:path parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"Images" fileName:@"files.jpg" mimeType:@"image/jpeg"];
    } progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [myDelegate stopIndicator];
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]
                                                             options:kNilOptions error:&error];
        NSLog(@"json %@",json);
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:nil title:@"Alert" subTitle:[json objectForKey:@"message"] closeButtonTitle:@"Ok" duration:0.0f];
    }];
}

//Get method for other services
- (void)get:(NSString *)path parameters:(NSDictionary *)parameters onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure {
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    path = @"http://gonatuur.local/rest/default/V1/store/storeViews";
    [manager GET:path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [myDelegate stopIndicator];
        success(responseObject);
    }
        failure:^(NSURLSessionDataTask * task, NSError * _Nonnull error) {
             [myDelegate stopIndicator];
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]
                                                                 options:kNilOptions error:&error];
            NSLog(@"json %@",json);
            NSLog(@"error %ld",(long)error.code);
            NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
            NSInteger statusCode = [response statusCode];
            NSLog(@"error %ld",(long)statusCode);
            failure(error);
        }];
}

//Check response success
- (BOOL)isStatusOK:(id)responseObject {
    NSNumber *number = responseObject[@"status"];
    NSString *msg;
    switch (number.integerValue) {
        case 400: {
            msg = responseObject[@"message"];
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert showWarning:nil title:@"Alert" subTitle:msg closeButtonTitle:@"Ok" duration:0.0f];
            return NO;
        }
        case 200:
            return YES;
            break;
        case 401: {
            msg = responseObject[@"message"];
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert addButton:@"Ok" actionBlock:^(void) {
                //add action
            }];
            [alert showWarning:nil title:@"Alert" subTitle:msg closeButtonTitle:nil duration:0.0f];
        }
            return NO;
            break;
        default: {
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert showWarning:nil title:@"Alert" subTitle:msg closeButtonTitle:@"Ok" duration:0.0f];
        }
            return NO;
            break;
    }
}
#pragma mark - end


@end
