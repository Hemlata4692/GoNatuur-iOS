//
//  FinalCheckoutViewController.h
//  GoNatuur
//
//  Created by Ranosys on 12/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartDataModel.h"

@interface FinalCheckoutViewController : GoNatuurViewController
@property (nonatomic, strong) CartDataModel *cartModelData;
@property (nonatomic, strong) NSMutableArray *cartListDataArray;
@end
