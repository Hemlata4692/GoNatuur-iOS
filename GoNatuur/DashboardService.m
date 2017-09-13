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
static NSString *kNewsListData=@"ranosys/news/getList";
static NSString *kNewsDetailData=@"ranosys/news/getById";
static NSString *kCategoryBannerData=@"ranosys/getCategoryDetails";
static NSString *kNwesCategory=@"ranosys/news/getNewsCategory";

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
                                                               @{@"field":@"name",
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

#pragma mark - Get News list data
- (void)getNewsListService:(DashboardDataModel *)productData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    NSDictionary *parameters;
    if ([productData.newsType isEqualToString:@"All"]) {
        parameters = @{@"searchCriteria" : @{@"filter_groups" : @[
                                                     @{
                                                         @"filters":@[
                                                                 @{@"field":@"is_active",
                                                                   @"value":@"1",
                                                                   @"condition_type": @"eq"
                                                                   },
                                                                 ]
                                                         }
                                                     ],
                                             @"page_size" : productData.pageSize,
                                             @"current_page" : productData.currentPage
                                             }
                       };
    }
    
    else if ([productData.newsType isEqualToString:@"search"]) {
        parameters = @{@"searchCriteria" : @{@"filter_groups" : @[
                                                     @{
                                                         @"filters": @[
                                                                 @{@"field":@"is_active",
                                                                   @"value":@"1",
                                                                   @"condition_type": @"eq"
                                                                   },
                                                                 @{@"field":@"title",
                                                                   @"value": productData.categoryName,
                                                                   @"condition_type":@"like"
                                                                   },
                                                                 @{@"field":@"content_heading",
                                                                   @"value": productData.categoryName,
                                                                   @"condition_type":@"like"
                                                                   },
                                                                 @{@"field":@"content",
                                                                   @"value": productData.categoryName,
                                                                   @"condition_type":@"like"
                                                                   },
                                                                 @{@"field":@"author_name",
                                                                   @"value": productData.categoryName,
                                                                   @"condition_type":@"like"
                                                                   }
                                                                 ]
                                                         }
                                                     ],
                                             @"page_size" : productData.pageSize,
                                             @"current_page" : productData.currentPage
                                             }
                       };
    }
    else {
        parameters = @{@"searchCriteria" : @{@"filter_groups" : @[
                                                     @{
                                                         @"filters":@[
                                                                 @{@"field":@"category",
                                                                   @"value":productData.categoryId,
                                                                   @"condition_type": @"eq"
                                                                   },
                                                                 @{@"field":@"is_active",
                                                                   @"value":@"1",
                                                                   @"condition_type": @"eq"
                                                                   }
                                                                 ],
                                                         }
                                                     ],
                                             @"page_size" : productData.pageSize,
                                             @"current_page" : productData.currentPage
                                             }
                       };
    }
    NSLog(@"news list request %@",parameters);
    [super post:kNewsListData parameters:parameters success:success failure:failure];
}
#pragma mark - end

#pragma mark - Get News detail data
- (void)getNewsDetailService:(DashboardDataModel *)productData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"postId":productData.productId};
    NSLog(@"news details request %@",parameters);
    [super post:kNewsDetailData parameters:parameters success:success failure:failure];
}
#pragma mark - end

#pragma mark - Get category banner
- (void)getCategoryBannerData:(DashboardDataModel *)categoryList success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"categoryId":categoryList.categoryId};
    NSLog(@"category list request %@",parameters);
    [super post:kCategoryBannerData parameters:parameters success:success failure:failure];
}
#pragma mark - end

#pragma mark - Get news category listing
- (void)getNewsCategoryData:(DashboardDataModel *)categoryList success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    [super post:kNwesCategory parameters:nil success:success failure:failure];
}
#pragma mark - end
@end
