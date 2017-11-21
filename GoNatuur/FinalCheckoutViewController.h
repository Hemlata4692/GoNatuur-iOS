//
//  FinalCheckoutViewController.h
//  GoNatuur
//
//  Created by Ranosys on 12/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartDataModel.h"
#import "PaymentModel.h"

@interface FinalCheckoutViewController : GoNatuurViewController
@property (nonatomic, strong) CartDataModel *cartModelData;
@property (nonatomic, strong) NSMutableArray *cartListDataArray;
@property (nonatomic, strong) NSMutableDictionary *finalCheckoutPriceDict;
@property (nonatomic, strong) PaymentModel *selectedCardDataDict;
@end
