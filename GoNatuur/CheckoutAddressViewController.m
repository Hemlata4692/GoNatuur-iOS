//
//  CheckoutAddressViewController.m
//  GoNatuur
//
//  Created by Ranosys on 06/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "CheckoutAddressViewController.h"
#import "UITextField+Padding.h"

#define selectedStepColor   [UIColor colorWithRed:182.0/255.0 green:36.0/255.0 blue:70.0/255.0 alpha:1.0]
#define unSelectedStepColor [UIColor lightGrayColor]
#define borderRadioColor [UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0]

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
@property (strong, nonatomic) IBOutlet UIView *rewardBackView;
@end

@implementation CheckoutAddressViewController
@synthesize cartListModelData, cartListDataArray;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden=false;
    self.title=NSLocalizedText(@"GoNatuur");
    [self addLeftBarButtonWithImage:true];
    [self didLoadIntialization];
    [self viewInitialization];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self setInitailizedShippingAddressData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - View customisation
- (void)didLoadIntialization {
    _noRadioLabel.layer.masksToBounds=true;
    _yesRadioLabel.layer.masksToBounds=true;
    _noRadioLabel.layer.cornerRadius=5.0;
    _yesRadioLabel.layer.cornerRadius=5.0;
    [self setRadioStyle:false];
}

- (void)setRadioStyle:(BOOL)isYes {
    _noRadioLabel.layer.borderColor=[UIColor whiteColor].CGColor;
    _yesRadioLabel.layer.borderColor=[UIColor whiteColor].CGColor;
    _noRadioLabel.layer.borderWidth=1.0;
    _yesRadioLabel.layer.borderWidth=1.0;
    if (isYes) {
        _yesRadioLabel.backgroundColor=selectedStepColor;
        _noRadioLabel.backgroundColor=[UIColor whiteColor];
        _noRadioLabel.layer.borderColor=unSelectedStepColor.CGColor;
    }
    else {
        _noRadioLabel.backgroundColor=selectedStepColor;
        _yesRadioLabel.backgroundColor=[UIColor whiteColor];
        _yesRadioLabel.layer.borderColor=unSelectedStepColor.CGColor;
    }
}

- (void)viewInitialization {
    [self didLoadIntialization];
    myDelegate.selectedCategoryIndex=-1;
    _mainCheckoutAddressView.translatesAutoresizingMaskIntoConstraints=YES;
    if ((nil==[UserDefaultManager getValue:@"userId"])) {
        _rewardBackView.hidden=true;
        _mainCheckoutAddressView.frame=CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 900-42);
    }
    else {
        _rewardBackView.hidden=false;
        _mainCheckoutAddressView.frame=CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 1076-42);
    }
    _shippmentMethodTableView.translatesAutoresizingMaskIntoConstraints=true;
    _shippmentMethodTableView.frame=CGRectMake(20, 853, [[UIScreen mainScreen] bounds].size.width-40, 0);
    _scrollView.contentSize = CGSizeMake(0,_mainCheckoutAddressView.frame.size.height);
    [self showSelectedTab:2];
    //Customized steps
    [self customizedSteps];
    [self setLocalizedText];
    [self setTextFieldPadding];
    [self setTextFieldBorder];
}

- (void)setLocalizedText {
    //Set shipping address localized string
    _shippingAddressTitleLabel.text=NSLocalizedText(@"shippingAddress");
    _shippingFirstNameTextField.placeholder=NSLocalizedText(@"firstName");
    _shippingLastNameTextField.placeholder=NSLocalizedText(@"lastName");
    _shippingPhoneNumberTextField.placeholder=NSLocalizedText(@"checkoutPhoneNumber");
    _shippingEmailTextField.placeholder=NSLocalizedText(@"checkoutEmail");
    _shippingAddressLine1TextField.placeholder=NSLocalizedText(@"checkoutAddressLine1");
    _shippingAddressLine2TextField.placeholder=NSLocalizedText(@"checkoutAddressLine2");
    _shippingCountryTextField.placeholder=NSLocalizedText(@"checkoutCountry");
    _shippingStateTextField.placeholder=NSLocalizedText(@"checkoutState");
    _shippingCityTextField.placeholder=NSLocalizedText(@"checkoutCity");
    _shippingZipCodeTextField.placeholder=NSLocalizedText(@"checkoutZipCode");
    //Set billing address localized string
    _billingSameAddressLabel.text=NSLocalizedText(@"billingSameAddress");
    _billingAddressTitleLabel.text=NSLocalizedText(@"billingAddress");
    _billingFirstNameTextField.placeholder=NSLocalizedText(@"firstName");
    _billingLastNameTextField.placeholder=NSLocalizedText(@"lastName");
    _billingPhoneNumberTextField.placeholder=NSLocalizedText(@"checkoutPhoneNumber");
    _billingEmailTextField.placeholder=NSLocalizedText(@"checkoutEmail");
    _billingAddressLine1TextField.placeholder=NSLocalizedText(@"checkoutAddressLine1");
    _billingAddressLine2TextField.placeholder=NSLocalizedText(@"checkoutAddressLine2");
    _billingCountryTextField.placeholder=NSLocalizedText(@"checkoutCountry");
    _billingStateTextField.placeholder=NSLocalizedText(@"checkoutState");
    _billingCityTextField.placeholder=NSLocalizedText(@"checkoutCity");
    _billingZipCodeTextField.placeholder=NSLocalizedText(@"checkoutZipCode");
    //Set other localized string
    _freeShippingLabel.text=NSLocalizedText(@"cartListFreeShipping");
    [_continueShoppingOutlet setTitle:NSLocalizedText(@"cartListContinueShopping") forState:UIControlStateNormal];
    [_nextOutlet setTitle:NSLocalizedText(@"cartListNext") forState:UIControlStateNormal];
    [_noSameAddressButton setTitle:NSLocalizedText(@"no") forState:UIControlStateNormal];
    [_yesSameAddressButton setTitle:NSLocalizedText(@"yes") forState:UIControlStateNormal];
    _redeemPointLabel.text=NSLocalizedText(@"redeemPoint");
    _impactPointLabel.text=NSLocalizedText(@"checkoutAddressImpactPoint");
}

- (void)setTextFieldPadding {
    //Set shipping address field padding
     [_shippingFirstNameTextField addTextFieldPaddingWithoutImages:_shippingFirstNameTextField];
    [_shippingLastNameTextField addTextFieldPaddingWithoutImages:_shippingLastNameTextField];
    [_shippingPhoneNumberTextField addTextFieldPaddingWithoutImages:_shippingPhoneNumberTextField];
    [_shippingEmailTextField addTextFieldPaddingWithoutImages:_shippingEmailTextField];
    [_shippingAddressLine1TextField addTextFieldPaddingWithoutImages:_shippingAddressLine1TextField];
    [_shippingAddressLine2TextField addTextFieldPaddingWithoutImages:_shippingAddressLine2TextField];
    [_shippingCountryTextField addTextFieldLeftRightPadding:_shippingCountryTextField];
    [_shippingStateTextField addTextFieldLeftRightPadding:_shippingStateTextField];
    [_shippingCityTextField addTextFieldPaddingWithoutImages:_shippingCityTextField];
    [_shippingZipCodeTextField addTextFieldPaddingWithoutImages:_shippingZipCodeTextField];
    //Set billing address field padding
    [_billingFirstNameTextField addTextFieldPaddingWithoutImages:_billingFirstNameTextField];
    [_billingLastNameTextField addTextFieldPaddingWithoutImages:_billingLastNameTextField];
    [_billingPhoneNumberTextField addTextFieldPaddingWithoutImages:_billingPhoneNumberTextField];
    [_billingEmailTextField addTextFieldPaddingWithoutImages:_billingEmailTextField];
    [_billingAddressLine1TextField addTextFieldPaddingWithoutImages:_billingAddressLine1TextField];
    [_billingAddressLine2TextField addTextFieldPaddingWithoutImages:_billingAddressLine2TextField];
    [_billingCountryTextField addTextFieldLeftRightPadding:_billingCountryTextField];
    [_billingStateTextField addTextFieldLeftRightPadding:_billingStateTextField];
    [_billingCityTextField addTextFieldPaddingWithoutImages:_billingCityTextField];
    [_billingZipCodeTextField addTextFieldPaddingWithoutImages:_billingZipCodeTextField];
}

- (void)setTextFieldBorder {
     //Set shipping address field border
    [_shippingFirstNameTextField setTextBorder:_shippingFirstNameTextField color:borderRadioColor];
    [_shippingLastNameTextField setTextBorder:_shippingLastNameTextField color:borderRadioColor];
    [_shippingPhoneNumberTextField setTextBorder:_shippingPhoneNumberTextField color:borderRadioColor];
    [_shippingEmailTextField setTextBorder:_shippingEmailTextField color:borderRadioColor];
    [_shippingAddressLine1TextField setTextBorder:_shippingAddressLine1TextField color:borderRadioColor];
    [_shippingAddressLine2TextField setTextBorder:_shippingAddressLine2TextField color:borderRadioColor];
    [_shippingCountryTextField setTextBorder:_shippingCountryTextField color:borderRadioColor];
    [_shippingStateTextField setTextBorder:_shippingStateTextField color:borderRadioColor];
    [_shippingCityTextField setTextBorder:_shippingCityTextField color:borderRadioColor];
    [_shippingZipCodeTextField setTextBorder:_shippingZipCodeTextField color:borderRadioColor];
    //Set billing address field border
    [_billingFirstNameTextField setTextBorder:_billingFirstNameTextField color:borderRadioColor];
    [_billingLastNameTextField setTextBorder:_billingLastNameTextField color:borderRadioColor];
    [_billingPhoneNumberTextField setTextBorder:_billingPhoneNumberTextField color:borderRadioColor];
    [_billingEmailTextField setTextBorder:_billingEmailTextField color:borderRadioColor];
    [_billingAddressLine1TextField setTextBorder:_billingAddressLine1TextField color:borderRadioColor];
    [_billingAddressLine2TextField setTextBorder:_billingAddressLine2TextField color:borderRadioColor];
    [_billingCountryTextField setTextBorder:_billingCountryTextField color:borderRadioColor];
    [_billingStateTextField setTextBorder:_billingStateTextField color:borderRadioColor];
    [_billingCityTextField setTextBorder:_billingCityTextField color:borderRadioColor];
    [_billingZipCodeTextField setTextBorder:_billingZipCodeTextField color:borderRadioColor];
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
    _firstStepLabel.backgroundColor=selectedStepColor;
    _firstStepSeperetorLabel.backgroundColor=selectedStepColor;
    _secondStepLabel.backgroundColor=selectedStepColor;
}

-(void)setInitailizedShippingAddressData {
    //Set default shipping address
    _shippingFirstNameTextField.text=cartModelData.shippingAddressDict[@"firstname"];
    _shippingLastNameTextField.text=cartModelData.shippingAddressDict[@"lastname"];
    _shippingPhoneNumberTextField.text=cartModelData.shippingAddressDict[@"telephone"];
    _shippingEmailTextField.text=cartModelData.shippingAddressDict[@"email"];
    _shippingAddressLine1TextField.text=[cartModelData.shippingAddressDict[@"street"] objectAtIndex:0];
    _shippingAddressLine2TextField.text=([cartModelData.shippingAddressDict[@"street"] count]>1?[cartModelData.shippingAddressDict[@"street"] objectAtIndex:1]:@"");
    _shippingCountryTextField.text=cartModelData.shippingAddressDict[@""];
    _shippingStateTextField.text=cartModelData.shippingAddressDict[@"region"];
    _shippingCityTextField.text=cartModelData.shippingAddressDict[@"city"];
    _shippingZipCodeTextField.text=cartModelData.shippingAddressDict[@"postcode"];
    
    if (![cartModelData.shippingAddressDict[@"region_id"] isKindOfClass:[NSString class]]&&[cartModelData.shippingAddressDict[@"region_id"] intValue]==0) {
        _shippingStateDropDown.hidden=true;
        [_shippingStateTextField addTextFieldLeftRightPadding:_shippingStateTextField];
        _billingStateDropDown.hidden=true;
        [_billingStateTextField addTextFieldLeftRightPadding:_shippingStateTextField];
    }
}

-(void)setInitailizedBillingAddressData:(BOOL)isYes {
    if (isYes) {
        //Set default billing address as shipping address bcz initially shipping address will be same.
        _billingFirstNameTextField.text=cartModelData.shippingAddressDict[@"firstname"];
        _billingLastNameTextField.text=cartModelData.shippingAddressDict[@"lastname"];
        _billingPhoneNumberTextField.text=cartModelData.shippingAddressDict[@"telephone"];
        _billingEmailTextField.text=cartModelData.shippingAddressDict[@"email"];
        _billingAddressLine1TextField.text=[cartModelData.shippingAddressDict[@"street"] objectAtIndex:0];
        _billingAddressLine2TextField.text=([cartModelData.shippingAddressDict[@"street"] count]>1?[cartModelData.shippingAddressDict[@"street"] objectAtIndex:1]:@"");
        _billingCountryTextField.text=cartModelData.shippingAddressDict[@""];
        _billingStateTextField.text=cartModelData.shippingAddressDict[@"region"];
        _billingCityTextField.text=cartModelData.shippingAddressDict[@"city"];
        _billingZipCodeTextField.text=cartModelData.shippingAddressDict[@"postcode"];
        if (![cartModelData.shippingAddressDict[@"region_id"] isKindOfClass:[NSString class]]&&[cartModelData.shippingAddressDict[@"region_id"] intValue]==0) {
            _billingStateDropDown.hidden=true;
            [_billingStateTextField addTextFieldLeftRightPadding:_shippingStateTextField];
        }
    }
    else {
        if (![cartModelData.billingAddressDict[@"region_id"] isKindOfClass:[NSString class]]&&[cartModelData.billingAddressDict[@"region_id"] intValue]==0) {
            _billingStateDropDown.hidden=true;
            [_billingStateTextField addTextFieldLeftRightPadding:_shippingStateTextField];
        }
    }
    
}

- (void)disableBillingAddress:(BOOL)isYes {
    if (isYes) {
        _billingEditAddressButton.hidden=true;
        
    }
    else {
    
    }
}
#pragma mark - end

//Checkout address IBActions
- (IBAction)checkoutAddressContinueShopping:(UIButton *)sender {
    UIViewController * objReveal = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
    [myDelegate.window setRootViewController:objReveal];
    [myDelegate.window setBackgroundColor:[UIColor whiteColor]];
    [myDelegate.window makeKeyAndVisible];
}

- (IBAction)checkoutAddressNext:(UIButton *)sender {
}

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
