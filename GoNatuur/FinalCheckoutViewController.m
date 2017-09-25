//
//  FinalCheckoutViewController.m
//  GoNatuur
//
//  Created by Ranosys on 12/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "FinalCheckoutViewController.h"
#import "FinalCheckoutTableViewCell.h"

#define selectedStepColor   [UIColor colorWithRed:182.0/255.0 green:36.0/255.0 blue:70.0/255.0 alpha:1.0]
#define unSelectedStepColor [UIColor lightGrayColor]
#define borderRadioColor [UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0]
#define paymentBorderColor [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.3]
#define selectedPaymentMethodColor  [UIColor colorWithRed:250.0/255.0 green:241.0/255.0 blue:244.0/255.0 alpha:1.0]

@interface FinalCheckoutViewController () {
@private
    NSMutableArray *paymentMethodArray;
    NSDictionary *cartItemPrice;
    int selectedPaymentMethodIndex;
    NSArray *totalArray;
    NSMutableDictionary *totalDict, *paymentMethodDict;
    bool isCyberSourceExist, isApplyCouponExist;
    bool isCreditUser;
}
//View objects declaration
@property (strong, nonatomic) IBOutlet UILabel *freeShippingLabel;
@property (strong, nonatomic) IBOutlet UILabel *firstStepLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondStepLabel;
@property (strong, nonatomic) IBOutlet UILabel *thirdStepLabel;
@property (strong, nonatomic) IBOutlet UILabel *firstStepSeperetorLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondStepSeperetorLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UITableView *cartItemsTableView;
@property (strong, nonatomic) IBOutlet UIView *cartListView;
@property (strong, nonatomic) IBOutlet UILabel *summaryLabel;
@property (strong, nonatomic) IBOutlet UIView *paymentView;
@property (strong, nonatomic) IBOutlet UIView *cyberSourceView;
@property (strong, nonatomic) IBOutlet UICollectionView *paymentCollectionView;
@end

@implementation FinalCheckoutViewController
@synthesize cartModelData;
@synthesize cartListDataArray;
@synthesize finalCheckoutPriceDict;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewInitialization];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=false;
    self.title=NSLocalizedText(@"GoNatuur");
    [self addLeftBarButtonWithImage:true];
//    [myDelegate showIndicator];
//    [self performSelector:@selector(setPaymentMethod) withObject:nil afterDelay:.1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - View customisation
- (void)viewInitialization {
    [self showSelectedTab:2];
    //Customized steps
    [self customizedSteps];
    [self setLocalizedText];
    totalDict=[NSMutableDictionary new];
    totalArray=@[];
    [finalCheckoutPriceDict setObject:[NSNumber numberWithDouble:0.0] forKey:@"ApplyCoupon"];
    [finalCheckoutPriceDict setObject:[NSNumber numberWithDouble:0.0] forKey:@"Credit amount"];
    [self setPrices];
    
    [self getDataFromCartModel];
    [self customizedFraming];
}

- (void)removeAutolayout {
    _firstStepLabel.translatesAutoresizingMaskIntoConstraints=true;
    _secondStepLabel.translatesAutoresizingMaskIntoConstraints=true;
    _thirdStepLabel.translatesAutoresizingMaskIntoConstraints=true;
    _firstStepSeperetorLabel.translatesAutoresizingMaskIntoConstraints=true;
    _secondStepSeperetorLabel.translatesAutoresizingMaskIntoConstraints=true;
    _mainView.translatesAutoresizingMaskIntoConstraints=true;
    _cartListView.translatesAutoresizingMaskIntoConstraints=true;
    _cartItemsTableView.translatesAutoresizingMaskIntoConstraints=true;
    _paymentView.translatesAutoresizingMaskIntoConstraints=true;
    _cyberSourceView.translatesAutoresizingMaskIntoConstraints=true;
    _paymentCollectionView.translatesAutoresizingMaskIntoConstraints=true;
}

- (void)setRoundedStepView {
    _firstStepLabel.layer.masksToBounds=true;
    _firstStepLabel.layer.cornerRadius=11;
    _secondStepLabel.layer.masksToBounds=true;
    _secondStepLabel.layer.cornerRadius=11;
    _thirdStepLabel.layer.masksToBounds=true;
    _thirdStepLabel.layer.cornerRadius=11;
}

- (void)setDefaultStepColor {
    _firstStepLabel.backgroundColor=unSelectedStepColor;
    _firstStepSeperetorLabel.backgroundColor=unSelectedStepColor;
    _secondStepLabel.backgroundColor=unSelectedStepColor;
    _secondStepSeperetorLabel.backgroundColor=unSelectedStepColor;
    _thirdStepLabel.backgroundColor=unSelectedStepColor;
}

- (void)customizedSteps {
    //Remove autolayout
    [self removeAutolayout];
    //Set round step labels
    [self setRoundedStepView];
    //Get single step separator width according to screen size
    float singleSeparatorWidth=([[UIScreen mainScreen] bounds].size.width-106.0)/2.0;
    _firstStepLabel.frame=CGRectMake(20, 20, 22, 22);
    _firstStepSeperetorLabel.frame=CGRectMake(_firstStepLabel.frame.origin.x+_firstStepLabel.frame.size.width-2, 27, singleSeparatorWidth+4, 8);
    _secondStepLabel.frame=CGRectMake(_firstStepSeperetorLabel.frame.origin.x+_firstStepSeperetorLabel.frame.size.width-2, 20, 22, 22);
    _secondStepSeperetorLabel.frame=CGRectMake(_secondStepLabel.frame.origin.x+_secondStepLabel.frame.size.width-2, 27, singleSeparatorWidth+4, 8);
    _thirdStepLabel.frame=CGRectMake(_secondStepSeperetorLabel.frame.origin.x+_secondStepSeperetorLabel.frame.size.width-2, 20, 22, 22);
    //Set default color at steps
    [self setDefaultStepColor];
    _firstStepLabel.backgroundColor=selectedStepColor;
    _firstStepSeperetorLabel.backgroundColor=selectedStepColor;
    _secondStepLabel.backgroundColor=selectedStepColor;
    _secondStepSeperetorLabel.backgroundColor=selectedStepColor;
    _thirdStepLabel.backgroundColor=selectedStepColor;
}

- (void)setLocalizedText {
    //Set localized string
    _freeShippingLabel.text=NSLocalizedText(@"cartListFreeShipping");
    _summaryLabel.text=NSLocalizedText(@"summary");
}

- (void)customizedFraming {
    if ((nil==[UserDefaultManager getValue:@"userId"])) {
        _cartItemsTableView.frame=CGRectMake(0, 35, [[UIScreen mainScreen] bounds].size.width, (93*cartListDataArray.count)+(totalArray.count*35)+55);
    }
    else {
        _cartItemsTableView.frame=CGRectMake(0, 35, [[UIScreen mainScreen] bounds].size.width, (93*cartListDataArray.count)+(totalArray.count*35));
    }
    _cartListView.frame=CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, _cartItemsTableView.frame.size.height+_cartItemsTableView.frame.origin.y);
    
    if (isCyberSourceExist&&paymentMethodArray.count>1) {
         _cyberSourceView.frame=CGRectMake(0, 34, [[UIScreen mainScreen] bounds].size.width-30, 44);
         _paymentCollectionView.frame=CGRectMake(0, _cyberSourceView.frame.origin.y+_cyberSourceView.frame.size.height+17, [[UIScreen mainScreen] bounds].size.width-30, 78);
    }
    else if (isCyberSourceExist) {
        _cyberSourceView.frame=CGRectMake(0, 34, [[UIScreen mainScreen] bounds].size.width-30, 44);
        _paymentCollectionView.frame=CGRectMake(0, 95, [[UIScreen mainScreen] bounds].size.width-30, 0);
    }
    else if (!isCyberSourceExist&&paymentMethodArray.count>0) {
        _cyberSourceView.frame=CGRectMake(0, 34, [[UIScreen mainScreen] bounds].size.width-30, 0);
        _paymentCollectionView.frame=CGRectMake(0, 34, [[UIScreen mainScreen] bounds].size.width-30, 78);
    }
    else {
        _cyberSourceView.frame=CGRectMake(0, 34, [[UIScreen mainScreen] bounds].size.width-30, 0);
        _paymentCollectionView.frame=CGRectMake(0, 34, [[UIScreen mainScreen] bounds].size.width-30, 0);
    }
    
    if ((_cyberSourceView.frame.size.height==0)&&(_paymentCollectionView.frame.size.height==0)) {
        _paymentView.frame=CGRectMake(15, _cartListView.frame.size.height+_cartListView.frame.origin.y+8, [[UIScreen mainScreen] bounds].size.width-30, 0);
    }
    else {
        _paymentView.frame=CGRectMake(15, _cartListView.frame.size.height+_cartListView.frame.origin.y+8, [[UIScreen mainScreen] bounds].size.width-30, (_cyberSourceView.frame.size.height==0?(_paymentCollectionView.frame.origin.y+_paymentCollectionView.frame.size.height):(_cyberSourceView.frame.origin.y+_cyberSourceView.frame.size.height+17+_paymentCollectionView.frame.size.height)));
    }
    _mainView.frame=CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, _paymentView.frame.size.height+_paymentView.frame.origin.y+10);
    [_paymentCollectionView reloadData];
    
    _cyberSourceView.layer.cornerRadius=22;
    [_cyberSourceView addShadow:_cyberSourceView color:[UIColor blackColor]];
}

- (void)getDataFromCartModel {
    selectedPaymentMethodIndex=-1;
    DLog(@"%@",[cartModelData.checkoutFinalData objectForKey:@"payment_methods"]);
    paymentMethodArray=[NSMutableArray arrayWithObjects:@"magedelight_cybersource", @"paypal", @"tenpaypayment", @"aliChat", nil];
    isCyberSourceExist=false;
    paymentMethodDict=[NSMutableDictionary new];
    for (NSDictionary *tempDict in [cartModelData.checkoutFinalData objectForKey:@"payment_methods"]) {
        if ([tempDict[@"code"] isEqualToString:@"magedelight_cybersource"]) {
            isCyberSourceExist=true;
            [paymentMethodDict setObject:[tempDict copy] forKey:@"magedelight_cybersource"];
            continue;
        }
        else if ([tempDict[@"code"] isEqualToString:@"tenpaypayment"]) {
            [paymentMethodDict setObject:[tempDict copy] forKey:@"tenpaypayment"];
            continue;
        }
        else if ([tempDict[@"code"] isEqualToString:@"paypal"]) {
            [paymentMethodDict setObject:[tempDict copy] forKey:@"paypal"];
            continue;
        }
        else if ([tempDict[@"code"] isEqualToString:@"aliChat"]) {
            [paymentMethodDict setObject:[tempDict copy] forKey:@"aliChat"];
            continue;
        }
    }
    
    [paymentMethodDict setObject:[NSDictionary new] forKey:@"paypal"];
    [paymentMethodDict setObject:[NSDictionary new] forKey:@"aliChat"];
    NSMutableArray *tempArray=[paymentMethodArray mutableCopy];
    for (NSString *temp in tempArray) {
        if (![[paymentMethodDict allKeys] containsObject:temp]) {
            [paymentMethodArray removeObject:temp];
        }
    }
    cartItemPrice=[[cartModelData.checkoutFinalData objectForKey:@"totals"] copy];
}

- (void)setPrices {
    isApplyCouponExist=true;
    //For guest user
    if ((nil==[UserDefaultManager getValue:@"userId"])) {
        totalArray=@[@"Cart subtotal", @"Shipping charges", @"Apply coupon code", @"Grand Total"];
        [totalDict setObject:[NSString stringWithFormat:@"%@%.2f",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],([finalCheckoutPriceDict[@"Cart subtotal"] floatValue]*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue])] forKey:@"Cart subtotal"];
        [totalDict setObject:[NSString stringWithFormat:@"%@%.2f",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],(([finalCheckoutPriceDict[@"Cart subtotal"] floatValue]+[finalCheckoutPriceDict[@"Shipping charges"] floatValue])*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue])] forKey:@"Grand Total"];
    }
    else if (isCreditUser) {
        [self setPriceForCreditUser];
    }
    else {
        [self setPriceForCashUser];
    }
    [totalDict setObject:[NSString stringWithFormat:@"%@%.2f",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],([finalCheckoutPriceDict[@"Shipping charges"] floatValue]*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue])] forKey:@"Shipping charges"];
}

- (void)setPriceForCashUser {
    //Only for redeem products with apply coupon code
    if (![cartModelData.isSimpleProductExist boolValue]&&[cartModelData.isRedeemProductExist boolValue]&&([finalCheckoutPriceDict[@"Shipping charges"] floatValue]-[finalCheckoutPriceDict[@"Discount"] floatValue])>0) {
        totalArray=@[@"Points subtotal", @"Shipping charges", @"Discount", @"Apply coupon code", @"Grand Total"];
    }
     //Only for redeem products without apply coupon code
    else if (![cartModelData.isSimpleProductExist boolValue]&&[cartModelData.isRedeemProductExist boolValue]) {
        isApplyCouponExist=false;
        totalArray=@[@"Points subtotal", @"Shipping charges", @"Discount", @"Grand Total"];
        
    }
    //Only for simple products
    else if ([cartModelData.isSimpleProductExist boolValue]&&![cartModelData.isRedeemProductExist boolValue]) {
        totalArray=@[@"Cart subtotal", @"Shipping charges", @"Discount", @"Apply coupon code", @"Grand Total"];
    }
    //For both simple and redeem products
    else {
        totalArray=@[@"Cart subtotal", @"Points subtotal", @"Shipping charges", @"Discount", @"Apply coupon code", @"Grand Total"];
    }
}

- (void)setPriceForCreditUser {
    //Only for redeem products
    if (![cartModelData.isSimpleProductExist boolValue]&&[cartModelData.isRedeemProductExist boolValue]) {
        totalArray=@[@"Points subtotal", @"Shipping charges", @"Discount", @"Grand Total"];
    }
    //Only for simple products
    else if ([cartModelData.isSimpleProductExist boolValue]&&![cartModelData.isRedeemProductExist boolValue]) {
        totalArray=@[@"Cart subtotal", @"Shipping charges", @"Discount", @"Grand Total"];
    }
    //For both simple and redeem products
    else {
        totalArray=@[@"Cart subtotal", @"Points subtotal", @"Shipping charges", @"Discount", @"Grand Total"];
    }
}
#pragma mark - end

#pragma mark - Table view datasource delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ((nil==[UserDefaultManager getValue:@"userId"])) {
        return cartListDataArray.count+totalArray.count+1;
    }
    else {
        return cartListDataArray.count+totalArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FinalCheckoutTableViewCell *cell;
    NSString *simpleTableIdentifier;
    if (indexPath.row<cartListDataArray.count) {
        simpleTableIdentifier=@"cartListCell";
    }
    else {
        if ((nil==[UserDefaultManager getValue:@"userId"])&&(indexPath.row==(cartListDataArray.count+totalArray.count))) {
            simpleTableIdentifier=@"infoCell";
        }
        else {
            simpleTableIdentifier=@"priceCell";
        }
    }
    cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[FinalCheckoutTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    if (indexPath.row<cartListDataArray.count) {
        [cell displayCartListData:[cartListDataArray objectAtIndex:indexPath.row] isSeparatorHide:(indexPath.row==cartListDataArray.count-1?true:false)];
    }
    else if (indexPath.row==cartListDataArray.count) {
        [cell displayPriceData:@"Cart subtotal" priceString:cartModelData.checkoutFinalData[@"grand_total"]];
    }
    else if (indexPath.row==cartListDataArray.count+1) {
        [cell displayPriceData:@"Shipping" priceString:cartModelData.checkoutFinalData[@"grand_total"]];
    }
    else if (indexPath.row==cartListDataArray.count+2) {
        [cell displayPriceData:@"Promotion discount" priceString:cartModelData.checkoutFinalData[@"grand_total"]];
    }
    else if (indexPath.row==cartListDataArray.count+3) {
        [cell displayPriceData:@"Order total" priceString:cartModelData.checkoutFinalData[@"grand_total"]];
    }
    else {}
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row<cartListDataArray.count) {
        return 93.0;
    }
    else {
        if ((nil==[UserDefaultManager getValue:@"userId"])&&(indexPath.row==(cartListDataArray.count+totalArray.count))) {
            return 55.0;
        }
        else {
            return 35.0;
        }
    }
}
#pragma mark - end

#pragma mark - Collection view datasource methods
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    if (nil!=paymentMethodDict) {
        if (isCyberSourceExist) {
            return paymentMethodArray.count-1;
        }
        else {
            return paymentMethodArray.count;
        }
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.contentView.layer.cornerRadius=5;
    cell.contentView.layer.masksToBounds=true;
    cell.contentView.layer.borderColor=paymentBorderColor.CGColor;
    cell.contentView.layer.borderWidth=1;
    UIImageView *paymentmethodImageView=(UIImageView *)[cell viewWithTag:1];
    int index;
    if (isCyberSourceExist) {
        index=(int)indexPath.row+1;
    }
    else {
        index=(int)indexPath.row;
    }
    DLog(@"%@",[paymentMethodArray objectAtIndex:index]);
    if ([[paymentMethodArray objectAtIndex:index] isEqualToString:@"tenpaypayment"]) {
         paymentmethodImageView.image=[UIImage imageNamed:@"weChatPayIcon.png"];
    }
    else if ([[paymentMethodArray objectAtIndex:index] isEqualToString:@"paypal"]) {
        paymentmethodImageView.image=[UIImage imageNamed:@"paypalIcon.png"];
    }
    else if ([[paymentMethodArray objectAtIndex:index] isEqualToString:@"aliChat"]) {
         paymentmethodImageView.image=[UIImage imageNamed:@"alipayIcon.png"];
    }
    
    if (selectedPaymentMethodIndex==index) {
        cell.contentView.backgroundColor=selectedPaymentMethodColor;
    }
    else {
        cell.contentView.backgroundColor=[UIColor whiteColor];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    //You may want to create a divider to scale the size by the way.
    float picDimension;
    if (isCyberSourceExist) {
        picDimension = (self.view.frame.size.width-30) / (float)(paymentMethodArray.count-1);
    }
    else {
        picDimension = (self.view.frame.size.width-30) / (float)paymentMethodArray.count;
    }
    return CGSizeMake(picDimension-5, 79);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (isCyberSourceExist) {
        selectedPaymentMethodIndex=(int)indexPath.row+1;
    }
    else {
        selectedPaymentMethodIndex=(int)indexPath.row;
    }
    [_paymentCollectionView reloadData];
}
#pragma mark - end

#pragma mark - Webservice
- (void)setPaymentMethod {
    CartDataModel *cartData = [CartDataModel sharedUser];
    cartData.paymentMethod=@"cashondelivery";
    [cartData setPaymentMethodOnSuccess:^(CartDataModel *shippmentDetailData)  {
        [self setCheckoutOrder];
//        [myDelegate stopIndicator];
    } onfailure:^(NSError *error) {
        
    }];
}

- (void)setCheckoutOrder {
    CartDataModel *cartData = [CartDataModel sharedUser];
     cartData.paymentMethod=@"cashondelivery";
    [cartData setCheckoutOrderOnSuccess:^(CartDataModel *shippmentDetailData)  {
        [myDelegate stopIndicator];
    } onfailure:^(NSError *error) {
        
    }];
}
#pragma mark - end
@end
