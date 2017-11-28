//
//  NewsLetterSubscriptionViewController.h
//  GoNatuur
//
//  Created by Ranosys-Mac on 08/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FinalCheckoutViewController.h"

@protocol ApplyCouponDelegate <NSObject>
@optional
- (void)applyCoupon:(NSString *)couponApplied;
@end

@interface NewsLetterSubscriptionViewController : UIViewController {
        id <ApplyCouponDelegate> _delegate;
    }
@property (nonatomic, strong) NSString *screeType;
@property (nonatomic,strong) id delegate;
@end
