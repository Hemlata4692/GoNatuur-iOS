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
#import "SearchDataModel.h"

#define selectedStepColor   [UIColor colorWithRed:182.0/255.0 green:36.0/255.0 blue:70.0/255.0 alpha:1.0]
#define unSelectedStepColor [UIColor lightGrayColor]

@interface MyCartViewController ()<CartListDelegate> {
    CartListingViewController *cartListObj;
    NSMutableArray *cartListData;
    float totalCartProductPrice;
    CartDataModel *cartModelData;
}

@property (strong, nonatomic) IBOutlet UILabel *freeShippingLabel;
@property (strong, nonatomic) IBOutlet UILabel *firstStepLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondStepLabel;
@property (strong, nonatomic) IBOutlet UILabel *thirdStepLabel;
@property (strong, nonatomic) IBOutlet UILabel *fourthStepLabel;
@property (strong, nonatomic) IBOutlet UILabel *firstStepSeperetorLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondStepSeperetorLabel;
@property (strong, nonatomic) IBOutlet UILabel *thirdStepSeperetorLabel;
@property (strong, nonatomic) IBOutlet UILabel *noRecordFountLabel;
@end

@implementation MyCartViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=false;
    self.title=NSLocalizedText(@"GoNatuur");
    [self addLeftBarButtonWithImage:false];
    [self viewInitialization];
    [myDelegate showIndicator];
    [self performSelector:@selector(getCartListData) withObject:nil afterDelay:.1];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    myDelegate.tabButtonTag=@"0";
}
#pragma mark - end

#pragma mark - View customisation
- (void)viewInitialization {
    _freeShippingLabel.text=@"*FREE SHIPPING FOR ORDER $100 & ABOVE";
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
    _fourthStepLabel.translatesAutoresizingMaskIntoConstraints=true;
    _firstStepSeperetorLabel.translatesAutoresizingMaskIntoConstraints=true;
    _secondStepSeperetorLabel.translatesAutoresizingMaskIntoConstraints=true;
    _thirdStepSeperetorLabel.translatesAutoresizingMaskIntoConstraints=true;
}

- (void)setRoundedStepView {
    _firstStepLabel.layer.masksToBounds=true;
    _firstStepLabel.layer.cornerRadius=11;
    _secondStepLabel.layer.masksToBounds=true;
    _secondStepLabel.layer.cornerRadius=11;
    _thirdStepLabel.layer.masksToBounds=true;
    _thirdStepLabel.layer.cornerRadius=11;
    _fourthStepLabel.layer.masksToBounds=true;
    _fourthStepLabel.layer.cornerRadius=11;
}

- (void)setDefaultStepColor {
    _firstStepLabel.backgroundColor=unSelectedStepColor;
    _firstStepSeperetorLabel.backgroundColor=unSelectedStepColor;
    _secondStepLabel.backgroundColor=unSelectedStepColor;
    _secondStepSeperetorLabel.backgroundColor=unSelectedStepColor;
    _thirdStepLabel.backgroundColor=unSelectedStepColor;
    _thirdStepSeperetorLabel.backgroundColor=unSelectedStepColor;
    _fourthStepLabel.backgroundColor=unSelectedStepColor;
}

- (void)customizedSteps {
    //Remove autolayout
    [self removeAutolayout];
    //Set round step labels
    [self setRoundedStepView];
    //Get single step separator width according to screen size
    float singleSeparatorWidth=([[UIScreen mainScreen] bounds].size.width-128.0)/3.0;
    _firstStepLabel.frame=CGRectMake(20, 20, 22, 22);
    _firstStepSeperetorLabel.frame=CGRectMake(_firstStepLabel.frame.origin.x+_firstStepLabel.frame.size.width-2, 27, singleSeparatorWidth+4, 8);
    _secondStepLabel.frame=CGRectMake(_firstStepSeperetorLabel.frame.origin.x+_firstStepSeperetorLabel.frame.size.width-2, 20, 22, 22);
    _secondStepSeperetorLabel.frame=CGRectMake(_secondStepLabel.frame.origin.x+_secondStepLabel.frame.size.width-2, 27, singleSeparatorWidth+4, 8);
    _thirdStepLabel.frame=CGRectMake(_secondStepSeperetorLabel.frame.origin.x+_secondStepSeperetorLabel.frame.size.width-2, 20, 22, 22);
    _thirdStepSeperetorLabel.frame=CGRectMake(_thirdStepLabel.frame.origin.x+_thirdStepLabel.frame.size.width-2, 27, singleSeparatorWidth+4, 8);
    _fourthStepLabel.frame=CGRectMake(_thirdStepSeperetorLabel.frame.origin.x+_thirdStepSeperetorLabel.frame.size.width-2, 20, 22, 22);
    //Set default color at steps
    [self setDefaultStepColor];
    [self viewCustomisation:1];
}

- (void)viewCustomisation:(int)step {
    switch (step) {
        case 1:
             _firstStepLabel.backgroundColor=selectedStepColor;
            break;
        case 2:
            _firstStepSeperetorLabel.backgroundColor=selectedStepColor;
            _secondStepLabel.backgroundColor=selectedStepColor;
            break;
        case 3:
            _secondStepSeperetorLabel.backgroundColor=selectedStepColor;
            _thirdStepLabel.backgroundColor=selectedStepColor;
            break;
        default:
             _fourthStepLabel.backgroundColor=selectedStepColor;
            break;
    }
}

- (void)addCartListView {
   cartListObj = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CartListingViewController"];
    cartListObj.view.translatesAutoresizingMaskIntoConstraints=YES;
    cartListObj.view.frame=CGRectMake(0, 195, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-255);
    cartListObj.delegate=self;
    cartListObj.cartListDataArray=[cartListData mutableCopy];
    cartListObj.cartModelData=cartModelData;
    [cartListObj.cartListTableView reloadData];
    cartListObj.totalPriceLabel.text=[NSString stringWithFormat:@"%@%.2f",[UserDefaultManager getValue:@"DefaultCurrency"],(totalCartProductPrice*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue])];
    [cartListObj.continueShoppingOutlet addTarget:self action:@selector(cartListContinueShopping:) forControlEvents:UIControlEventTouchUpInside];
    [cartListObj.nextOutlet addTarget:self action:@selector(cartListNext:) forControlEvents:UIControlEventTouchUpInside];
    [self addChildViewController:cartListObj];
    [self.view addSubview:cartListObj.view];
    [cartListObj didMoveToParentViewController:self];;
}

//Cart list delegate method
- (void)removedItemDelegate:(NSMutableArray *)updatedCartList {
    [self updateCartBadge];
    if ([updatedCartList count]>0) {
        [cartListObj.cartListTableView reloadData];
    }
    else {
        _noRecordFountLabel.hidden=false;
        [cartListObj.view removeFromSuperview];
        [cartListObj removeFromParentViewController];
    }
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
    NSString *productIds=[NSString stringWithFormat:@"%@",[[cartListData objectAtIndex:0] itemName]];
    for (int i=1; i<cartListData.count; i++) {
       productIds=[NSString stringWithFormat:@"%@,%@",productIds,[[cartListData objectAtIndex:i] itemName]];
    }
    searchData.productName=productIds;
    [searchData getProductListByNameServiceOnSuccess:^(SearchDataModel *userData)  {
       [myDelegate stopIndicator];
        totalCartProductPrice=0.0;
        //Add product image and description in already data stored data array
        for (int i=0; i<cartListData.count; i++) {
            CartDataModel *cartDataTemp=[cartListData objectAtIndex:i];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"productName == %@", cartDataTemp.itemName];
            NSArray *filteredarray = [userData.searchProductListArray filteredArrayUsingPredicate:predicate];
            if (filteredarray.count>0) {
                NSUInteger index = [userData.searchProductListArray indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
                    return [predicate evaluateWithObject:obj];
                }];
                cartDataTemp.itemDescription=[[userData.searchProductListArray objectAtIndex:index] productDescription];
                cartDataTemp.itemImageUrl=[[userData.searchProductListArray objectAtIndex:index] productImageThumbnail];
                [cartListData replaceObjectAtIndex:i withObject:cartDataTemp];
            }
            totalCartProductPrice+=([[cartDataTemp itemPrice] floatValue]*[cartDataTemp.itemQty floatValue]);
        }
        [self addCartListView];
        
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
    DLog(@"cart next");
}
//end
#pragma mark - end
@end
