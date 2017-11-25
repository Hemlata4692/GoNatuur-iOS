//
//  OrderShipmentViewController.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 26/11/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "OrderShipmentViewController.h"
#import "OrderModel.h"
#import "OrderInvoiceTableViewCell.h"
#import "DynamicHeightWidth.h"
#import "UIView+Toast.h"

@interface OrderShipmentViewController (){
    NSMutableArray *shipmentDataArray, *trackShippmentArray;
    NSMutableDictionary *sectionList;
}
@property (weak, nonatomic) IBOutlet UITableView *orderShipmentTableView;
@property (weak, nonatomic) IBOutlet UILabel *noRecordLabel;

@end

@implementation OrderShipmentViewController
@synthesize orderId;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=false;
    self.title=NSLocalizedText(@"orderShipment");
    _noRecordLabel.text=NSLocalizedText(@"norecord");
    [self addLeftBarButtonWithImage:true];
    shipmentDataArray=[NSMutableArray new];
//    [myDelegate showIndicator];
//    [self performSelector:@selector(getOrderInvoice) withObject:nil afterDelay:.1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - TableView DataSource and Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (shipmentDataArray.count > 0) {
        return sectionList.count+trackShippmentArray.count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    DLog(@"%d",(int)section);
    if (shipmentDataArray.count > 0) {
        if (section<sectionList.count) {
            return [[[[sectionList objectForKey:[NSNumber numberWithInt:(int)section]] componentsSeparatedByString:@","] objectAtIndex:0] intValue];
        }
        else {
            return [[[trackShippmentArray objectAtIndex:(int)(section-sectionList.count)] trackArray] count];
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
    DLog(@"%d,%d",(int)indexPath.section, (int)indexPath.row);
    if ((int)indexPath.section==6 && (int)indexPath.row==1) {
        DLog(@"%d,%d",(int)indexPath.section, (int)indexPath.row);
    }
    if (indexPath.section<sectionList.count) {
        if ([[[[sectionList objectForKey:[NSNumber numberWithInt:(int)indexPath.section]] componentsSeparatedByString:@","] objectAtIndex:0] intValue]==0) {
            return 0;
        } else if ([[[[sectionList objectForKey:[NSNumber numberWithInt:(int)indexPath.section]] componentsSeparatedByString:@","] objectAtIndex:0] intValue]==3) {
            OrderModel * orderData = [[[shipmentDataArray objectAtIndex:[[[[sectionList objectForKey:[NSNumber numberWithInt:(int)indexPath.section]] componentsSeparatedByString:@","] objectAtIndex:1] intValue]] productListingArray] objectAtIndex:[[[[sectionList objectForKey:[NSNumber numberWithInt:(int)indexPath.section]] componentsSeparatedByString:@","] objectAtIndex:2] intValue]];
            if (indexPath.row == 0) {
                float height =[DynamicHeightWidth getDynamicLabelHeight:orderData.productName font:[UIFont montserratLightWithSize:13] widthValue:[[UIScreen mainScreen] bounds].size.width-40 heightValue:500];
                return height + 33;
            } else if (indexPath.row == 1) {
                float height =[DynamicHeightWidth getDynamicLabelHeight:orderData.productSku font:[UIFont montserratLightWithSize:13] widthValue:[[UIScreen mainScreen] bounds].size.width-40 heightValue:500];
                return height + 25;
            }  else if (indexPath.row == 2) {
                return 50;
            }
        } else if ([[[[sectionList objectForKey:[NSNumber numberWithInt:(int)indexPath.section]] componentsSeparatedByString:@","] objectAtIndex:0] intValue]==4) {
            OrderModel * orderData = [shipmentDataArray objectAtIndex:[[[[sectionList objectForKey:[NSNumber numberWithInt:(int)indexPath.section]] componentsSeparatedByString:@","] objectAtIndex:1] intValue]];
            if (indexPath.row == 0) {
                return [DynamicHeightWidth getDynamicLabelHeight:orderData.orderSubTotal font:[UIFont montserratRegularWithSize:14] widthValue:100 heightValue:500] + [DynamicHeightWidth getDynamicLabelHeight:orderData.shippingAmount font:[UIFont montserratRegularWithSize:14] widthValue:100 heightValue:500] + 10;
            } else if (indexPath.row == 1) {
                if (orderData.discountDescription == nil || [orderData.discountDescription isEqualToString:@""]) {
                    return 0;
                } else {
                    float discountDiscHeight = [DynamicHeightWidth getDynamicLabelHeight:orderData.discountDescription font:[UIFont montserratRegularWithSize:14] widthValue:[[UIScreen mainScreen] bounds].size.width - 140 heightValue:500];
                    float discountAmountHeight = [DynamicHeightWidth getDynamicLabelHeight:orderData.discountAmount font:[UIFont montserratRegularWithSize:14] widthValue:100 heightValue:500];
                    NSNumber *descNumber = @(discountDiscHeight);
                    NSNumber *amountNumber = @(discountAmountHeight);
                    NSArray *numbers = @[descNumber, amountNumber];
                    numbers = [numbers sortedArrayUsingSelector:@selector(compare:)];
                    float totalHeight = [[numbers lastObject] floatValue];
                    return totalHeight + 5;
                }
            } else if (indexPath.row == 2) {
                if (orderData.taxAmount == nil || [orderData.taxAmount isEqualToString:@""]) {
                    return 0;
                } else {
                    return [DynamicHeightWidth getDynamicLabelHeight:orderData.taxAmount font:[UIFont montserratRegularWithSize:14] widthValue:100 heightValue:500] + 1;
                }
            } else {
                float discountDiscHeight = [DynamicHeightWidth getDynamicLabelHeight:@"Grand Total to be Charged" font:[UIFont montserratRegularWithSize:14] widthValue:[[UIScreen mainScreen] bounds].size.width - 140 heightValue:500];
                float discountAmountHeight = [DynamicHeightWidth getDynamicLabelHeight:orderData.baseGrandTotal font:[UIFont montserratRegularWithSize:14] widthValue:100 heightValue:500];
                NSNumber *descNumber = @(discountDiscHeight);
                NSNumber *amountNumber = @(discountAmountHeight);
                NSArray *numbers = @[descNumber, amountNumber];
                numbers = [numbers sortedArrayUsingSelector:@selector(compare:)];
                float totalHeight = [[numbers lastObject] floatValue];
                return totalHeight + 45;
            }
        }
    }
    else {
        OrderModel * orderData = [[[trackShippmentArray objectAtIndex:(int)(indexPath.section-sectionList.count)] trackArray] objectAtIndex:indexPath.row];
        return [DynamicHeightWidth getDynamicLabelHeight:orderData.productName font:[UIFont montserratLightWithSize:13] widthValue:[[UIScreen mainScreen] bounds].size.width-40-124 heightValue:1000]+20;
    }
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    DLog(@"%d",(int)section);
    UIView * sectionView;
    if (section<sectionList.count) {
        OrderModel * orderData = [shipmentDataArray objectAtIndex:[[[[sectionList objectForKey:[NSNumber numberWithInt:(int)section]] componentsSeparatedByString:@","] objectAtIndex:1] intValue]];
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
        if ([[sectionList objectForKey:[NSNumber numberWithInt:(int)indexPath.section]] intValue]==3) {
            NSInteger index = indexPath.row % 3;
            switch (index) {
                case 0:
                    simpleTableIdentifier=@"orderListNameCell";
                    break;
                case 1:
                    simpleTableIdentifier=@"EventDetailCell";
                    break;
                case 2:
                    simpleTableIdentifier=@"orderListPriceCell";
                    break;
            }
        }
        else {}
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
            OrderModel * orderData = [[[shipmentDataArray objectAtIndex:[[[[sectionList objectForKey:[NSNumber numberWithInt:(int)indexPath.section]] componentsSeparatedByString:@","] objectAtIndex:1] intValue]] productListingArray] objectAtIndex:[[[[sectionList objectForKey:[NSNumber numberWithInt:(int)indexPath.section]] componentsSeparatedByString:@","] objectAtIndex:2] intValue]];
            [cell displayProductData:[[UIScreen mainScreen] bounds].size.width-20 orderData:orderData currencyCode:orderData.currencyCode];
        }
    }
    else {
        OrderModel * orderData = [[[trackShippmentArray objectAtIndex:(int)(indexPath.section-sectionList.count)] trackArray] objectAtIndex:indexPath.row];
        [cell displayTrackShippment:[[UIScreen mainScreen] bounds].size.width-40-124 orderData:orderData];
        cell.trackNumberButton.tag=indexPath.row;
        [cell.trackNumberButton addTarget:self action:@selector(navigateToTrack:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)navigateToTrack:(UIButton *)sender {
   // [self.view makeToast:NSLocalizedText(@"featureNotAvailable")];
}
#pragma mark - end

#pragma mark - Web services
- (void)getOrderInvoice {
    OrderModel *orderDataModel = [OrderModel sharedUser];
    orderDataModel.orderId=orderId;
    orderDataModel.isOrderInvoice=true;
    orderDataModel.isTrackShippment=false;
    [orderDataModel getOrderInvoiceOnSuccess:^(OrderModel *userData) {
        shipmentDataArray=userData.orderInvoiceArray;
        sectionList=[NSMutableDictionary new];
        int i=-1;
        for (int k=0; k<shipmentDataArray.count; k++) {
            OrderModel *tempModel=shipmentDataArray[k];
            i+=1;
            [sectionList setObject:[NSString stringWithFormat:@"%@,%@",[NSNumber numberWithInt:0],[NSNumber numberWithInt:k]] forKey:[NSNumber numberWithInt:i]];
            for (int j=0; j<tempModel.productListingArray.count; j++)  {
                i+=1;
                [sectionList setObject:[NSString stringWithFormat:@"%@,%@,%@",[NSNumber numberWithInt:3],[NSNumber numberWithInt:k],[NSNumber numberWithInt:j]] forKey:[NSNumber numberWithInt:i]];
            }
            i+=1;
            [sectionList setObject:[NSString stringWithFormat:@"%@,%@",[NSNumber numberWithInt:4],[NSNumber numberWithInt:k]] forKey:[NSNumber numberWithInt:i]];
        }
        
        if (shipmentDataArray.count==0) {
            [myDelegate stopIndicator];
            _noRecordLabel.hidden=NO;
            _orderShipmentTableView.hidden = YES;
        }
        else {
            _noRecordLabel.hidden=YES;
            _orderShipmentTableView.hidden = NO;
            [self getTrackShippment];
        }
    } onfailure:^(NSError *error) {
        
    }];
}

- (void)getTrackShippment {
    OrderModel *orderDataModel = [OrderModel sharedUser];
    orderDataModel.orderId=orderId;
    orderDataModel.isTrackShippment=true;
    orderDataModel.isOrderInvoice=false;
    [orderDataModel getOrderInvoiceOnSuccess:^(OrderModel *userData) {
        [myDelegate stopIndicator];
        trackShippmentArray=userData.trackArray;
        [_orderShipmentTableView reloadData];
        
    } onfailure:^(NSError *error) {
        
    }];
}
#pragma mark - end



@end
