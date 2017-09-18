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
#define numberPriceCount 4

@interface FinalCheckoutViewController () {
@private
    NSMutableArray *paymentMethodArray;
    NSDictionary *cartItemPrice;
    int selectedPaymentMethodIndex;
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
@end

@implementation FinalCheckoutViewController
@synthesize cartModelData;
@synthesize cartListDataArray
;
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
//    [self performSelector:@selector(setCheckoutOrder) withObject:nil afterDelay:.1];
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
    [self customizedFraming];
    [self getDataFromCartModel];
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
        _cartItemsTableView.frame=CGRectMake(0, 35, [[UIScreen mainScreen] bounds].size.width, (93*cartListDataArray.count)+(numberPriceCount*35)+55);
    }
    else {
        _cartItemsTableView.frame=CGRectMake(0, 35, [[UIScreen mainScreen] bounds].size.width, (93*cartListDataArray.count)+(numberPriceCount*35));
    }
    _cartListView.frame=CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, _cartItemsTableView.frame.size.height+_cartItemsTableView.frame.origin.y);
    _mainView.frame=CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, _cartListView.frame.size.height+_cartListView.frame.origin.y+80);
}

- (void)getDataFromCartModel {
    selectedPaymentMethodIndex=-1;
    paymentMethodArray=[[cartModelData.checkoutFinalData objectForKey:@"payment_methods"] mutableCopy];
    cartItemPrice=[[cartModelData.checkoutFinalData objectForKey:@"totals"] copy];
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
        return cartListDataArray.count+numberPriceCount+1;
    }
    else {
        return cartListDataArray.count+numberPriceCount;
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
        if ((nil==[UserDefaultManager getValue:@"userId"])&&(indexPath.row==(cartListDataArray.count+numberPriceCount))) {
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
        if ((nil==[UserDefaultManager getValue:@"userId"])&&(indexPath.row==(cartListDataArray.count+numberPriceCount))) {
            return 55.0;
        }
        else {
            return 35.0;
        }
    }
}
#pragma mark - end

#pragma mark - Webservice
- (void)setPaymentMethod {
    CartDataModel *cartData = [CartDataModel sharedUser];
    cartData.paymentMethod=[[paymentMethodArray objectAtIndex:0] objectForKey:@"code"];
    [cartData setPaymentMethodOnSuccess:^(CartDataModel *shippmentDetailData)  {
        [myDelegate stopIndicator];
    } onfailure:^(NSError *error) {
        
    }];
}

- (void)setCheckoutOrder {
    CartDataModel *cartData = [CartDataModel sharedUser];
    cartData.paymentMethod=[[paymentMethodArray objectAtIndex:0] objectForKey:@"code"];
    [cartData setCheckoutOrderOnSuccess:^(CartDataModel *shippmentDetailData)  {
        [myDelegate stopIndicator];
    } onfailure:^(NSError *error) {
        
    }];
}
#pragma mark - end
@end
