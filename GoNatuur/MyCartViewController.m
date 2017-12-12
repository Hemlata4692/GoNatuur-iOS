//
//  MyCartViewController.m
//  GoNatuur
//
//  Created by Ranosys on 01/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "MyCartViewController.h"
#import "CartDataModel.h"
#import "CartListingViewController.h"
#import "CheckoutAddressViewController.h"
#import "SearchDataModel.h"
#import "ProfileModel.h"

#define selectedStepColor   [UIColor colorWithRed:182.0/255.0 green:36.0/255.0 blue:70.0/255.0 alpha:1.0]
#define unSelectedStepColor [UIColor lightGrayColor]

@interface MyCartViewController ()<CartListDelegate> {
    CartListingViewController *cartListObj;
//    CheckoutAddressViewController *checkoutAddressObj;
    NSMutableArray *cartListData, *tempDataArray;
    float totalCartProductPrice;
    CartDataModel *cartModelData;
}

@property (strong, nonatomic) IBOutlet UILabel *freeShippingLabel;
@property (strong, nonatomic) IBOutlet UILabel *firstStepLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondStepLabel;
@property (strong, nonatomic) IBOutlet UILabel *thirdStepLabel;
@property (strong, nonatomic) IBOutlet UILabel *firstStepSeperetorLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondStepSeperetorLabel;
@property (strong, nonatomic) IBOutlet UILabel *noRecordFountLabel;
@end

@implementation MyCartViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden=false;
    self.title=NSLocalizedText(@"GoNatuur");
    [self addLeftBarButtonWithImage:false];
    [myDelegate showIndicator];
    [self performSelector:@selector(getCartListData) withObject:nil afterDelay:.1];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self viewInitialization];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    myDelegate.tabButtonTag=@"0";
}
#pragma mark - end

#pragma mark - View customisation
- (void)viewInitialization {
    _freeShippingLabel.text=NSLocalizedText(@"cartListFreeShipping");
    _noRecordFountLabel.text= NSLocalizedText(@"norecord");
    _noRecordFountLabel.hidden=true;
    myDelegate.selectedCategoryIndex=-1;
    [self showSelectedTab:2];
    //Customized steps
    [self customizedSteps];
}

- (void)removeAutolayout {
    _firstStepLabel.translatesAutoresizingMaskIntoConstraints=true;
    _secondStepLabel.translatesAutoresizingMaskIntoConstraints=true;
    _thirdStepLabel.translatesAutoresizingMaskIntoConstraints=true;
    _firstStepSeperetorLabel.translatesAutoresizingMaskIntoConstraints=true;
    _secondStepSeperetorLabel.translatesAutoresizingMaskIntoConstraints=true;
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
}

- (void)addCartListView {
   cartListObj = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CartListingViewController"];
    cartListObj.view.translatesAutoresizingMaskIntoConstraints=YES;
    cartListObj.bottomView.translatesAutoresizingMaskIntoConstraints=YES;
    cartListObj.view.frame=CGRectMake(0, 195, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-255);
    [self showTotalPriceAndPoints];
    cartListObj.delegate=self;
    cartListObj.cartListDataArray=[cartListData mutableCopy];
    cartListObj.tempListDataArray=[tempDataArray mutableCopy];
    cartListObj.cartModelData=cartModelData;
    [cartListObj.cartListTableView reloadData];
    [cartListObj.continueShoppingOutlet addTarget:self action:@selector(cartListContinueShopping:) forControlEvents:UIControlEventTouchUpInside];
    [cartListObj.nextOutlet addTarget:self action:@selector(cartListNext:) forControlEvents:UIControlEventTouchUpInside];
    [self addChildViewController:cartListObj];
    [self.view addSubview:cartListObj.view];
    [cartListObj didMoveToParentViewController:self];;
}
#pragma mark - end

#pragma mark - Webservice
- (void)getCartListData {
    CartDataModel *cartData = [CartDataModel sharedUser];
    [cartData getCartListingData:^(CartDataModel *userData)  {
        cartModelData=userData;
        if (userData.itemList.count>0) {
            cartListData=[userData.itemList mutableCopy];
            [self getCartProductDetail];
        }
        else {
            _noRecordFountLabel.hidden=false;
            [myDelegate stopIndicator];
        }
    } onfailure:^(NSError *error) {
        
    }];
}

- (void)getCartProductDetail {
    SearchDataModel *searchData = [SearchDataModel sharedUser];
    NSString *productIds=[NSString stringWithFormat:@"%@",[[cartListData objectAtIndex:0] itemSku]];
    for (int i=1; i<cartListData.count; i++) {
       productIds=[NSString stringWithFormat:@"%@,%@",productIds,[[cartListData objectAtIndex:i] itemSku]];
    }
    searchData.productName=productIds;
    [searchData getProductListByNameServiceOnSuccess:^(SearchDataModel *userData)  {
        tempDataArray=[userData.searchProductListArray mutableCopy];
        totalCartProductPrice=0.0;
        float totalImpactPoint=0.0;
        //Add product image and description in already data stored data array
        for (int i=0; i<cartListData.count; i++) {
            CartDataModel *cartDataTemp=[cartListData objectAtIndex:i];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"productName == %@", cartDataTemp.itemName];
            NSArray *filteredarray = [userData.searchProductListArray filteredArrayUsingPredicate:predicate];
            if (filteredarray.count>0) {
                NSUInteger index = [userData.searchProductListArray indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
                    return [predicate evaluateWithObject:obj];
                }];
                cartDataTemp.isRedeemProduct=[[userData.searchProductListArray objectAtIndex:index] isRedeemProduct];
                if ([cartDataTemp.isRedeemProduct boolValue]) {
                    DLog(@"%@",[[userData.searchProductListArray objectAtIndex:index] productImpactPoint]);
                    cartDataTemp.productImpactPoint=[[userData.searchProductListArray objectAtIndex:index] productImpactPoint];
                }
                cartDataTemp.itemDescription=[[userData.searchProductListArray objectAtIndex:index] productDescription];
                cartDataTemp.itemImageUrl=[[userData.searchProductListArray objectAtIndex:index] productImageThumbnail];
                [cartListData replaceObjectAtIndex:i withObject:cartDataTemp];
            }
            if ([cartDataTemp.isRedeemProduct boolValue]) {
                 totalImpactPoint+=([cartDataTemp.productImpactPoint floatValue]*[cartDataTemp.itemQty floatValue]);
            }
            else {
                totalCartProductPrice+=([[cartDataTemp itemPrice] floatValue]*[cartDataTemp.itemQty floatValue]);
            }
        }
        cartModelData.impactPoints=[NSNumber numberWithFloat:totalImpactPoint];
        if (totalCartProductPrice>0) {
            cartModelData.isSimpleProductExist=[NSNumber numberWithBool:true];
        }
        else {
            cartModelData.isSimpleProductExist=[NSNumber numberWithBool:false];
        }
        if (totalImpactPoint>0) {
            cartModelData.isRedeemProductExist=[NSNumber numberWithBool:true];
        }
        else {
            cartModelData.isRedeemProductExist=[NSNumber numberWithBool:false];
        }
        [self addCartListView];
        if ((nil==[UserDefaultManager getValue:@"userId"])) {
            cartModelData.totalImpactPoints=[NSNumber numberWithInt:0];
            [myDelegate stopIndicator];
        }
        else {
            [self getImpactPoints];
        }
    } onfailure:^(NSError *error) {
    }];
}

//Get imapact point
- (void)getImpactPoints {
    ProfileModel *userData = [ProfileModel sharedUser];
    userData.pageCount=@"1";
    userData.currentPage=@"1";
    [userData getImpactPoints:^(ProfileModel *userData) {
        cartModelData.totalImpactPoints=[NSNumber numberWithInt:[userData.totalPoints intValue]];
        if (userData.creditLimit!=nil) {
            cartModelData.creditLimit=[NSNumber numberWithInt:[userData.creditLimit intValue]];
        }
        [myDelegate stopIndicator];
    } onfailure:^(NSError *error) {
        
    }];
}
#pragma mark - end

#pragma mark - IBActions
//Cart list IBActions
- (IBAction)cartListContinueShopping:(UIButton *)sender {
    UIViewController * objReveal = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
    [myDelegate.window setRootViewController:objReveal];
    [myDelegate.window setBackgroundColor:[UIColor whiteColor]];
    [myDelegate.window makeKeyAndVisible];
}

- (IBAction)cartListNext:(UIButton *)sender {
    //StoryBoard navigation
    for (int i =0; i<tempDataArray.count; i++) {
        if ([[[tempDataArray objectAtIndex:i] productType] isEqualToString:@"ticket"]) {
            cartModelData.allProductsAreEvents=@"1";
        }
        else {
            cartModelData.allProductsAreEvents=@"0";
            break;
        }
    }
    if (((nil==[UserDefaultManager getValue:@"userId"])&&[cartModelData.isRedeemProductExist boolValue])&&[cartModelData.totalImpactPoints doubleValue]<[cartModelData.impactPoints doubleValue]) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"rewardProductExistAlert") closeButtonTitle:NSLocalizedText(@"alertOk") duration:0.0f];
        return;
    }
    CheckoutAddressViewController *obj = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CheckoutAddressViewController"];
    obj.cartListDataArray=[cartListData mutableCopy];
    obj.cartModelData=[cartModelData copy];
    obj.subTotalPrice=totalCartProductPrice;
    [self.navigationController pushViewController:obj animated:YES];
}
//end
#pragma mark - end

#pragma mark - Cart list delegate method
- (void)removedItemDelegate:(NSMutableArray *)updatedCartList  updatedTempCartList:(NSMutableArray *)updatedTempCartList {
    [self updateCartBadge];
    cartListData=[updatedCartList mutableCopy];
    tempDataArray=[updatedTempCartList mutableCopy];
    if ([updatedCartList count]>0) {
        [cartListObj.cartListTableView reloadData];
    }
    else {
        _noRecordFountLabel.hidden=false;
        [cartListObj.view removeFromSuperview];
        [cartListObj removeFromParentViewController];
    }
    [self getTotalCartItemPrice];
}
#pragma mark - end

#pragma mark - Calculation for total cart item price
- (void)getTotalCartItemPrice {
    totalCartProductPrice=0.0;
    float totalImpactPoint=0.0;
    //Add product image and description in already data stored data array
    for (int i=0; i<cartListData.count; i++) {
        CartDataModel *cartDataTemp=[cartListData objectAtIndex:i];
        if ([cartDataTemp.isRedeemProduct boolValue]) {
            totalImpactPoint+=([cartDataTemp.productImpactPoint floatValue]*[cartDataTemp.itemQty floatValue]);
        }
        else {
            totalCartProductPrice+=([[cartDataTemp itemPrice] floatValue]*[cartDataTemp.itemQty floatValue]);
        }
    }
    cartListObj.totalPriceLabel.text=[NSString stringWithFormat:@"%@%.2f",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],(totalCartProductPrice*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue])];
    
    if (totalCartProductPrice>0) {
        cartModelData.isSimpleProductExist=[NSNumber numberWithBool:true];
    }
    else {
        cartModelData.isSimpleProductExist=[NSNumber numberWithBool:false];
    }
    if (totalImpactPoint>0) {
        cartModelData.isRedeemProductExist=[NSNumber numberWithBool:true];
    }
    else {
        cartModelData.isRedeemProductExist=[NSNumber numberWithBool:false];
    }
    cartModelData.impactPoints=[NSNumber numberWithFloat:totalImpactPoint];
    [self showTotalPriceAndPoints];
}

- (void)showTotalPriceAndPoints {
    if ([cartModelData.isRedeemProductExist boolValue]&&[cartModelData.isSimpleProductExist boolValue]) {
        cartListObj.bottomView.frame=CGRectMake(0, cartListObj.view.frame.size.height-128, [[UIScreen mainScreen] bounds].size.width, 121);
        cartListObj.totalBackView.hidden=true;
        cartListObj.grandTotalBackView.hidden=false;
        cartListObj.cartTotal.text=[NSString stringWithFormat:@"%@%@",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],[ConstantCode decimalFormatter:(totalCartProductPrice*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue])]];
        cartListObj.pointTotal.text=[NSString stringWithFormat:@"%dip",[cartModelData.impactPoints intValue]];
        cartListObj.grandTotal.text=[NSString stringWithFormat:@"%@ + %@",cartListObj.cartTotal.text,cartListObj.pointTotal.text];
    }
    else {
        cartListObj.bottomView.frame=CGRectMake(0, cartListObj.view.frame.size.height-80, [[UIScreen mainScreen] bounds].size.width, 80);
        cartListObj.totalBackView.hidden=false ;
        cartListObj.grandTotalBackView.hidden=true;
        if ([cartModelData.isRedeemProductExist boolValue]) {
            cartListObj.totalPriceLabel.text=[NSString stringWithFormat:@"%dip",[cartModelData.impactPoints intValue]];
        }
        else {
            cartListObj.totalPriceLabel.text=[NSString stringWithFormat:@"%@%@",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],[ConstantCode decimalFormatter:(totalCartProductPrice*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue])]];
        }
    }
}
#pragma mark - end
@end
