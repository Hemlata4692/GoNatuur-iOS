//
//  GoNatuurViewController.h
//  GoNatuur
//
//  Created by Ranosys-Mac on 03/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategorySliderViewController.h"

@interface GoNatuurViewController : UIViewController
@property (nonatomic, strong) CategorySliderViewController *categorySliderObjc;

- (void)addLeftBarButtonWithImage:(BOOL)isBackButton;
- (void)addSerachButtonWithImage:(UIImage *)searchButtonImage;
@end
