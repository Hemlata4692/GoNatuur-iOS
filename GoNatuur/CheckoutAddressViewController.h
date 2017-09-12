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
@property (nonatomic, assign) BOOL isBillingAddress;
@property (nonatomic, assign) BOOL isShippingAddress;
@property (nonatomic, assign) BOOL isEditService;
@property (nonatomic, strong) CartDataModel *cartModelData;
@property (nonatomic, assign) float subTotalPrice;
@end
