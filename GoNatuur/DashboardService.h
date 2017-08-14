//
//  DashboardService.h
//  GoNatuur
//
//  Created by Ranosys-Mac on 11/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DashboardDataModel;

@interface DashboardService : Webservice
//Fetch category listng data
- (void)getCategoryListData:(DashboardDataModel *)categoryList success:(void (^)(id))success onfailure:(void (^)(NSError *))failure;
//Fetch dashboard data
- (void)getDashboardData:(DashboardDataModel *)dasboardData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure;
//Fetch currency data
- (void)getCurrency:(DashboardDataModel *)dasboardData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure;
@end
