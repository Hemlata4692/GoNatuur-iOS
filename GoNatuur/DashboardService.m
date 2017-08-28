//
//  DashboardService.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 11/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "DashboardService.h"
#import "DashboardDataModel.h"
#import "CurrencyDataModel.h"

static NSString *kCategoryList=@"ranosys/categories";
static NSString *kDashboardData=@"ranosys/dashboard";
static NSString *kCurrencyData=@"directory/currency";
static NSString *kProductListData=@"ranosys/productsList";
static NSString *kCategoryBannerData=@"ranosys/getCategoryDetails";

@implementation DashboardService

#pragma mark - Get category listing
- (void)getCategoryListData:(DashboardDataModel *)categoryList success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"rootCategoryId":categoryList.categoryId};
    NSLog(@"category list request %@",parameters);
    [super get:[NSString stringWithFormat:@"%@",kCategoryList] parameters:parameters onSuccess:success onFailure:failure];
}
#pragma mark - end

#pragma mark - Get dashboard data
- (void)getDashboardData:(DashboardDataModel *)dasboardData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    [super post:kDashboardData parameters:nil success:success failure:failure];
}
#pragma mark - end

#pragma mark - Get currency data
- (void)getCurrency:(CurrencyDataModel *)currencyData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    [super get:kCurrencyData parameters:nil onSuccess:success onFailure:failure];
}
#pragma mark - end

#pragma mark - Get product list data
- (void)getProductListService:(DashboardDataModel *)productData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
//    [UserDefaultManager setValue:[UserDefaultManager getValue:@"Authorization"] key:@"Authorization"];
    NSString *typeId;
    if (!myDelegate.isProductList) {
        typeId=eventIdentifier;
    }
    else {
        typeId=@"simple";
    }
    NSDictionary *parameters = @{@"searchCriteria" : @{@"filter_groups" : @[
                                                               @{
                                                                   @"filters":@[
                                                                           @{@"field":@"type_id",
                                                                             @"value":typeId,
                                                                             @"condition_type": @"eq"
                                                                             },
                                                                           @{@"field":@"category_id",
                                                                             @"value":productData.categoryId,
                                                                             @"condition_type": @"eq"
                                                                             },
                                                                           @{@"field":@"status",
                                                                             @"value":@"1",
                                                                             @"condition_type": @"eq"
                                                                             }
                                                                           ]
                                                                   }
                                                               ],
                                                       @"sort_orders" : @[
                                                               @{@"field":@"entity_id",
                                                                 @"direction":@"ASC"
                                                                 }
                                                               ],
                                                       @"page_size" : productData.pageSize,
                                                       @"current_page" : productData.currentPage
                                                       }
                                 };
    [super post:kProductListData parameters:parameters success:success failure:failure];
}
#pragma mark - end

#pragma mark - Get category banner
- (void)getCategoryBannerData:(DashboardDataModel *)categoryList success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"categoryId":categoryList.categoryId};
    NSLog(@"category list request %@",parameters);
    [super post:kCategoryBannerData parameters:parameters success:success failure:failure];
}
#pragma mark - end
@end
