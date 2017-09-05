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
        manager = [[AFHTTPSessionManager manager] initWithBaseURL:[NSURL URLWithString:WEB_BASE_URL]];
    }
    return self;
}
#pragma mark - end

#pragma mark - AFNetworking method
//Request with parameters
- (void)post:(NSString *)path parameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
      DLog(@"%@",[NSString stringWithFormat:@"%@%@/rest/%@/V1/",BaseUrl,[UserDefaultManager getValue:@"Language"], [UserDefaultManager getValue:@"Language"]]);
     manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    if ([UserDefaultManager getValue:@"Authorization"] != NULL) {
        //[UserDefaultManager getValue:@"Authorization"]
        DLog(@"%@",[NSString stringWithFormat:@"Bearer %@",[UserDefaultManager getValue:@"Authorization"]]);
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[UserDefaultManager getValue:@"Authorization"]] forHTTPHeaderField:@"Authorization"];
    }
    [manager POST:path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        responseObject=(id)[NullValueChecker checkArrayForNullValue:[responseObject mutableCopy]];
        success(responseObject);
    } failure:^(NSURLSessionDataTask * task, NSError * _Nonnull error) {
        NSLog(@"error.localizedDescription %@ %ld",error.localizedDescription, (long)error.code);
        [myDelegate stopIndicator];
        [self parseHeaderData:task error:error path:path parameters:parameters onSuccess:success onFailure:failure];
    }];
}

- (void)put:(NSString *)path parameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
      DLog(@"%@",[NSString stringWithFormat:@"%@%@/rest/%@/V1/",BaseUrl,[UserDefaultManager getValue:@"Language"], [UserDefaultManager getValue:@"Language"]]);
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    if ([UserDefaultManager getValue:@"Authorization"] != NULL) {
        //[UserDefaultManager getValue:@"Authorization"]
        DLog(@"%@",[NSString stringWithFormat:@"Bearer %@",[UserDefaultManager getValue:@"Authorization"]]);
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[UserDefaultManager getValue:@"Authorization"]] forHTTPHeaderField:@"Authorization"];
    }
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager PUT:path parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        responseObject=(id)[NullValueChecker checkArrayForNullValue:[responseObject mutableCopy]];
        success(responseObject);
    } failure:^(NSURLSessionDataTask * task, NSError * _Nonnull error) {
        NSLog(@"error.localizedDescription %@ %ld",error.localizedDescription, (long)error.code);
        [myDelegate stopIndicator];
        [self parseHeaderData:task error:error path:path parameters:parameters onSuccess:success onFailure:failure];
    }];
}

- (void)deleteService:(NSString *)path parameters:(NSDictionary *)parameters isBoolean:(BOOL)isBoolean success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    DLog(@"%@",WEB_BASE_URL);
    if (!isBoolean) {
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    else {
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    if ([UserDefaultManager getValue:@"Authorization"] != NULL) {
        //[UserDefaultManager getValue:@"Authorization"]
        DLog(@"%@",[NSString stringWithFormat:@"Bearer %@",[UserDefaultManager getValue:@"Authorization"]]);
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[UserDefaultManager getValue:@"Authorization"]] forHTTPHeaderField:@"Authorization"];
    }
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager DELETE:path parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (isBoolean) {
            NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            if ([string isEqualToString:@"true"]) {
                success(@{@"status":[NSNumber numberWithBool:true]});
            }
        }
        else {
            responseObject=(id)[NullValueChecker checkArrayForNullValue:[responseObject mutableCopy]];
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * task, NSError * _Nonnull error) {
        NSLog(@"error.localizedDescription %@ %ld",error.localizedDescription, (long)error.code);
        [myDelegate stopIndicator];
        [self parseHeaderData:task error:error path:path parameters:parameters onSuccess:success onFailure:failure];
    }];
}

//Request with profile image
- (void)postImage:(NSString *)path parameters:(NSDictionary *)parameters image:(UIImage *)image success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
      DLog(@"%@",[NSString stringWithFormat:@"%@%@/rest/%@/V1/",BaseUrl,[UserDefaultManager getValue:@"Language"], [UserDefaultManager getValue:@"Language"]]);
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
        NSLog(@"error.localizedDescription %@ %ld",error.localizedDescription, (long)error.code);
        [myDelegate stopIndicator];
        [self parseHeaderData:task error:error path:path parameters:parameters onSuccess:success onFailure:failure];
    }];
}

//Get method for other services
- (void)get:(NSString *)path parameters:(NSDictionary *)parameters onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure {
    DLog(@"%@",[NSString stringWithFormat:@"%@%@/rest/%@/V1/",BaseUrl,[UserDefaultManager getValue:@"Language"], [UserDefaultManager getValue:@"Language"]]);
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [self.manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"application/x-www-form-urlencoded", nil]];
    if ([UserDefaultManager getValue:@"Authorization"] != NULL) {
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[UserDefaultManager getValue:@"Authorization"]] forHTTPHeaderField:@"Authorization"];
    }
    path = [NSString stringWithFormat:@"%@%@",WEB_BASE_URL,path];
    [manager GET:path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        responseObject=(id)[NullValueChecker checkArrayForNullValue:[responseObject mutableCopy]];
        success(responseObject);
    }
         failure:^(NSURLSessionDataTask * task, NSError * _Nonnull error) {
             NSLog(@"error.localizedDescription %@ %ld",error.localizedDescription, (long)error.code);
             [myDelegate stopIndicator];
             [myDelegate stopIndicator];
             [self parseHeaderData:task error:error path:path parameters:parameters onSuccess:success onFailure:failure];
         }];
}

//Get method for search services
- (void)getSearchData:(NSString *)path parameters:(NSDictionary *)parameters onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure {
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [self.manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"application/x-www-form-urlencoded", nil]];
    if ([UserDefaultManager getValue:@"Authorization"] != NULL) {
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[UserDefaultManager getValue:@"Authorization"]] forHTTPHeaderField:@"Authorization"];
    }
    path = [NSString stringWithFormat:@"http://dev.gonatuur.com/en/%@",path];
    [manager GET:path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        responseObject=(id)[NullValueChecker checkArrayForNullValue:[responseObject mutableCopy]];
        success(responseObject);
    }
         failure:^(NSURLSessionDataTask * task, NSError * _Nonnull error) {
             NSLog(@"error.localizedDescription %@ %ld",error.localizedDescription, (long)error.code);
             [myDelegate stopIndicator];
             [self parseHeaderData:task error:error path:path parameters:parameters onSuccess:success onFailure:failure];
         }];
}

- (void)parseHeaderData:(NSURLSessionDataTask *)task error:(NSError *)error  path:(NSString *)path parameters:(NSDictionary *)parameters onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure {
    if (error.code == -1009) {
        [self showRetryAlertMessage:NSLocalizedText(@"Internet connection") path:path parameters:parameters success:success failure:failure error:error];
    }
    else if (error.code == -1001) {
        [self showRetryAlertMessage:NSLocalizedText(@"RequestTimeout") path:path parameters:parameters success:success failure:failure error:error];
    }
    else {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSInteger statusCode = [response statusCode];
        if ((int)statusCode==200 && error) {
            success(@{@"status":[NSNumber numberWithBool:true]});
        }
        else {
            NSMutableDictionary* json = [[NSJSONSerialization JSONObjectWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:kNilOptions error:&error] mutableCopy];
            NSLog(@"json %@",json);
            NSLog(@"error %ld",(long)error.code);
            
            [json setObject:[NSNumber numberWithInteger:statusCode] forKey:@"status"];
            [self isStatusOK:json];
            NSLog(@"error %ld",(long)statusCode);
            failure(error);
        }
    }
}

//Check response success
- (BOOL)isStatusOK:(id)responseObject {
    NSNumber *number = responseObject[@"status"];
    NSString *msg;
    switch (number.integerValue) {
        case 400: {
            msg = responseObject[@"message"];
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:msg closeButtonTitle:NSLocalizedText(@"alertOk") duration:0.0f];
            return NO;
        }
        case 200:
            return YES;
            break;
        case 401: {
            msg = responseObject[@"message"];
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert addButton:NSLocalizedText(@"alertOk") actionBlock:^(void) {
                //add action
            }];
            [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:msg closeButtonTitle:nil duration:0.0f];
        }
            return NO;
            break;
        case 404: {
            msg = responseObject[@"message"];
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert addButton:NSLocalizedText(@"alertOk") actionBlock:^(void) {
                //add action
            }];
            [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:msg closeButtonTitle:nil duration:0.0f];
        }
            return NO;
            break;
        default: {
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"somethingWrongMessage") closeButtonTitle:NSLocalizedText(@"alertOk") duration:0.0f];
        }
            return NO;
            break;
    }
}
#pragma mark - end

#pragma mark - Retry webservice
- (void)showRetryAlertMessage:(NSString *)message path:(NSString *)path parameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure error:(NSError *)error {
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    [alert addButton:NSLocalizedText(@"alertRetry") actionBlock:^(void) {
        self.success=success;
        self.failure=failure;
        self.retryPath=path;
        self.retryParameters=parameters;
        [myDelegate showIndicator];
        [self performSelector:@selector(retryWebservice) withObject:nil afterDelay:.1];
        
    }];
    [alert addButton:NSLocalizedText(@"alertCancel") actionBlock:^(void) {
        failure(error);
    }];
    [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:message closeButtonTitle:nil duration:0.0f];
}

- (void)retryWebservice {
    [self post:self.retryPath parameters:self.retryParameters success:self.success failure:self.failure];
}
#pragma mark - end
@end
