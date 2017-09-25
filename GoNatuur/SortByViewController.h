//
//  SortByViewController.h
//  GoNatuur
//
//  Created by Monika on 21/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductListingViewController.h"

@interface SortByViewController : UIViewController
@property(nonatomic,strong) ProductListingViewController *productListViewObj;
@property (nonatomic,assign) NSString * sortingType;
@property (nonatomic,assign) NSString * sortBasis;
@property (nonatomic)BOOL isEventScreen;
@property (nonatomic,assign) NSString *productId;
@end
