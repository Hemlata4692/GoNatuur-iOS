//
//  PaymentService.h
//  GoNatuur
//
//  Created by Ranosys on 19/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PaymentModel;

@interface PaymentService : Webservice

//Get card listing
- (void)getCardListing:(PaymentModel *)orderData onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure;
//Delete card
- (void)deleteCardFromListing:(PaymentModel *)orderData onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure;
@end
