//
//  DashboardService.h
//  GoNatuur
//
//  Created by Ranosys-Mac on 11/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DashboardDataModel;
@class CurrencyDataModel;

@interface DashboardService : Webservice
//Fetch category listng data
- (void)getCategoryListData:(DashboardDataModel *)categoryList success:(void (^)(id))success onfailure:(void (^)(NSError *))failure;
//Fetch dashboard data
- (void)getDashboardData:(DashboardDataModel *)dasboardData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure;
//Fetch currency data
- (void)getCurrency:(CurrencyDataModel *)currencyData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure;
//Get product list data
- (void)getProductListService:(DashboardDataModel *)productData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure;
//Get category banner
- (void)getCategoryBannerData:(DashboardDataModel *)categoryList success:(void (^)(id))success onfailure:(void (^)(NSError *))failure;
//Get news centre service
- (void)getNewsListService:(DashboardDataModel *)productData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure;
//Get news category
- (void)getNewsCategoryData:(DashboardDataModel *)categoryList success:(void (^)(id))success onfailure:(void (^)(NSError *))failure;
//News detail service
- (void)getNewsDetailService:(DashboardDataModel *)productData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure;
//Get contsnts listing
- (void)getConstantsListData:(DashboardDataModel *)categoryList success:(void (^)(id))success onfailure:(void (^)(NSError *))failure;

@end
