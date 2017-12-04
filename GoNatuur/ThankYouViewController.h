//
//  ThankYouViewController.h
//  GoNatuur
//
//  Created by Monika on 9/5/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThankYouViewController : GoNatuurViewController
@property (weak, nonatomic) IBOutlet UITableView *thankYouTable;
@property (weak, nonatomic) IBOutlet UIButton *continueShoppingButton;
@property (nonatomic, strong) NSMutableArray *cartListDataArray;
@property (nonatomic, strong) NSDictionary *finalCheckoutPriceDict;
@property (nonatomic, strong) NSString *orderId;

@end
