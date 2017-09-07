//
//  CheckoutAddressViewController.m
//  GoNatuur
//
//  Created by Ranosys on 06/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "CheckoutAddressViewController.h"
#import "CartDataModel.h"

#define selectedStepColor   [UIColor colorWithRed:182.0/255.0 green:36.0/255.0 blue:70.0/255.0 alpha:1.0]
#define unSelectedStepColor [UIColor lightGrayColor]

@interface CheckoutAddressViewController () {
    CartDataModel *cartModelData;
}
//Other view objects declaration
@property (strong, nonatomic) IBOutlet UILabel *freeShippingLabel;
@property (strong, nonatomic) IBOutlet UILabel *firstStepLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondStepLabel;
@property (strong, nonatomic) IBOutlet UILabel *thirdStepLabel;
@property (strong, nonatomic) IBOutlet UILabel *fourthStepLabel;
@property (strong, nonatomic) IBOutlet UILabel *firstStepSeperetorLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondStepSeperetorLabel;
@property (strong, nonatomic) IBOutlet UILabel *thirdStepSeperetorLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *mainCheckoutAddressView;
@property (strong, nonatomic) IBOutlet UIButton *continueShoppingOutlet;
@property (strong, nonatomic) IBOutlet UIButton *nextOutlet;
@property (strong, nonatomic) IBOutlet UITableView *shippmentMethodTableView;
@property (strong, nonatomic) IBOutlet UILabel *redeemPointLabel;
@property (strong, nonatomic) IBOutlet UILabel *impactPointLabel;
@property (strong, nonatomic) IBOutlet UICollectionView *offersCollectionView;
//Shipping address object declaration
@property (strong, nonatomic) IBOutlet UILabel *shippingAddressTitleLabel;
@property (strong, nonatomic) IBOutlet UIButton *shippingEditAddressButton;
@property (strong, nonatomic) IBOutlet UITextField *shippingFirstNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *shippingLastNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *shippingPhoneNumberTextField;
@property (strong, nonatomic) IBOutlet UITextField *shippingEmailTextField;
@property (strong, nonatomic) IBOutlet UITextField *shippingCountryTextField;
@property (strong, nonatomic) IBOutlet UIButton *shippingCountryButton;
@property (strong, nonatomic) IBOutlet UITextField *shippingStateTextField;
@property (strong, nonatomic) IBOutlet UIButton *shippingStateButton;
@property (strong, nonatomic) IBOutlet UIImageView *shippingStateDropDown;
@property (strong, nonatomic) IBOutlet UITextField *shippingAddressLine1TextField;
@property (strong, nonatomic) IBOutlet UITextField *shippingAddressLine2TextField;
@property (strong, nonatomic) IBOutlet UITextField *shippingCityTextField;
@property (strong, nonatomic) IBOutlet UITextField *shippingZipCodeTextField;
//Billing address object declaration
@property (strong, nonatomic) IBOutlet UILabel *billingAddressTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *billingSameAddressLabel;
@property (strong, nonatomic) IBOutlet UIButton *billingEditAddressButton;
@property (strong, nonatomic) IBOutlet UITextField *billingFirstNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *billingLastNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *billingPhoneNumberTextField;
@property (strong, nonatomic) IBOutlet UITextField *billingEmailTextField;
@property (strong, nonatomic) IBOutlet UITextField *billingCountryTextField;
@property (strong, nonatomic) IBOutlet UIButton *billingCountryButton;
@property (strong, nonatomic) IBOutlet UITextField *billingStateTextField;
@property (strong, nonatomic) IBOutlet UIButton *billingStateButton;
@property (strong, nonatomic) IBOutlet UIImageView *billingStateDropDown;
@property (strong, nonatomic) IBOutlet UITextField *billingAddressLine1TextField;
@property (strong, nonatomic) IBOutlet UITextField *billingAddressLine2TextField;
@property (strong, nonatomic) IBOutlet UITextField *billingCityTextField;
@property (strong, nonatomic) IBOutlet UITextField *billingZipCodeTextField;
@property (strong, nonatomic) IBOutlet UILabel *noRadioLabel;
@property (strong, nonatomic) IBOutlet UIButton *noSameAddressButton;
@property (strong, nonatomic) IBOutlet UILabel *yesRadioLabel;
@property (strong, nonatomic) IBOutlet UIButton *yesSameAddressButton;
@end

@implementation CheckoutAddressViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden=false;
    self.title=NSLocalizedText(@"GoNatuur");
    [self addLeftBarButtonWithImage:false];
//    [self viewInitialization];
    [myDelegate showIndicator];
//    [self performSelector:@selector(getCartListData) withObject:nil afterDelay:.1];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

- (IBAction)shippingEditAddress:(UIButton *)sender {
}

- (IBAction)billingEditAddress:(UIButton *)sender {
}

- (IBAction)shippingCountryAction:(UIButton *)sender {
}

- (IBAction)shippingStateAction:(UIButton *)sender {
}

- (IBAction)billingCountryAction:(UIButton *)sender {
}

- (IBAction)billingStateAction:(UIButton *)sender {
}

- (IBAction)noSameAddress:(UIButton *)sender {
}

- (IBAction)yesSameAddress:(UIButton *)sender {
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
