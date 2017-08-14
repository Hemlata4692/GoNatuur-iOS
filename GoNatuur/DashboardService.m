//
//  DashboardService.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 11/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "DashboardService.h"
#import "DashboardDataModel.h"

static NSString *kCategoryList=@"categories";
static NSString *kDasboardData=@"ranosys/dashboard";
static NSString *kCurrencyData=@"directory/currency";

@implementation DashboardService

#pragma mark - Get category listing
- (void)getCategoryListData:(DashboardDataModel *)categoryList success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
//    [UserDefaultManager setValue:[UserDefaultManager getValue:@"Authorization"] key:@"Authorization"];
    [UserDefaultManager setValue:@"9e28chln10yp8bkporq87jkw8vrgi6f3" key:@"Authorization"];
    NSDictionary *parameters = @{@"rootCategoryId":categoryList.categoryId};
    NSLog(@"category list request %@",parameters);
    [super get:[NSString stringWithFormat:@"%@",kCategoryList] parameters:parameters onSuccess:success onFailure:failure];
}
#pragma mark - end

#pragma mark - Get dashboard data
- (void)getDashboardData:(DashboardDataModel *)dasboardData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    [UserDefaultManager setValue:[UserDefaultManager getValue:@"Authorization"] key:@"Authorization"];
//    [UserDefaultManager setValue:@"9e28chln10yp8bkporq87jkw8vrgi6f3" key:@"Authorization"];
    [super post:kDasboardData parameters:nil success:success failure:failure];
}
#pragma mark - end

#pragma mark - Get currency data
- (void)getCurrency:(DashboardDataModel *)dasboardData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    //    [UserDefaultManager setValue:[UserDefaultManager getValue:@"Authorization"] key:@"Authorization"];
//    [UserDefaultManager setValue:@"9e28chln10yp8bkporq87jkw8vrgi6f3" key:@"Authorization"];
    [super get:kCurrencyData parameters:nil onSuccess:success onFailure:failure];
}
#pragma mark - end
@end
