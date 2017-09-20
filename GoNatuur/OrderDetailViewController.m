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
#import "DynamicHeightWidth.h"
#import "CurrencyDataModel.h"
#import "UIView+Toast.h"
#import "OrderInvoiceViewController.h"

@interface OrderDetailViewController ()
{
@private
    NSMutableArray *orderListArray, *productListArray, *ticketArray;
    OrderModel *orderDataModel;
}
@property (weak, nonatomic) IBOutlet UITableView *orderDetailTable;
@property (weak, nonatomic) IBOutlet UIButton *orderShipmentButton;
@property (weak, nonatomic) IBOutlet UIButton *invoiceButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelOrderButton;
@property (weak, nonatomic) IBOutlet UILabel *noRecordLabel;
@end

@implementation OrderDetailViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    orderListArray = [NSMutableArray new];
    productListArray = [NSMutableArray new];
    ticketArray = [NSMutableArray new];
    orderDataModel = [OrderModel new];
    [myDelegate showIndicator];
    [self performSelector:@selector(getOrderListing) withObject:nil afterDelay:.1];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self setLocalisedText];
    self.navigationController.navigationBarHidden=false;
    [self addLeftBarButtonWithImage:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - end

#pragma mark TableView DataSource and Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (productListArray.count > 0) {
        return productListArray.count + 3;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0.0;
    } else if (section < productListArray.count +1) {
        return 3;
    } else if (section == productListArray.count+1) {
        return 4;
    } else {
        return 3;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 40;
    } else if (section < productListArray.count+1) {
        return 0.01;
    } else if (section == productListArray.count+1) {
        return 0.01;
    } else
        return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *simpleTableIdentifier;
    if (indexPath.section == 0) {
        
    } else  if (indexPath.section < productListArray.count+1) {
        if (indexPath.row < productListArray.count+2) {
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
    } else if (indexPath.section == productListArray.count+1) {
        if (indexPath.row == 0) {
            simpleTableIdentifier=@"subtotalPriceCell";
        } else if (indexPath.row == 1) {
            simpleTableIdentifier=@"DiscountPriceCell";
        } else if (indexPath.row == 2) {
            simpleTableIdentifier=@"taxPriceCell";
        } else {
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
    
    if (indexPath.section == 0) {
    } else if (indexPath.section < productListArray.count+1) {
        OrderModel * orderData = [productListArray objectAtIndex:indexPath.section-1];
        [cell displayProductData:_orderDetailTable.frame.size orderData:orderData ticketArray:ticketArray];
    } else if (indexPath.section == productListArray.count+1) {
        [cell displayTotalAmountData:_orderDetailTable.frame.size orderData:orderDataModel];
    } else {
        [cell displayAddressData:_orderDetailTable.frame.size orderData:orderDataModel];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 0;
    } else if (indexPath.section < productListArray.count+1) {
        OrderModel * orderData = [productListArray objectAtIndex:indexPath.section - 1];
        if (indexPath.row == 0) {
            float height =[DynamicHeightWidth getDynamicLabelHeight:orderData.productName font:[UIFont montserratLightWithSize:13] widthValue:_orderDetailTable.frame.size.width-20 heightValue:500];
            return height + 33;
        } else if (indexPath.row == 1) {
            if ([orderData.productType isEqualToString:NSLocalizedText(@"ticket")]) {
                for (int i=0; i<ticketArray.count; i++) {
                    if ([[NSString stringWithFormat:@"%@",orderData.productId] containsString:[[ticketArray objectAtIndex:i] ticketProductId]]) {
                        float height = [DynamicHeightWidth getDynamicLabelHeight:[[ticketArray objectAtIndex:i] ticketName] font:[UIFont montserratLightWithSize:13] widthValue:(_orderDetailTable.frame.size.width/2)-10 heightValue:500];
                        return height + 25;
                    }
                }
            } else {
                float height =[DynamicHeightWidth getDynamicLabelHeight:orderData.productSku font:[UIFont montserratLightWithSize:13] widthValue:_orderDetailTable.frame.size.width-20 heightValue:500];
                return height + 25;
            }
        } else if (indexPath.row == 2) {
            return 50;
        }
    } else if (indexPath.section == productListArray.count+1) {
        if (indexPath.row == 0) {
            return [DynamicHeightWidth getDynamicLabelHeight:orderDataModel.orderSubTotal font:[UIFont montserratRegularWithSize:14] widthValue:100 heightValue:500] + [DynamicHeightWidth getDynamicLabelHeight:orderDataModel.shippingAmount font:[UIFont montserratRegularWithSize:14] widthValue:100 heightValue:500] + 10;
        } else if (indexPath.row == 1) {
            if (orderDataModel.discountDescription == nil || [orderDataModel.discountDescription isEqualToString:@""]) {
                return 0;
            } else {
                float discountDiscHeight = [DynamicHeightWidth getDynamicLabelHeight:orderDataModel.discountDescription font:[UIFont montserratRegularWithSize:14] widthValue:_orderDetailTable.frame.size.width - 120 heightValue:500];
                float discountAmountHeight = [DynamicHeightWidth getDynamicLabelHeight:orderDataModel.discountAmount font:[UIFont montserratRegularWithSize:14] widthValue:100 heightValue:500];
                NSNumber *descNumber = @(discountDiscHeight);
                NSNumber *amountNumber = @(discountAmountHeight);
                NSArray *numbers = @[descNumber, amountNumber];
                numbers = [numbers sortedArrayUsingSelector:@selector(compare:)];
                float totalHeight = [[numbers lastObject] floatValue];
                return totalHeight + 5;
            }
        } else if (indexPath.row == 2) {
            if (orderDataModel.tax == nil || [orderDataModel.tax intValue] == 0) {
                return 0;
            } else {
                return [DynamicHeightWidth getDynamicLabelHeight:orderDataModel.taxAmount font:[UIFont montserratRegularWithSize:14] widthValue:100 heightValue:500] + 1;
            }
        } else {
            float discountDiscHeight = [DynamicHeightWidth getDynamicLabelHeight:NSLocalizedText(@"baseGrandTotal") font:[UIFont montserratRegularWithSize:14] widthValue:_orderDetailTable.frame.size.width - 120 heightValue:500];
            float discountAmountHeight = [DynamicHeightWidth getDynamicLabelHeight:orderDataModel.baseGrandTotal font:[UIFont montserratRegularWithSize:14] widthValue:100 heightValue:500];
            NSNumber *descNumber = @(discountDiscHeight);
            NSNumber *amountNumber = @(discountAmountHeight);
            NSArray *numbers = @[descNumber, amountNumber];
            numbers = [numbers sortedArrayUsingSelector:@selector(compare:)];
            float totalHeight = [[numbers lastObject] floatValue];
            return totalHeight + 45;
        }
    }
    else {
        if (indexPath.row == 0) {
            if (orderDataModel.fullShippingAddress == nil || [orderDataModel.fullShippingAddress[@"firstname"] isEqualToString:@""]) {
                return 0;
            } else {
                return [DynamicHeightWidth getDynamicLabelHeight:[NSString stringWithFormat:@"%@ %@",orderDataModel.fullShippingAddress[@"firstname"],orderDataModel.fullShippingAddress[@"lastname"]] font:[UIFont montserratRegularWithSize:14] widthValue:_orderDetailTable.frame.size.width-20 heightValue:500] + [DynamicHeightWidth getDynamicLabelHeight:[orderDataModel.fullShippingAddress[@"street"] componentsJoinedByString:@" "] font:[UIFont montserratRegularWithSize:13] widthValue:_orderDetailTable.frame.size.width-20 heightValue:500] + [DynamicHeightWidth getDynamicLabelHeight:[NSString stringWithFormat:@"%@ - %@, %@",orderDataModel.fullShippingAddress[@"city"],orderDataModel.fullShippingAddress[@"postcode"],orderDataModel.fullShippingAddress[@"region"]] font:[UIFont montserratRegularWithSize:13] widthValue:_orderDetailTable.frame.size.width-20 heightValue:500] + [DynamicHeightWidth getDynamicLabelHeight:[NSString stringWithFormat:@"%@ %@",NSLocalizedText(@"phoneText"),orderDataModel.fullShippingAddress[@"telephone"]] font:[UIFont montserratRegularWithSize:13] widthValue:_orderDetailTable.frame.size.width-20 heightValue:500] + 40;
            }
        } else if (indexPath.row == 1) {
            if (orderDataModel.fullBillingAddress == nil || [orderDataModel.fullBillingAddress[@"firstname"] isEqualToString:@""]) {
                return 0;
            } else {
                return [DynamicHeightWidth getDynamicLabelHeight:[NSString stringWithFormat:@"%@ %@",orderDataModel.fullBillingAddress[@"firstname"],orderDataModel.fullBillingAddress[@"lastname"]] font:[UIFont montserratRegularWithSize:14] widthValue:_orderDetailTable.frame.size.width-20 heightValue:500] + [DynamicHeightWidth getDynamicLabelHeight:[orderDataModel.fullBillingAddress[@"street"] componentsJoinedByString:@" "] font:[UIFont montserratRegularWithSize:13] widthValue:_orderDetailTable.frame.size.width-20 heightValue:500] + [DynamicHeightWidth getDynamicLabelHeight:[NSString stringWithFormat:@"%@ - %@, %@",orderDataModel.fullBillingAddress[@"city"],orderDataModel.fullBillingAddress[@"postcode"],orderDataModel.fullBillingAddress[@"region"]] font:[UIFont montserratRegularWithSize:13] widthValue:_orderDetailTable.frame.size.width-20 heightValue:500] + [DynamicHeightWidth getDynamicLabelHeight:[NSString stringWithFormat:@"%@ %@",NSLocalizedText(@"phoneText"),orderDataModel.fullBillingAddress[@"telephone"]] font:[UIFont montserratRegularWithSize:13] widthValue:_orderDetailTable.frame.size.width-20 heightValue:500] + 35;
            }
        } else {
            if ((nil==orderDataModel.shippingMethod)||[orderDataModel.shippingMethod isEqualToString:@""]) {
                return 55;
            } else {
                return [DynamicHeightWidth getDynamicLabelHeight:orderDataModel.shippingMethod font:[UIFont montserratLightWithSize:13] widthValue:(_orderDetailTable.frame.size.width/2)-15 heightValue:500]+45;
            }
        }
    }
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * sectionView;
    if (section == 0) {
        sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320,40)];
        sectionView.backgroundColor = [UIColor whiteColor];
        UILabel *orderIdLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, _orderDetailTable.frame.size.width-20, 30)];
        orderIdLabel.font = [UIFont montserratRegularWithSize:16];
        orderIdLabel.textAlignment=NSTextAlignmentLeft;
        NSMutableAttributedString *string;
        NSString *str=[NSString stringWithFormat:@"%@ %@",NSLocalizedText(@"PurchaseOrderHeading"), orderDataModel.purchaseOrderId];
        string = [[NSMutableAttributedString alloc]initWithString:str];
        NSRange registerTextRange = [str rangeOfString:NSLocalizedText(@"PurchaseOrderHeading")];
        [string setAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName: [UIFont montserratSemiBoldWithSize:16]} range:registerTextRange];
        orderIdLabel.attributedText=string;
        [sectionView addSubview:orderIdLabel];
        
    } else if (section < productListArray.count+1) {
        sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320,0)];
        sectionView.backgroundColor = [UIColor clearColor];
        return sectionView;
    } else if (section == productListArray.count+1) {
        sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320,0)];
        sectionView.backgroundColor = [UIColor clearColor];
        return sectionView;
    }
    else {
        sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320,40)];
        sectionView.backgroundColor = [UIColor whiteColor];
        UILabel *orderIdLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, _orderDetailTable.frame.size.width-20, 30)];
        orderIdLabel.font = [UIFont montserratSemiBoldWithSize:16];
        orderIdLabel.textAlignment=NSTextAlignmentLeft;
        NSMutableAttributedString *string;
        string = [[NSMutableAttributedString alloc]initWithString:NSLocalizedText(@"orderInfoLbael")];
        orderIdLabel.attributedText=string;
        [sectionView addSubview:orderIdLabel];
    }
    return  sectionView;
    
}
#pragma mark - end

#pragma mark - Web services
- (void)getOrderListing {
    OrderModel * orderData = [OrderModel sharedUser];
    orderData.pageSize=[NSNumber numberWithInt:0];
    orderData.currentPage=[NSNumber numberWithInt:0];
    [orderData getOrderListing:^(OrderModel *userData) {
        orderDataModel = [userData.orderListingArray objectAtIndex:_selectedIndex];
        productListArray = [[[userData.orderListingArray objectAtIndex:_selectedIndex] productListingArray] mutableCopy];
        if (productListArray.count==0) {
            _noRecordLabel.hidden=NO;
            _orderDetailTable.hidden = YES;
            [_orderDetailTable reloadData];
        }
        else {
            _noRecordLabel.hidden=YES;
            _orderDetailTable.hidden = NO;
            [self setTableFrames];
            [_orderDetailTable reloadData];
            [self performSelector:@selector(getTicketOption) withObject:nil afterDelay:.1];
        }
    } onfailure:^(NSError *error) {
        _noRecordLabel.hidden=NO;
        _orderDetailTable.hidden = YES;
    }];
}

- (void)cancelOrderService {
    OrderModel *orderData = [OrderModel sharedUser];
    orderData.purchaseOrderId = orderDataModel.purchaseOrderId;
    [orderData cancelOrderService:^(OrderModel *userData) {
        [myDelegate stopIndicator];
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert addButton:NSLocalizedText(@"alertOk") actionBlock:^(void) {
            orderDataModel.orderState = NSLocalizedText(@"cancel");
            [self setTableFrames];
        }];
        [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"cancelOrderSuccessMessage") closeButtonTitle:nil duration:0.0f];
    } onfailure:^(NSError *error) {
        
    }];
}

- (void)getTicketOption {
    OrderModel *orderData = [OrderModel sharedUser];
    orderData.orderId = orderDataModel.orderId;
    [orderData getTicketOption:^(OrderModel *userData) {
        ticketArray = userData.ticketListingArray;
        [myDelegate stopIndicator];
        [_orderDetailTable reloadData];
    } onfailure:^(NSError *error) {
        
    }];
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)orderShipmentButtonAction:(id)sender {
    [self.view makeToast:NSLocalizedText(@"featureNotAvailable")];
}

- (IBAction)invoiceButtonAction:(id)sender {
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OrderInvoiceViewController * nextView=[storyBoard instantiateViewControllerWithIdentifier:@"OrderInvoiceViewController"];
    nextView.orderId=orderDataModel.orderId;
    [self.navigationController pushViewController:nextView animated:YES];
}

- (IBAction)cancelOrderButtonAction:(id)sender {
    if ([_cancelOrderButton.titleLabel.text isEqualToString:NSLocalizedText(@"cancelOrder")]) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert addButton:NSLocalizedText(@"alertOk") actionBlock:^(void) {
            [myDelegate showIndicator];
            [self performSelector:@selector(cancelOrderService) withObject:nil afterDelay:.1];
        }];
        [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"cancelOrderMessage") closeButtonTitle:NSLocalizedText(@"alertCancel") duration:0.0f];
    } else {
        [self.view makeToast:NSLocalizedText(@"featureNotAvailable")];
    }
}
#pragma mark - end

#pragma mark - Set table frames
- (void)setTableFrames {
    if ([[orderDataModel.orderState lowercaseString] containsString:NSLocalizedText(@"complete")]) {
        [_cancelOrderButton setTitle:NSLocalizedText(@"returnOrder") forState:UIControlStateNormal];
        _cancelOrderButton.hidden = NO;
        _orderShipmentButton.hidden = NO;
        _invoiceButton.hidden = NO;
    } else if ([[orderDataModel.orderState lowercaseString] containsString:[NSLocalizedText(@"cancel")lowercaseString]] || [[orderDataModel.orderStatus lowercaseString] containsString:NSLocalizedText(@"close")] || [[orderDataModel.orderStatus lowercaseString] containsString:NSLocalizedText(@"return")]) {
        _cancelOrderButton.hidden = YES;
        _invoiceButton.hidden = NO;
        _orderShipmentButton.hidden = NO;
        _orderDetailTable.translatesAutoresizingMaskIntoConstraints=YES;
        _orderShipmentButton.translatesAutoresizingMaskIntoConstraints=YES;
        _invoiceButton.translatesAutoresizingMaskIntoConstraints=YES;
        _orderDetailTable.frame=CGRectMake(10, 110 ,self.view.frame.size.width - 20, (self.view.frame.size.height - 110) - 110);
        _orderShipmentButton.frame = CGRectMake(10, _orderDetailTable.frame.origin.y + _orderDetailTable.frame.size.height + 8 ,(_orderDetailTable.frame.size.width/2) - 10, 35);
        _invoiceButton.frame = CGRectMake(_orderShipmentButton.frame.origin.x + _orderShipmentButton.frame.size.width +10, _orderDetailTable.frame.origin.y + _orderDetailTable.frame.size.height + 8 ,(_orderDetailTable.frame.size.width/2), 35);
    } else {
        _cancelOrderButton.hidden = NO;
        _orderShipmentButton.hidden = NO;
        _invoiceButton.hidden = NO;
    }
}
#pragma mark - end

#pragma mark - Set localised text
- (void)setLocalisedText {
    [_cancelOrderButton setTitle:NSLocalizedText(@"cancelOrder") forState:UIControlStateNormal];
    [_invoiceButton setTitle:NSLocalizedText(@"invoiceTitle") forState:UIControlStateNormal];
    [_orderShipmentButton setTitle:NSLocalizedText(@"orderShipmentTitle") forState:UIControlStateNormal];
    self.title=NSLocalizedText(@"orderDetailTitle");
    _noRecordLabel.text=NSLocalizedText(@"norecord");
}
#pragma mark - end
@end
