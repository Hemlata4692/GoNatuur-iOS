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

//Singleton instanse
+ (instancetype)sharedUser;

//Review listing data
- (void)getUserReviewListingData:(void (^)(ReviewDataModel *))success onfailure:(void (^)(NSError *))failure;
@end
