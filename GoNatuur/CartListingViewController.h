//
//  CartListingViewController.h
//  GoNatuur
//
//  Created by Ranosys on 01/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartDataModel.h"

@protocol CartListDelegate <NSObject>
@optional
- (void)removedItemDelegate:(NSMutableArray *)updatedCartList  updatedTempCartList:(NSMutableArray *)updatedTempCartList;
@end

@interface CartListingViewController : UIViewController {
    id <CartListDelegate> _delegate;
}

@property (nonatomic,strong) id <CartListDelegate>delegate;
@property (nonatomic, strong) NSMutableArray *cartListDataArray;
@property (nonatomic, strong) NSMutableArray *tempListDataArray;
@property (nonatomic, strong) CartDataModel *cartModelData;
@property (strong, nonatomic) IBOutlet UIButton *continueShoppingOutlet;
@property (strong, nonatomic) IBOutlet UIButton *nextOutlet;
@property (strong, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UITableView *cartListTableView;
@property (strong, nonatomic) IBOutlet UIView *totalBackView;
@property (strong, nonatomic) IBOutlet UIView *grandTotalBackView;
@property (strong, nonatomic) IBOutlet UILabel *pointTotal;
@property (strong, nonatomic) IBOutlet UILabel *cartTotal;
@property (strong, nonatomic) IBOutlet UILabel *grandTotal;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@end
