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
    if (shipmentDataArray.count > 0) {
        return shipmentDataArray.count+2;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    DLog(@"%d",(int)section);
    if (shipmentDataArray.count > 0) {
        if (section==0) {
            return 0;
        }
        else if (section==shipmentDataArray.count+1) {
            return 1;
        }
        else {
            return 2;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    DLog(@"%d",(int)section);
    if (section==0) {
         return 40;
    }
    else {
        return 0.01;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        return 0;
    }
    else if (indexPath.section==shipmentDataArray.count+1) {
        OrderModel * orderData = [trackShippmentArray objectAtIndex:indexPath.row];
        return [DynamicHeightWidth getDynamicLabelHeight:orderData.productName font:[UIFont montserratLightWithSize:13] widthValue:[[UIScreen mainScreen] bounds].size.width-40-124 heightValue:1000]+20;
    }
    else {
        OrderModel * orderData = [shipmentDataArray objectAtIndex:indexPath.section-1];
        if (indexPath.row == 0) {
            float height =[DynamicHeightWidth getDynamicLabelHeight:orderData.productName font:[UIFont montserratLightWithSize:13] widthValue:[[UIScreen mainScreen] bounds].size.width-40 heightValue:500];
            return height + 33;
        } else if (indexPath.row == 1) {
            float height =[DynamicHeightWidth getDynamicLabelHeight:orderData.productSku font:[UIFont montserratLightWithSize:13] widthValue:[[UIScreen mainScreen] bounds].size.width-40 heightValue:500];
            return height + 25;
        }
    }
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    DLog(@"%d",(int)section);
    UIView * sectionView;
    if (section==0) {
        OrderModel * orderData = [shipmentDataArray objectAtIndex:[[[[sectionList objectForKey:[NSNumber numberWithInt:(int)section]] componentsSeparatedByString:@","] objectAtIndex:1] intValue]];
            sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320,40)];
            sectionView.backgroundColor = [UIColor whiteColor];
            UILabel *orderIdLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, [[UIScreen mainScreen] bounds].size.width-40, 30)];
            orderIdLabel.font = [UIFont montserratRegularWithSize:16];
            orderIdLabel.textAlignment=NSTextAlignmentLeft;
            NSMutableAttributedString *string;
        //shipment id
            NSString *str=[NSString stringWithFormat:@"%@ #%@",NSLocalizedText(@"invoice"), orderData.purchaseOrderId];
            string = [[NSMutableAttributedString alloc]initWithString:str];
            NSRange attributTextRange = [str rangeOfString:NSLocalizedText(@"invoice")];
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
    if (indexPath.section==0) {

    }
    else if (indexPath.section==shipmentDataArray.count+1) {
         simpleTableIdentifier=@"shippmentCell";
    }
    else {
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
    OrderInvoiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[OrderInvoiceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    if (indexPath.section==0) {
        
    }
   else if (indexPath.section==shipmentDataArray.count+1) {
        OrderModel * orderData = [trackShippmentArray objectAtIndex:indexPath.row];
        [cell displayTrackShippment:[[UIScreen mainScreen] bounds].size.width-40-124 orderData:orderData];
        cell.trackNumberButton.tag=indexPath.row;
        [cell.trackNumberButton addTarget:self action:@selector(navigateToTrack:) forControlEvents:UIControlEventTouchUpInside];
       
    }
    else {
            OrderModel * orderData = [shipmentDataArray objectAtIndex:indexPath.section-1];
            [cell displayProductData:[[UIScreen mainScreen] bounds].size.width-20 orderData:orderData currencyCode:orderData.currencyCode];
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
//- (void)getOrderInvoice {
//    OrderModel *orderDataModel = [OrderModel sharedUser];
//    orderDataModel.orderId=orderId;
//    orderDataModel.isOrderInvoice=true;
//    orderDataModel.isTrackShippment=false;
//    [orderDataModel getOrderInvoiceOnSuccess:^(OrderModel *userData) {
//        shipmentDataArray=userData.orderInvoiceArray;
//        sectionList=[NSMutableDictionary new];
//        int i=-1;
//        for (int k=0; k<shipmentDataArray.count; k++) {
//            OrderModel *tempModel=shipmentDataArray[k];
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
//        if (shipmentDataArray.count==0) {
//            [myDelegate stopIndicator];
//            _noRecordLabel.hidden=NO;
//            _orderShipmentTableView.hidden = YES;
//        }
//        else {
//            _noRecordLabel.hidden=YES;
//            _orderShipmentTableView.hidden = NO;
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
        shipmentDataArray=userData.orderShipmentDataArray;
        trackShippmentArray=userData.trackArray;
        [_orderShipmentTableView reloadData];
        
    } onfailure:^(NSError *error) {
        
    }];
}
#pragma mark - end



@end
