//
//  AppDelegate.h
//  GoNatuur
//
//  Created by Hemlata Khajanchi on 10/07/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConstantCode.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) NSString *deviceToken;
@property (nonatomic,assign) int selectedCategoryIndex;

- (void)showIndicator;
- (void)stopIndicator;
@end

