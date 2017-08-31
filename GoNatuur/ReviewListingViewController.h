//
//  ReviewListingViewController.h
//  GoNatuur
//
//  Created by Ranosys-Mac on 19/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductDetailViewController.h"

@interface ReviewListingViewController : GoNatuurViewController
@property (nonatomic,strong) NSNumber *productID;
@property (nonatomic,strong) NSString *reviewAdded;
@property (nonatomic,strong) NSString *reviewId;
@property (nonatomic,strong) ProductDetailViewController *productDetailObj;
@end
