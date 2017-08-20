//
//  ReviewDataModel.h
//  GoNatuur
//
//  Created by Ranosys-Mac on 19/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReviewDataModel : NSObject
@property (strong, nonatomic) NSString *totalCount;
@property (strong, nonatomic) NSNumber *pageCount;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *starFilter;
@property (strong, nonatomic) NSString *sortBy;
@property (strong, nonatomic) NSString *productId;
@property (strong, nonatomic) NSString *reviewTitle;
@property (strong, nonatomic) NSString *reviewDescription;
@property (strong, nonatomic) NSString *userImageUrl;
@property (strong, nonatomic) NSString *userLocation;
@property (strong, nonatomic) NSString *reviewListArray;

//Singleton instanse
+ (instancetype)sharedUser;

//Review listing data
- (void)getUserReviewListingData:(void (^)(ReviewDataModel *))success onfailure:(void (^)(NSError *))failure;
@end
