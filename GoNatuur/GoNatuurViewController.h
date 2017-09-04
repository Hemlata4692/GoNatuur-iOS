//
//  GoNatuurViewController.h
//  GoNatuur
//
//  Created by Ranosys-Mac on 03/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategorySliderViewController.h"
#import "BottomTabViewController.h"

@interface GoNatuurViewController : UIViewController
@property (nonatomic, strong) CategorySliderViewController *categorySliderObjc;
@property (nonatomic, strong) BottomTabViewController *bottomTabController;

- (void)addLeftBarButtonWithImage:(BOOL)isBackButton;
- (void)addSerachButtonWithImage:(UIImage *)searchButtonImage;
- (void)showSelectedTab:(int)item;
- (void)updateCartBadge;
- (void)backButtonAction :(id)sender;
@end
