//
//  ReviewService.h
//  GoNatuur
//
//  Created by Ranosys-Mac on 19/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ReviewDataModel;

@interface ReviewService : Webservice

//Fetch review listing
- (void)getReviewListing:(ReviewDataModel *)reviewData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure;
@end
