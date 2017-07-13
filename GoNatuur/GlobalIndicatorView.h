//
//  GlobalIndicatorView.h
//  GoNatuur
//
//  Created by Hemlata Khajanchi on 13/07/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMMaterialDesignSpinner.h"


@interface GlobalIndicatorView : NSObject
@property (strong, nonatomic) MMMaterialDesignSpinner *spinnerView;
@property (strong, nonatomic) UIImageView *spinnerBackground;
@property (strong, nonatomic) UIView *loaderView;

+ (id)sharedManager;

- (void)showIndicator:(UIView *)view;
- (void)stopIndicator;
@end
