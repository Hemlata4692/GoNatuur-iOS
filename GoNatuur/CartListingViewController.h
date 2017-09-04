//
//  CartListingViewController.h
//  GoNatuur
//
//  Created by Ranosys on 01/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartListingViewController : UIViewController
@property (nonatomic, strong) NSMutableArray *cartListDataArray;
@property (strong, nonatomic) IBOutlet UIButton *continueShoppingOutlet;
@property (strong, nonatomic) IBOutlet UIButton *nextOutlet;
@property (strong, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UITableView *cartListTableView;
@end
