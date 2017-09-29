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
static NSString *kRationOptions=@"ranosys/getRatngFormOptions";
static NSString *kAddReview=@"ranosys/addProductReview";

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
                                                                   },
                                                               @{
                                                                   @"filters":@[
                                                                           @{@"field":@"status_id",
                                                                             @"value":@"1",
                                                                             @"condition_type": @"eq"
                                                                             }
                                                                           ]
                                                                   }
                                                               ],
                                                       @"sort_orders" : @[
                                                               @{@"field":reviewData.sortBy,
                                                                 @"direction":reviewData.sortByValue
                                                                 },
                                                               ],
                                                       @"page_size" : [UserDefaultManager getValue:@"paginationSize"],
                                                       @"current_page" : reviewData.pageCount
                                                       },
                                 @"productId": reviewData.productId,
                                 @"starFilter": reviewData.starFilter,
                                 @"applyStarFilter":reviewData.applyStarFilter
                                 };
    DLog(@"review list request %@",parameters);
    [super post:kReviewListing parameters:parameters success:success failure:failure];
}
//applyStarFilter - to apply filter = 1 and 0 to not apply

//Fetch rating options
- (void)getRatingOptions:(ReviewDataModel *)reviewData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    [self get:kRationOptions parameters:nil onSuccess:success onFailure:failure];
}

//Add review
- (void)addProductReview:(ReviewDataModel *)reviewData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"productId": reviewData.productId,
                                 @"reviewTitle": reviewData.reviewTitle,
                                 @"customerId":[UserDefaultManager getValue:@"userId"],
                                 @"customerNickName":reviewData.username,
                                 @"reviewDetail":reviewData.reviewDescription,
                                 @"reviewId":reviewData.reviewId,
                                 @"starRatingOptions" : @[
                                         @{@"rating_id":@"1",
                                           @"option_id":reviewData.ratingId
                                           },
                                         ],
                                 };
    DLog(@"review request %@",parameters);
    [super post:kAddReview parameters:parameters success:success failure:failure];
}

@end
