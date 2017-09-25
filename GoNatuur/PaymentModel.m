//
//  PaymentModel.m
//  GoNatuur
//
//  Created by Ranosys on 19/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "PaymentModel.h"
#import "ConnectionManager.h"

@implementation PaymentModel
#pragma mark - Shared instance

+ (instancetype)sharedUser {
    static PaymentModel *paymentData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        paymentData = [[[self class] alloc] init];
    });
    return paymentData;
}
#pragma mark - end

#pragma mark - Card listing data
- (void)getCardListing:(void (^)(PaymentModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] getCardListing:self onSuccess:^(PaymentModel *paymentData) {
        if (success) {
            success (paymentData);
        }
    } onFailure:^(NSError *error) {
        failure(error);
    }];
}
#pragma mark - end

@end
