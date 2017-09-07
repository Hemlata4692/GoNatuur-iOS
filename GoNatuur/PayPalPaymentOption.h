//
//  PayPalPaymentOption.h
//  GoNatuur
//
//  Created by Ranosys-Mac on 06/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PayPalMobile.h"

@interface PayPalPaymentOption : NSObject
@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;
- (void) configPaypalPayment:(NSString *)environment ;
- (void)setPaymentDetails:(NSMutableArray *)dataArray delegate:(id)delegate;
@end
