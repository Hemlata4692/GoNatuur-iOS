//
//  FilterViewController.h
//  GoNatuur
//
//  Created by Ranosys-Mac on 21/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductListingViewController.h"

@interface FilterViewController : UIViewController
@property(nonatomic,strong) ProductListingViewController *productListViewObj;
@property (nonatomic) int filterProductId;
@property (nonatomic) int selectedPickerValueIndex;
@property (nonatomic, strong) NSMutableDictionary *selectedPickerIndexDict;
@end
