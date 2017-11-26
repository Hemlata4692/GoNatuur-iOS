//
//  OrderInvoiceViewController.m
//  GoNatuur
//
//  Created by Ranosys on 14/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "OrderInvoiceViewController.h"
#import "OrderModel.h"
#import "OrderInvoiceTableViewCell.h"
#import "DynamicHeightWidth.h"
#import "UIView+Toast.h"

@interface OrderInvoiceViewController () {
    NSMutableArray *itemDataArray, *trackShippmentArray;
    NSMutableDictionary *sectionList;
}

@property (strong, nonatomic) IBOutlet UITableView *orderInvoiceTableView;
@property (weak, nonatomic) IBOutlet UILabel *noRecordLabel;
@end

@implementation OrderInvoiceViewController

@synthesize orderId;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=false;
    self.title=NSLocalizedText(@"invoiceTitle");
    _noRecordLabel.text=NSLocalizedText(@"norecord");
    [self addLeftBarButtonWithImage:true];
    itemDataArray=[NSMutableArray new];
     trackShippmentArray=[NSMutableArray new];
    [myDelegate showIndicator];
    [self performSelector:@selector(getTrackShippment) withObject:nil afterDelay:.1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - TableView DataSource and Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (itemDataArray.count > 0) {
        return sectionList.count+trackShippmentArray.count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (itemDataArray.count > 0) {
        if (section<sectionList.count) {
            return [[[[sectionList objectForKey:[NSNumber numberWithInt:(int)section]] componentsSeparatedByString:@","] objectAtIndex:0] intValue];
        }
        else {
             OrderModel *orderDataModel = [OrderModel sharedUser];
            return orderDataModel.trackArray.count;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    DLog(@"%d",(int)section);
    if (section<sectionList.count) {
        if ([[[[sectionList objectForKey:[NSNumber numberWithInt:(int)section]] componentsSeparatedByString:@","] objectAtIndex:0] intValue]==0) {
            return 40;
        }
        else if (([[[[sectionList objectForKey:[NSNumber numberWithInt:(int)section]] componentsSeparatedByString:@","] objectAtIndex:0] intValue]==3)||([[[[sectionList objectForKey:[NSNumber numberWithInt:(int)section]] componentsSeparatedByString:@","] objectAtIndex:0] intValue]==4)) {
            return 0.01;
        }
        else
            return 0.01;
    }
    else {
        return 50;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
      if (indexPath.section<sectionList.count) {
        if ([[[[sectionList objectForKey:[NSNumber numberWithInt:(int)indexPath.section]] componentsSeparatedByString:@","] objectAtIndex:0] intValue]==0) {
            return 0;
        } else if ([[[[sectionList objectForKey:[NSNumber numberWithInt:(int)indexPath.section]] componentsSeparatedByString:@","] objectAtIndex:0] intValue]==3) {
            OrderModel * orderData = [[[itemDataArray objectAtIndex:[[[[sectionList objectForKey:[NSNumber numberWithInt:(int)indexPath.section]] componentsSeparatedByString:@","] objectAtIndex:1] intValue]] productListingArray] objectAtIndex:[[[[sectionList objectForKey:[NSNumber numberWithInt:(int)indexPath.section]] componentsSeparatedByString:@","] objectAtIndex:2] intValue]];
            if (indexPath.row == 0) {
                float height =[DynamicHeightWidth getDynamicLabelHeight:orderData.productName font:[UIFont montserratLightWithSize:13] widthValue:[[UIScreen mainScreen] bounds].size.width-40 heightValue:500];
                return height + 33;
            } else if (indexPath.row == 1) {
                float height =[DynamicHeightWidth getDynamicLabelHeight:orderData.productSku font:[UIFont montserratLightWithSize:13] widthValue:[[UIScreen mainScreen] bounds].size.width-40 heightValue:500];
                return height + 25;
            }  else if (indexPath.row == 2) {
                return 50;
            }
        }
    }
    else {
        OrderModel * orderData = [trackShippmentArray objectAtIndex:(int)(indexPath.section-sectionList.count)];
        return [DynamicHeightWidth getDynamicLabelHeight:orderData.productName font:[UIFont montserratLightWithSize:13] widthValue:[[UIScreen mainScreen] bounds].size.width-40-124 heightValue:1000]+20;
    }
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * sectionView;
    if (section<sectionList.count) {
        OrderModel * orderData = [itemDataArray objectAtIndex:[[[[sectionList objectForKey:[NSNumber numberWithInt:(int)section]] componentsSeparatedByString:@","] objectAtIndex:1] intValue]];
        if ([[sectionList objectForKey:[NSNumber numberWithInt:(int)section]] intValue]==0) {
            sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320,40)];
            sectionView.backgroundColor = [UIColor whiteColor];
            UILabel *orderIdLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, [[UIScreen mainScreen] bounds].size.width-40, 30)];
            orderIdLabel.font = [UIFont montserratRegularWithSize:16];
            orderIdLabel.textAlignment=NSTextAlignmentLeft;
            NSMutableAttributedString *string;
            NSString *str=[NSString stringWithFormat:@"%@ #%@",NSLocalizedText(@"invoice"), orderData.purchaseOrderId];
            string = [[NSMutableAttributedString alloc]initWithString:str];
            NSRange attributTextRange = [str rangeOfString:NSLocalizedText(@"invoice")];
            [string setAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName: [UIFont montserratSemiBoldWithSize:16]} range:attributTextRange];
            orderIdLabel.attributedText=string;
            [sectionView addSubview:orderIdLabel];
            
        } else if ([[sectionList objectForKey:[NSNumber numberWithInt:(int)section]] intValue]==3) {
            sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320,0)];
            sectionView.backgroundColor = [UIColor clearColor];
            return sectionView;
        } else if ([[sectionList objectForKey:[NSNumber numberWithInt:(int)section]] intValue]==4) {
            sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320,0)];
            sectionView.backgroundColor = [UIColor clearColor];
            return sectionView;
        }
    }
    else {
        OrderModel * orderData = [trackShippmentArray objectAtIndex:(int)(section-sectionList.count)];
        sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320,50)];
        sectionView.backgroundColor = [UIColor whiteColor];
        UILabel *orderIdLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 15, [[UIScreen mainScreen] bounds].size.width-40, 30)];
        orderIdLabel.font = [UIFont montserratRegularWithSize:16];
        orderIdLabel.textAlignment=NSTextAlignmentLeft;
        NSMutableAttributedString *string;
        NSString *str=[NSString stringWithFormat:@"%@ #%@",NSLocalizedText(@"shipment"), orderData.purchaseOrderId];
        string = [[NSMutableAttributedString alloc]initWithString:str];
        NSRange attributTextRange = [str rangeOfString:NSLocalizedText(@"shipment")];
        [string setAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName: [UIFont montserratSemiBoldWithSize:16]} range:attributTextRange];
        orderIdLabel.attributedText=string;
        [sectionView addSubview:orderIdLabel];
    }
    return  sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     DLog(@"%d,%d",(int)indexPath.section, (int)indexPath.row);
    NSString *simpleTableIdentifier=@"";
    if (indexPath.section<sectionList.count) {
    if ([[sectionList objectForKey:[NSNumber numberWithInt:(int)indexPath.section]] intValue]==2) {
            NSInteger index = indexPath.row % 2;
            switch (index) {
                case 0:
                    simpleTableIdentifier=@"orderListNameCell";
                    break;
                case 1:
                    simpleTableIdentifier=@"EventDetailCell";
                    break;
            }
    }
    }
    else {
        simpleTableIdentifier=@"shippmentCell";
    }
    OrderInvoiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[OrderInvoiceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    if (indexPath.section<sectionList.count) {
    if ([[sectionList objectForKey:[NSNumber numberWithInt:(int)indexPath.section]] intValue]==0) {
    } else if ([[sectionList objectForKey:[NSNumber numberWithInt:(int)indexPath.section]] intValue]==3) {
        OrderModel * orderData = [[[itemDataArray objectAtIndex:[[[[sectionList objectForKey:[NSNumber numberWithInt:(int)indexPath.section]] componentsSeparatedByString:@","] objectAtIndex:1] intValue]] orderShipmentDataArray] objectAtIndex:[[[[sectionList objectForKey:[NSNumber numberWithInt:(int)indexPath.section]] componentsSeparatedByString:@","] objectAtIndex:2] intValue]];
        [cell displayProductData:[[UIScreen mainScreen] bounds].size.width-20 orderData:orderData currencyCode:orderData.currencyCode];
    } 
    }
    else {
        OrderModel * orderData = [trackShippmentArray objectAtIndex:(int)(indexPath.section-sectionList.count)];
        [cell displayTrackShippment:[[UIScreen mainScreen] bounds].size.width-40-124 orderData:orderData];
        cell.trackNumberButton.tag=indexPath.row;
        [cell.trackNumberButton addTarget:self action:@selector(navigateToTrack:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)navigateToTrack:(UIButton *)sender {
    [self.view makeToast:NSLocalizedText(@"featureNotAvailable")];
}
#pragma mark - end

#pragma mark - Web services
//- (void)getOrderInvoice {
//    OrderModel *orderDataModel = [OrderModel sharedUser];
//    orderDataModel.orderId=orderId;
//    orderDataModel.isOrderInvoice=true;
//    orderDataModel.isTrackShippment=false;
//    [orderDataModel getOrderInvoiceOnSuccess:^(OrderModel *userData) {
//        itemDataArray=userData.orderInvoiceArray;
//        sectionList=[NSMutableDictionary new];
//        int i=-1;
//        for (int k=0; k<itemDataArray.count; k++) {
//            OrderModel *tempModel=itemDataArray[k];
//            i+=1;
//            [sectionList setObject:[NSString stringWithFormat:@"%@,%@",[NSNumber numberWithInt:0],[NSNumber numberWithInt:k]] forKey:[NSNumber numberWithInt:i]];
//            for (int j=0; j<tempModel.productListingArray.count; j++)  {
//                i+=1;
//                [sectionList setObject:[NSString stringWithFormat:@"%@,%@,%@",[NSNumber numberWithInt:3],[NSNumber numberWithInt:k],[NSNumber numberWithInt:j]] forKey:[NSNumber numberWithInt:i]];
//            }
//            i+=1;
//            [sectionList setObject:[NSString stringWithFormat:@"%@,%@",[NSNumber numberWithInt:4],[NSNumber numberWithInt:k]] forKey:[NSNumber numberWithInt:i]];
//        }
//
//        if (itemDataArray.count==0) {
//            [myDelegate stopIndicator];
//            _noRecordLabel.hidden=NO;
//            _orderInvoiceTableView.hidden = YES;
//        }
//        else {
//            _noRecordLabel.hidden=YES;
//            _orderInvoiceTableView.hidden = NO;
//            [self getTrackShippment];
//        }
//    } onfailure:^(NSError *error) {
//
//    }];
//}

- (void)getTrackShippment {
    OrderModel *orderDataModel = [OrderModel sharedUser];
    orderDataModel.orderId=orderId;
    orderDataModel.isTrackShippment=true;
    orderDataModel.isOrderInvoice=false;
    [orderDataModel getOrderInvoiceOnSuccess:^(OrderModel *userData) {
        [myDelegate stopIndicator];
        
        itemDataArray=userData.orderShipmentDataArray;
        sectionList=[NSMutableDictionary new];
        int i=-1;
        for (int k=0; k<itemDataArray.count; k++) {
            OrderModel *tempModel=itemDataArray[k];
            i+=1;
            [sectionList setObject:[NSString stringWithFormat:@"%@,%@",[NSNumber numberWithInt:0],[NSNumber numberWithInt:k]] forKey:[NSNumber numberWithInt:i]];
            for (int j=0; j<tempModel.productListingArray.count; j++)  {
                i+=1;
                [sectionList setObject:[NSString stringWithFormat:@"%@,%@,%@",[NSNumber numberWithInt:3],[NSNumber numberWithInt:k],[NSNumber numberWithInt:j]] forKey:[NSNumber numberWithInt:i]];
            }
            i+=1;
            [sectionList setObject:[NSString stringWithFormat:@"%@,%@",[NSNumber numberWithInt:4],[NSNumber numberWithInt:k]] forKey:[NSNumber numberWithInt:i]];
        }
        
        trackShippmentArray=[userData.trackArray mutableCopy];
        [_orderInvoiceTableView reloadData];
    } onfailure:^(NSError *error) {
        
    }];
}
#pragma mark - end

@end
