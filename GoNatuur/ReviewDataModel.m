//
//  ReviewDataModel.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 19/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "ReviewDataModel.h"
#import "ConnectionManager.h"

@implementation ReviewDataModel
@synthesize pageCount;
@synthesize totalCount;
@synthesize username;
@synthesize reviewTitle;
@synthesize reviewDescription;
@synthesize starFilter;
@synthesize sortBy;
@synthesize productId;
@synthesize userImageUrl;
@synthesize userLocation;
@synthesize reviewListArray;
@synthesize sortByValue;
@synthesize rationOptionsArray;
@synthesize ratingId;
@synthesize optionId;
@synthesize reviewId;
@synthesize applyStarFilter;

#pragma mark - Shared instance
+ (instancetype)sharedUser {
    static ReviewDataModel *data = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        data = [[[self class] alloc] init];
    });
    return data;
}
#pragma mark - end

#pragma mark - Review lsit
- (void)getUserReviewListingData:(void (^)(ReviewDataModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] getReviewListing:self onSuccess:^(ReviewDataModel *userData) {
        if (success) {
            success (userData);
        }
    } onFailure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end

#pragma mark - Ration options
- (void)getRatingData:(void (^)(ReviewDataModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] getRationOptions:self onSuccess:^(ReviewDataModel *userData) {
        if (success) {
            success (userData);
        }
    } onFailure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end

#pragma mark - Add review
- (void)addCustomerReview:(void (^)(ReviewDataModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] addReview:self onSuccess:^(ReviewDataModel *userData) {
        if (success) {
            success (userData);
        }
    } onFailure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end
@end
