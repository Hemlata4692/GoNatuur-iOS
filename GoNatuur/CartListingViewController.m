//
//  CartListingViewController.m
//  GoNatuur
//
//  Created by Ranosys on 01/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "CartListingViewController.h"
#import "DynamicHeightWidth.h"
#import "CartDataModel.h"
#import "CartListTableViewCell.h"

@interface CartListingViewController ()

@property (strong, nonatomic) IBOutlet UILabel *totalLabel;
@end

@implementation CartListingViewController
@synthesize cartListDataArray;
@synthesize continueShoppingOutlet;
@synthesize nextOutlet;
@synthesize totalPriceLabel;
@synthesize cartListTableView;
@synthesize cartModelData;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [continueShoppingOutlet setTitle:NSLocalizedText(@"cartListContinueShopping") forState:UIControlStateNormal];
    [nextOutlet setTitle:NSLocalizedText(@"cartListNext") forState:UIControlStateNormal];
    totalPriceLabel.text=NSLocalizedText(@"total");
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - Table view datasource delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * headerView;
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 30.0)];
    headerView.backgroundColor = [UIColor whiteColor];
    //Item label
    UILabel *itemLabel=[[UILabel alloc] initWithFrame:CGRectMake(8, 0, 70, headerView.frame.size.height)];
    itemLabel.font=[UIFont montserratRegularWithSize:11];
    itemLabel.textAlignment=NSTextAlignmentCenter;
    itemLabel.text=NSLocalizedText(@"cartListitems");
    //Description label
    UILabel *descriptionLabel=[[UILabel alloc] initWithFrame:CGRectMake(88, 0, [[UIScreen mainScreen] bounds].size.width-228, headerView.frame.size.height)];
    descriptionLabel.textAlignment=NSTextAlignmentCenter;
    descriptionLabel.font=[UIFont montserratRegularWithSize:11];
    descriptionLabel.text=NSLocalizedText(@"cartListDescription");
    //Total label
    UILabel *priceLabel=[[UILabel alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-62, 0, 54, headerView.frame.size.height)];
    priceLabel.font=[UIFont montserratRegularWithSize:11];
    priceLabel.text=NSLocalizedText(@"cartListTotal");
    priceLabel.textAlignment=NSTextAlignmentCenter;
    //Quantity label
    UILabel *quantityLabel=[[UILabel alloc] initWithFrame:CGRectMake(priceLabel.frame.origin.x-71, 0, 64, headerView.frame.size.height)];
    quantityLabel.font=[UIFont montserratRegularWithSize:11];
    quantityLabel.text=NSLocalizedText(@"cartListQuantity");
    quantityLabel.textAlignment=NSTextAlignmentCenter;
    [headerView addSubview:itemLabel];
    [headerView addSubview:descriptionLabel];
    [headerView addSubview:quantityLabel];
    [headerView addSubview:priceLabel];
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return cartListDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *simpleTableIdentifier=@"cartListCell";
    CartListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[CartListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.removeItem.tag=(int)indexPath.row;
    [cell.removeItem addTarget:self action:@selector(removeCartItem:) forControlEvents:UIControlEventTouchUpInside];
    [cell displayCartListData:[cartListDataArray objectAtIndex:indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    float height=10;
    height+=[DynamicHeightWidth getDynamicLabelHeight:[[cartListDataArray objectAtIndex:indexPath.row] itemName] font:[UIFont montserratRegularWithSize:11] widthValue:[[UIScreen mainScreen] bounds].size.width-228];
    height+=15;
    height+=[DynamicHeightWidth getDynamicLabelHeight:[[cartListDataArray objectAtIndex:indexPath.row] itemDescription] font:[UIFont montserratRegularWithSize:11] widthValue:[[UIScreen mainScreen] bounds].size.width-228];
    height+=10;
    if (height<90) {
        return 90;
    }
    return height+20;
}
#pragma mark - end

#pragma mark - Webservice
- (void)removeCartListData:(NSNumber *)index {
    CartDataModel *cartData = [CartDataModel sharedUser];
    cartData.itemId=[[cartListDataArray objectAtIndex:[index intValue]] itemId];
    cartData.itemQuoteId=[[cartListDataArray objectAtIndex:[index intValue]] itemQuoteId];
    [cartData removeItemFromCart:^(CartDataModel *userData)  {
        [myDelegate stopIndicator];
        NSMutableDictionary *cartTempDataDict=[cartModelData.cartListResponse mutableCopy];
        if ((nil==[UserDefaultManager getValue:@"userId"])){
            cartModelData.itemQty=[NSNumber numberWithInt:([cartModelData.itemQty intValue]-[[[cartListDataArray objectAtIndex:[index intValue]] itemQty] intValue])];
            [UserDefaultManager setValue:cartModelData.itemQty key:@"quoteCount"];
        }
        else {
            [cartTempDataDict setObject:[NSNumber numberWithInt:([cartTempDataDict[@"items_qty"] intValue]-[[[cartListDataArray objectAtIndex:[index intValue]] itemQty] intValue])] forKey:@"items_qty"];
            [UserDefaultManager setValue:cartTempDataDict[@"items_qty"] key:@"quoteCount"];
        }
        cartModelData.cartListResponse=[cartTempDataDict mutableCopy];
        [cartListDataArray removeObjectAtIndex:[index intValue]];
        DLog(@"%@",[UserDefaultManager getValue:@"quoteCount"]);
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"removedProduct") closeButtonTitle:NSLocalizedText(@"alertOk") duration:0.0f];
        [_delegate removedItemDelegate:[cartListDataArray mutableCopy]];
    } onfailure:^(NSError *error) {
        
    }];
}
#pragma mark - end

#pragma mark - IBAction
- (IBAction)removeCartItem:(UIButton *)sender {
    [myDelegate showIndicator];
    [self performSelector:@selector(removeCartListData:) withObject:[NSNumber numberWithInt:(int)[sender tag]] afterDelay:.1];
}
#pragma mark - end
@end
