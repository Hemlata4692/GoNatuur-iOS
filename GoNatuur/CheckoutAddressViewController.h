//
//  CheckoutAddressViewController.h
//  GoNatuur
//
//  Created by Ranosys on 06/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartDataModel.h"

@interface CheckoutAddressViewController : GoNatuurViewController
@property (nonatomic, strong) NSMutableArray *cartListDataArray;
@property (nonatomic, strong) CartDataModel *cartListModelData;
@end
