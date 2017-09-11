//
//  OrderDetailViewController.m
//  GoNatuur
//
//  Created by Monika on 9/9/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderDetailCell.h"
#import "OrderModel.h"

@interface OrderDetailViewController ()
{
@private
    NSMutableArray *orderListArray;
    OrderModel *orderDataModel;
}
@property (weak, nonatomic) IBOutlet UITableView *orderDetailTable;
@end

@implementation OrderDetailViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    orderListArray = [NSMutableArray new];
    [myDelegate showIndicator];
    [self performSelector:@selector(getOrderListing) withObject:nil afterDelay:.1];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.title=NSLocalizedText(@"orderDetailTitle");
    self.navigationController.navigationBarHidden=false;
    [self addLeftBarButtonWithImage:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - end

#pragma mark TableView DataSource and Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return (orderListArray.count*2) + 1;
    }
    else {
        return 3;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0) {
//        if (indexPath.row==0) {
//            return 160;
//        } else if (indexPath.row==1) {
//            return [DynamicHeightWidth getDynamicLabelHeight:[UserDefaultManager getValue:@"emailId"] font:[UIFont montserratLightWithSize:16] widthValue:[[UIScreen mainScreen] bounds].size.width-50 heightValue:60]+10;
//        } else if (indexPath.row==2) {
//            return 80;
//        } else if (indexPath.row==3) {
//            return 55;
//        }
//    }
//    else  {
//        float height =[DynamicHeightWidth getDynamicLabelHeight:orderDataModel.shippingAddress font:[UIFont montserratRegularWithSize:14] widthValue:_orderListTableView.frame.size.width-132 heightValue:50];
//
//        float billHeight =[DynamicHeightWidth getDynamicLabelHeight:orderDataModel.BillingAddress font:[UIFont montserratRegularWithSize:14] widthValue:_orderListTableView.frame.size.width-132 heightValue:50];
//        return 100 + height + billHeight;
//    }
//    return 0;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *simpleTableIdentifier;
    if (indexPath.section == 0) {
        if (indexPath.row < orderListArray.count*2) {
            if(indexPath.row % 2 == 0)
                simpleTableIdentifier=@"orderListPriceCell";
            else {
                simpleTableIdentifier=@"orderListNameCell";
            }
        } else if (indexPath.row == orderListArray.count*2) {
            simpleTableIdentifier=@"totalPriceCell";
        }
    }
    else {
        if (indexPath.row == 0) {
            simpleTableIdentifier=@"shippingAddressCell";
        } else  if (indexPath.row == 1) {
            simpleTableIdentifier=@"billingAddressCell";
        } else {
            simpleTableIdentifier=@"MethodTypeCell";
        }
    }
    OrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[OrderDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    //    if (indexPath.section == 0) {
    //        [cell displayData:_orderListTableView.frame.size];
    //        [cell.editProfileImage addTarget:self action:@selector(editUserImageAction:) forControlEvents:UIControlEventTouchUpInside];
    //    } else {
    //        if ([[selectedSecArray objectAtIndex:indexPath.section-1] boolValue]) {
    //            arrowView.transform = CGAffineTransformMakeRotation(M_PI_2);
    //        }
    //        else {
    //            arrowView.transform = CGAffineTransformMakeRotation(M_PI);
    //        }
    //        orderDataModel = [orderListArray objectAtIndex:indexPath.section - 1];
    //        [cell displayOrderData:_orderListTableView.frame.size orderData:orderDataModel];
    //    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320,40)];
    UILabel *orderIdLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, _orderDetailTable.frame.size.width-20, 30)];
    orderIdLabel.font = [UIFont montserratRegularWithSize:16];
    orderIdLabel.textAlignment=NSTextAlignmentLeft;
    NSMutableAttributedString *string;
    if (section == 0) {
        NSString *str=[NSString stringWithFormat:@"%@ %@",NSLocalizedText(@"PurchaseOrderHeading"), orderDataModel.purchaseOrderId];
        string = [[NSMutableAttributedString alloc]initWithString:str];
        NSRange registerTextRange = [str rangeOfString:NSLocalizedText(@"PurchaseOrderHeading")];
        [string setAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName: [UIFont montserratSemiBoldWithSize:16]} range:registerTextRange];
    }
    else {
        string = [[NSMutableAttributedString alloc]initWithString:NSLocalizedText(@"orderInfoLbael")];
    }
    orderIdLabel.attributedText=string;
    [sectionView addSubview:orderIdLabel];
    return  sectionView;
}
#pragma mark - end

#pragma mark - Web services
- (void)getOrderListing {
    orderDataModel = [OrderModel sharedUser];
    [orderDataModel getOrderListing:^(OrderModel *userData) {
        orderListArray = userData.orderListingArray;
        [_orderDetailTable reloadData];
        [myDelegate stopIndicator];
    } onfailure:^(NSError *error) {
        
    }];
}
#pragma mark - end

@end
