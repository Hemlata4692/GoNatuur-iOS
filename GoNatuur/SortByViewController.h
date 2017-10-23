//
//  SortByViewController.h
//  GoNatuur
//
//  Created by Monika on 21/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductListingViewController.h"
#import "RedeemViewController.h"

@interface SortByViewController : UIViewController
@property(nonatomic,strong) ProductListingViewController *productListViewObj;
@property(nonatomic,strong) RedeemViewController *redeemListObj;
@property (nonatomic,strong) NSString * sortingType;
@property (nonatomic,strong) NSString * sortBasis;
@property (nonatomic) int sortProductId;
@end
