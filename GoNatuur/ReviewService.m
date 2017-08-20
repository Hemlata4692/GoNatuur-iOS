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
                                                                     @{@"field":@"nickname",
                                                                       @"value":[NSString stringWithFormat:@"%s%@%s","%",reviewData.username,"%"],
                                                                       @"condition_type": @"like"
                                                                       },
                                                                     @{@"field":@"title",
                                                                       @"value":[NSString stringWithFormat:@"%s%@%s","%",reviewData.reviewTitle,"%"],
                                                                       @"condition_type": @"like"
                                                                       },
                                                                     @{@"field":@"detail",
                                                                       @"value":[NSString stringWithFormat:@"%s%@%s","%",reviewData.reviewDescription,"%"],
                                                                       @"condition_type": @"like"
                                                                       }
                                                                     ]
                                                             }
                                                         ],
                                                 @"sort_orders" : @[
                                                         @{@"field":@"reviewvote.value",
                                                           @"direction":@"DESC"
                                                           }
                                                         ],
                                                 @"page_size" : @"10",
                                                 @"current_page" : @1
                                                 },
                                 @"productId": reviewData.productId,
                                 @"starFilter": reviewData.starFilter,
                                 @"applyStarFilter":reviewData.sortBy
                                 };
    DLog(@"review list request %@",parameters);
    [super post:kReviewListing parameters:parameters success:success failure:failure];
}
//reviewData.pageCount
//[UserDefaultManager getValue:@"userId"]

//{
//    "searchCriteria": {
//        "filter_groups": [
//                          {
//                              "filters": [
//                                          {
//                                              "field": "nickname",
//                                              "value": "%a%",
//                                              "condition_type": "like"
//                                          },
//                                          {
//                                              "field": "title",
//                                              "value": "%a%",
//                                              "condition_type": "like"
//                                          },
//                                          {
//                                              "field": "detail",
//                                              "value": "%a%",
//                                              "condition_type": "like"
//                                          }
//                                          ]
//                          }
//                          ],
//        "sort_orders": [
//                        {
//                            "field": "reviewvote.value",
//                            "direction": "DESC"
//                        }
//                        ],
//        "page_size": 10,
//        "current_page": 1
//    },
//    "productId": 4,
//    "starFilter": 4,
//    "applyStarFilter":0
//}
@end
