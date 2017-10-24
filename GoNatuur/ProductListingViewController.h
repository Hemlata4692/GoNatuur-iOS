//
//  ProductListingViewController.h
//  GoNatuur
//
//  Created by Ranosys on 16/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductListingViewController : GoNatuurViewController
@property (nonatomic,assign) int selectedProductCategoryId;
@property (nonatomic,strong) NSString * sortingType;
@property (nonatomic,strong) NSString * sortBasis;
@property (nonatomic) BOOL isSortFilter;
@property (nonatomic) BOOL isSortApplied;
@property (nonatomic) BOOL isFilterApplied;
@property (nonatomic) int sortFilterRequest;
@property (nonatomic,strong) NSDictionary * filterDictionary;
@property (nonatomic,strong) NSMutableArray * filterValueDataArray;
@property (nonatomic, strong) NSMutableDictionary *selectedPickerValueDict;
@end
