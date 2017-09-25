//
//  NewsLetterSubscriptionViewController.h
//  GoNatuur
//
//  Created by Ranosys-Mac on 08/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FinalCheckoutViewController.h"

@interface NewsLetterSubscriptionViewController : UIViewController
@property (nonatomic, assign) BOOL isApplyCoupon;
@property (nonatomic, strong) FinalCheckoutViewController *finalCheckoutViewObj;
@end
