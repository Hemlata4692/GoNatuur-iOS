//
//  ThankYouViewController.m
//  GoNatuur
//
//  Created by Monika on 9/5/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "ThankYouViewController.h"
#import "ThankYouTableCell.h"
#import "DynamicHeightWidth.h"
#import "OrderModel.h"

@interface ThankYouViewController () {
    NSString *orderIncrementId;
}
@end

@implementation ThankYouViewController
@synthesize cartListDataArray,orderId;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=false;
    self.title=NSLocalizedText(@"GoNatuur");
    [self addLeftBarButtonWithImage:true];
//    orderIncrementId = orderId;
    
    [myDelegate showIndicator];
    if ([UserDefaultManager getValue:@"userId"]==nil) {
    [self performSelector:@selector(getOrderIdAfterCheckout) withObject:nil afterDelay:.1];
    }
    else {
        [self performSelector:@selector(getOrderIDLoggedin) withObject:nil afterDelay:.1];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - Table view datasource delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([[UserDefaultManager getValue:@"userId"] isEqualToString:@""]) {
        return 4+cartListDataArray.count;
    } else {
        return 3+cartListDataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *simpleTableIdentifier;
    if (indexPath.row == 0) {
        simpleTableIdentifier=@"ThankYouCell";
    } else if (indexPath.row == 1) {
        simpleTableIdentifier=@"PurchaseCell";
    } else if (indexPath.row < cartListDataArray.count+2) {
        simpleTableIdentifier=@"ProductDetailCell";
    } else if (indexPath.row == cartListDataArray.count+2) {
        simpleTableIdentifier=@"OrderTotalCell";
    } else if (indexPath.row == cartListDataArray.count+3){
        simpleTableIdentifier=@"GuestInfoCell";
    }
    ThankYouTableCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[ThankYouTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    if (indexPath.row == 0) {
        [cell displayData:_thankYouTable.frame.size orderId:orderIncrementId];
    } else if (indexPath.row == 1) {
        [cell displayPurchaseData:_thankYouTable.frame.size];
    } else if (indexPath.row < cartListDataArray.count+2) {
        [cell displayCartListData:[cartListDataArray objectAtIndex:indexPath.row - 2] rectSize:_thankYouTable.frame.size];
    }
    else if (indexPath.row == cartListDataArray.count+2) {
        [cell displayOrderTotalData:_thankYouTable.frame.size finalCheckoutPriceDict:_finalCheckoutPriceDict];
    }
    else if (indexPath.row == cartListDataArray.count+3) {
        [cell displayData:_thankYouTable.frame.size orderId:orderIncrementId];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return [DynamicHeightWidth getDynamicLabelHeight:NSLocalizedText(@"thankDescText") font:[UIFont montserratRegularWithSize:12] widthValue:_thankYouTable.frame.size.width-20 heightValue:500]+70;
    } else if (indexPath.row == 1) {
        return 30;
    } else if (indexPath.row < cartListDataArray.count+2) {
        float height=10;
        height+=[DynamicHeightWidth getDynamicLabelHeight:[[cartListDataArray objectAtIndex:indexPath.row -2] itemName] font:[UIFont montserratRegularWithSize:11] widthValue:[[UIScreen mainScreen] bounds].size.width-228];
        height+=2;
        if (height<80) {
            return 80;
        }
        return height;
    } else if (indexPath.row == cartListDataArray.count+2) {
        return 250;
    } else if (indexPath.row == cartListDataArray.count+3) {
        return [DynamicHeightWidth getDynamicLabelHeight:NSLocalizedText(@"guestMessage") font:[UIFont montserratRegularWithSize:12] widthValue:_thankYouTable.frame.size.width-20 heightValue:500]+10;
    }
    return 1;
}
#pragma mark - end

#pragma mark - Web services
- (void)getOrderIDLoggedin {
    OrderModel * orderData = [OrderModel sharedUser];
    orderData.pageSize=[NSNumber numberWithInt:1];
    orderData.currentPage=[NSNumber numberWithInt:1];
    orderData.isOrderDetailService=@"0";
    [orderData getOrderListing:^(OrderModel *userData) {
        OrderModel *orderData = [userData.orderListingArray objectAtIndex:0];
        orderIncrementId = orderData.purchaseOrderId;
        [self clearCart];
    } onfailure:^(NSError *error) {
        
    }];
}


- (void)getOrderIdAfterCheckout {
    CartDataModel * cartData = [CartDataModel sharedUser];
    cartData.clearCartEnabled=@"0";
    [cartData clearCart:^(CartDataModel *userData) {
        orderIncrementId=[NSString stringWithFormat:@"000000%@",cartData.orderIncrementId];
        [self clearCart];
    } onfailure:^(NSError *error) {
        [self clearCart];
    }];
}

- (void)clearCart {
    CartDataModel * cartData = [CartDataModel sharedUser];
    cartData.clearCartEnabled=@"1";
    [cartData clearCart:^(CartDataModel *userData) {
        [UserDefaultManager setValue:@0 key:@"quoteCount"];
        [self updateCartBadge];
        [_thankYouTable reloadData];
        [myDelegate stopIndicator];
    } onfailure:^(NSError *error) {
        
    }];
}

- (IBAction)continueShoppingAction:(id)sender {
    //Navigate to dashboard screen
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController * loginView = [storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
    [self.navigationController setViewControllers: [NSArray arrayWithObject:loginView]
                                         animated: NO];
}
#pragma mark - end
@end
