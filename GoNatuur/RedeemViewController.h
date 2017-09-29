//
//  RedeemViewController.h
//  GoNatuur
//
//  Created by Ranosys-Mac on 13/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedeemViewController : GoNatuurViewController
@property (nonatomic, strong) NSString *visitedFromScreen;
@property (nonatomic,assign) int selectedProductCategoryId;
@property (nonatomic,strong) NSString * sortingType;
@property (nonatomic,strong) NSString * sortBasis;
@property (nonatomic) BOOL isSortFilter;
@property (nonatomic) int sortFilterRequest;
@property (nonatomic,strong) NSDictionary * filterDictionary;
@end
