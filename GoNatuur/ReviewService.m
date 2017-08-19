//
//  ReviewService.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 19/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "ReviewService.h"
#import "ReviewDataModel.h"

static NSString *kReviewListing=@"ranosys/getReviewsList";


@implementation ReviewService

- (void)getReviewListing:(ReviewDataModel *)reviewData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"searchCriteria" : @{@"filter_groups" : @[
                                                         @{
                                                             @"filters":@[
                                                                     @{@"field":@"customer_id",
                                                                       @"value":@1,
                                                                       @"condition_type": @"eq"
                                                                       }
                                                                     ]
                                                             }
                                                         ],
                                                 @"sort_orders" : @[
                                                         @{@"field":@"created_at",
                                                           @"direction":@"DESC"
                                                           }
                                                         ],
                                                 @"page_size" : @"10",
                                                 @"current_page" : @1
                                                 },
                                 @"productId": @1,
                                 @"starFilter": @0,
                                 @"applyStarFilter": @0
                                 };
    DLog(@"review list request %@",parameters);
    [super post:kReviewListing parameters:parameters success:success failure:failure];
}
//reviewData.pageCount
//[UserDefaultManager getValue:@"userId"]
@end
