//
//  FilterViewController.h
//  GoNatuur
//
//  Created by Ranosys-Mac on 21/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductListingViewController.h"
#import "RedeemViewController.h"

@interface FilterViewController : UIViewController
@property(nonatomic,strong) ProductListingViewController *productListViewObj;
@property(nonatomic,strong) RedeemViewController *redeemListObj;
@property (nonatomic) int filterProductId;
@property (nonatomic) int selectedPickerValueIndex;
@property (nonatomic, strong) NSMutableDictionary *selectedPickerIndexDict;
@property (nonatomic,assign) bool isProductList;
@end
