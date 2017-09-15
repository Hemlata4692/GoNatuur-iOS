//
//  ProductGuideService.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 14/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "ProductGuideService.h"
#import "ProductGuideDataModel.h"

@implementation ProductGuideService
static NSString *kProductGuideCategory=@"ranosys/product-guide/categories";
static NSString *kProductGuideDetailsCategory=@"ranosys/product-guide/getList";


#pragma mark - Get guide category service
- (void)getGuideCategoryService:(ProductGuideDataModel *)profileData onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure {
    [super post:kProductGuideCategory parameters:nil success:success failure:failure];
}
#pragma mark - end

#pragma mark - Get guide details service
- (void)getGuideCategoryDetailsService:(ProductGuideDataModel *)userData onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"searchCriteria" : @{@"filter_groups" : @[
                                                               @{@"filters":@[
                                                                           @{@"field":@"category_id",
                                                                             @"value":userData.categoryId,
                                                                             @"condition_type": @"eq"
                                                                             }
                                                                           ],
                                                                 }
                                                                   ],
                                                                   @"sort_orders":@[
                                                                           @{@"field":@"post_id",
                                                                             @"direction":@"asc",
                                                                             }
                                                                           ],
                                                       @"page_size" : @0,
                                                       @"current_page" : @0
                                                       }
                                 };
    NSLog(@" request %@",parameters);
    [super post:kProductGuideDetailsCategory parameters:parameters success:success failure:failure];
}
#pragma mark - end
@end
