//
//  CheckoutAddressViewController.m
//  GoNatuur
//
//  Created by Ranosys on 06/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "CheckoutAddressViewController.h"
#import "UITextField+Padding.h"
#import "BSKeyboardControls.h"
#import "ProfileModel.h"
#import "UITextField+Validations.h"
#import "GoNatuurPickerView.h"
#import "CheckoutTableViewCell.h"
#import "CheckoutCollectionViewCell.h"
#import "AddressListingViewController.h"
#import "FinalCheckoutViewController.h"

#define selectedStepColor   [UIColor colorWithRed:182.0/255.0 green:36.0/255.0 blue:70.0/255.0 alpha:1.0]
#define unSelectedStepColor [UIColor lightGrayColor]
#define borderRadioColor [UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0]

@interface CheckoutAddressViewController ()<BSKeyboardControlsDelegate> {
    UITextField *currentSelectedTextField;
    NSMutableArray *countryCodeArray;
    int shippingCountryIndex, billingCountryIndex;
    int shippingStateIndex, billingStateIndex;
    int selectedCheckoutPromoIndex, selectedShippingMethodIndex;
    GoNatuurPickerView *gNPickerViewObj;
    NSString *selectedShippingRegionCode,*selectedBillingRegionCode;
    int selectedShippingRegionId, selectedBillingRegionId;
    BOOL isPickerEnable;
    NSMutableArray *countryNameArray,*shippingRegionNameArray,*billingRegionNameArray, *tempShippingRegionNameArray, *tempbillingRegionNameArray;
    BOOL isShippingAddreesSame;
    NSArray *totalArray;
    NSMutableDictionary *totalDict, *finalCheckoutPriceDict;
}
//Other view objects declaration
@property (strong, nonatomic) IBOutlet UILabel *freeShippingLabel;
@property (strong, nonatomic) IBOutlet UILabel *firstStepLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondStepLabel;
@property (strong, nonatomic) IBOutlet UILabel *thirdStepLabel;
@property (strong, nonatomic) IBOutlet UILabel *firstStepSeperetorLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondStepSeperetorLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *mainCheckoutAddressView;
@property (strong, nonatomic) IBOutlet UIButton *continueShoppingOutlet;
@property (strong, nonatomic) IBOutlet UIButton *nextOutlet;
@property (strong, nonatomic) IBOutlet UITableView *shippmentMethodTableView;
@property (strong, nonatomic) IBOutlet UILabel *redeemPointLabel;
@property (strong, nonatomic) IBOutlet UILabel *impactPointLabel;
@property (strong, nonatomic) IBOutlet UICollectionView *offersCollectionView;
@property (strong, nonatomic) IBOutlet UIView *rewardBackView;
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
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UITableView *totalTableView;
//BSKeyboard variable declaration
@property (strong, nonatomic) BSKeyboardControls *keyboardControls;
@end

@implementation CheckoutAddressViewController
@synthesize cartModelData, cartListDataArray;
@synthesize subTotalPrice;
@synthesize isBillingAddress,isShippingAddress;
@synthesize isEditService;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self viewInitialization];
    //Add custom picker view and initialized indexs
    [self addCustomPickerView];
    isBillingAddress=false;
    isShippingAddress=false;
    tempShippingRegionNameArray=[NSMutableArray new];
    tempbillingRegionNameArray=[NSMutableArray new];

    [myDelegate showIndicator];
    [self performSelector:@selector(getCountryCode) withObject:nil afterDelay:.1];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=false;
    self.title=NSLocalizedText(@"GoNatuur");
    [self addLeftBarButtonWithImage:true];
    //Allocate keyboard notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    if ((isBillingAddress||isShippingAddress)&&isEditService) {
        isBillingAddress=false;
        isShippingAddress=false;
        isEditService=false;
        [self setInitailizedShippingAddressData];
        [self setInitailizedBillingAddressData:isShippingAddreesSame];
        if ([self shippingAddressFieldValidations:true]) {
            [myDelegate showIndicator];
            [self performSelector:@selector(setUpdatedAddressShippingMethods:) withObject:[NSNumber numberWithInt:1] afterDelay:.1];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    //Deallocate keyboard notification
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.view bringSubviewToFront:gNPickerViewObj.goNatuurPickerViewObj];
}
#pragma mark - end

#pragma mark - Keyboard control delegate
- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction {
    UIView *view;
    view = field.superview.superview.superview;
}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControl {
    [keyboardControl.activeField resignFirstResponder];
}
#pragma mark - end

#pragma mark - Textfield delegates
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [gNPickerViewObj hidePickerView];
    [_keyboardControls setActiveField:textField];
    currentSelectedTextField=textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    isPickerEnable = false;
    //Set field position after show keyboard
    NSDictionary* info = [notification userInfo];
    NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    [self showKeyboardScrollView:[aValue CGRectValue].size.height];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [self hideKeyboardScrollView];
}

- (void)showKeyboardScrollView:(float)keyboardHeight {
    _nextOutlet.enabled=false;
    _nextOutlet.alpha=0.7;
    float backViewY=0;
    if ((currentSelectedTextField==_shippingFirstNameTextField)||(currentSelectedTextField==_shippingLastNameTextField)||(currentSelectedTextField==_shippingPhoneNumberTextField)||(currentSelectedTextField==_shippingEmailTextField)||(currentSelectedTextField==_shippingAddressLine1TextField)||(currentSelectedTextField==_shippingStateTextField)||(currentSelectedTextField==_shippingCityTextField)||(currentSelectedTextField==_shippingZipCodeTextField)||(currentSelectedTextField==_shippingAddressLine2TextField)||(currentSelectedTextField==_shippingCountryTextField)) {
        backViewY=195;
    }
    else {
        backViewY=539;
    }
    //Set condition according to check if current selected textfield is behind keyboard
    if (backViewY+currentSelectedTextField.frame.origin.y+currentSelectedTextField.frame.size.height<([UIScreen mainScreen].bounds.size.height)-keyboardHeight) {
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else {
        [_scrollView setContentOffset:CGPointMake(0, ((backViewY+currentSelectedTextField.frame.origin.y+currentSelectedTextField.frame.size.height)- ([UIScreen mainScreen].bounds.size.height-keyboardHeight))+10) animated:NO];
    }
    //Change content size of scroll view if current selected textfield is behind keyboard
    if (keyboardHeight-([UIScreen mainScreen].bounds.size.height-(backViewY+824))>0) {
        _scrollView.contentSize = CGSizeMake(0,[UIScreen mainScreen].bounds.size.height+(keyboardHeight-([UIScreen mainScreen].bounds.size.height-(backViewY+824)))-250);
    }
}

- (void)hideKeyboardScrollView {
    if (!isPickerEnable) {
        _nextOutlet.enabled=true;
        _nextOutlet.alpha=1.0;
         _scrollView.contentSize = CGSizeMake(0,_mainCheckoutAddressView.frame.size.height);
        if ([self shippingAddressFieldValidations:false]&&[self isShippingAddressDifferent]) {
            [self calledUpdateAddressServiceMethod];
        }
        if (isShippingAddreesSame) {
            [self setRadioStyle:true];
            [self setInitailizedBillingAddressData:true];
            [self setTextFieldKeyboard:isShippingAddreesSame];
        }
    }
}
#pragma mark - end

#pragma mark - Add picker
- (void)addCustomPickerView {
    //Set initial index of picker view and initialized picker view
    shippingCountryIndex=-1;
    billingCountryIndex=-1;
    billingStateIndex=-1;
    shippingStateIndex=-1;
    gNPickerViewObj=[[GoNatuurPickerView alloc] initWithFrame:self.view.frame delegate:self pickerHeight:230];
    [self.view addSubview:gNPickerViewObj.goNatuurPickerViewObj];
}
#pragma mark - end

#pragma mark - View customisation
- (void)didLoadIntialization {
    cartModelData.checkoutPromosArray=[NSMutableArray new];
    cartModelData.shippmentMethodsArray=[NSMutableArray new];
    totalDict=[NSMutableDictionary new];
    finalCheckoutPriceDict=[NSMutableDictionary new];
    selectedCheckoutPromoIndex=-1;
    selectedShippingMethodIndex=-1;
    _noRadioLabel.layer.masksToBounds=true;
    _yesRadioLabel.layer.masksToBounds=true;
    _noRadioLabel.layer.cornerRadius=5.0;
    _yesRadioLabel.layer.cornerRadius=5.0;
    isShippingAddreesSame=false;
    [self setPrices];
    [self setRadioStyle:isShippingAddreesSame];
}

- (double)getShippingCharges {
    return (selectedShippingMethodIndex!=-1?[[cartModelData.shippmentMethodsArray[selectedShippingMethodIndex] objectForKey:@"base_amount"] doubleValue]:0.0);
}

- (double)getDiscount {
    double discountValue=0.0;
    if (selectedCheckoutPromoIndex!=-1) {
        NSDictionary *tempDict=[[cartModelData.checkoutPromosArray objectAtIndex:selectedCheckoutPromoIndex] copy];
        if ([tempDict[@"promo_category"] isEqualToString:@"rebate"]) {
            discountValue=[tempDict[@"promo_discount_value"] floatValue];
        }
        else if ([tempDict[@"promo_category"] isEqualToString:@"percent_discount"]) {
            discountValue=(subTotalPrice*[tempDict[@"promo_discount_value"] floatValue]/100);
        }
        else {
            discountValue=(selectedShippingMethodIndex!=-1?[[cartModelData.shippmentMethodsArray[selectedShippingMethodIndex] objectForKey:@"base_amount"] doubleValue]:0.0);
        }
    }
    return discountValue;
}

- (void)setPrices {
    //For guest user
    if ((nil==[UserDefaultManager getValue:@"userId"])) {
        totalArray=@[@"Cart subtotal", @"Shipping charges", @"Grand Total"];
        [totalDict setObject:[NSString stringWithFormat:@"%@%.2f",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],(subTotalPrice*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue])] forKey:@"Cart subtotal"];
        [totalDict setObject:[NSString stringWithFormat:@"%@%.2f",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],([self getShippingCharges]*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue])] forKey:@"Shipping charges"];
        [totalDict setObject:[NSString stringWithFormat:@"%@%.2f",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],((subTotalPrice+[self getShippingCharges])*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue])] forKey:@"Grand Total"];
        //Set for final checkout screen data
        [finalCheckoutPriceDict setObject:[NSNumber numberWithDouble:subTotalPrice] forKey:@"Cart subtotal"];
        [finalCheckoutPriceDict setObject:[NSNumber numberWithDouble:[self getShippingCharges]] forKey:@"Shipping charges"];
    }
    //Only for redeem products
    else if (![cartModelData.isSimpleProductExist boolValue]&&[cartModelData.isRedeemProductExist boolValue]) {
        totalArray=@[@"Points subtotal", @"Shipping charges", @"Discount", @"Grand Total"];
        [totalDict setObject:[NSString stringWithFormat:@"%@ip",cartModelData.impactPoints] forKey:@"Points subtotal"];
        [totalDict setObject:[NSString stringWithFormat:@"%@%.2f",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],([self getShippingCharges]*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue])] forKey:@"Shipping charges"];
        [totalDict setObject:[NSString stringWithFormat:@"-%@%.2f",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],([self getDiscount]*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue])] forKey:@"Discount"];
        [totalDict setObject:(([self getShippingCharges]-[self getDiscount])>0?[NSString stringWithFormat:@"%@%.2f + %@ip",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],([self getShippingCharges]-[self getDiscount]),cartModelData.impactPoints]:[NSString stringWithFormat:@"%@ip",cartModelData.impactPoints]) forKey:@"Grand Total"];
        //Set for final checkout screen data
        [finalCheckoutPriceDict setObject:cartModelData.impactPoints forKey:@"Points subtotal"];
        [finalCheckoutPriceDict setObject:[NSNumber numberWithDouble:[self getShippingCharges]] forKey:@"Shipping charges"];
        [finalCheckoutPriceDict setObject:[NSNumber numberWithDouble:[self getDiscount]] forKey:@"Discount"];
    }
    //Only for simple products
    else if ([cartModelData.isSimpleProductExist boolValue]&&![cartModelData.isRedeemProductExist boolValue]) {
        totalArray=@[@"Cart subtotal", @"Shipping charges", @"Discount", @"Grand Total"];
        [totalDict setObject:[NSString stringWithFormat:@"%@%.2f",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],(subTotalPrice*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue])] forKey:@"Cart subtotal"];
        [totalDict setObject:[NSString stringWithFormat:@"%@%.2f",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],([self getShippingCharges]*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue])] forKey:@"Shipping charges"];
        [totalDict setObject:[NSString stringWithFormat:@"-%@%.2f",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],([self getDiscount]*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue])] forKey:@"Discount"];
        [totalDict setObject:[NSString stringWithFormat:@"%@%.2f",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],((subTotalPrice+[self getShippingCharges]-[self getDiscount])*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue])] forKey:@"Grand Total"];
        //Set for final checkout screen data
        [finalCheckoutPriceDict setObject:[NSNumber numberWithDouble:subTotalPrice] forKey:@"Cart subtotal"];
        [finalCheckoutPriceDict setObject:[NSNumber numberWithDouble:[self getShippingCharges]] forKey:@"Shipping charges"];
        [finalCheckoutPriceDict setObject:[NSNumber numberWithDouble:[self getDiscount]] forKey:@"Discount"];
    }
    //For both simple and redeem products
    else {
        totalArray=@[@"Cart subtotal", @"Points subtotal", @"Shipping charges", @"Discount", @"Grand Total"];
        [totalDict setObject:[NSString stringWithFormat:@"%@%.2f",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],(subTotalPrice*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue])] forKey:@"Cart subtotal"];
        [totalDict setObject:[NSString stringWithFormat:@"%@ip",cartModelData.impactPoints]forKey:@"Points subtotal"];
        [totalDict setObject:[NSString stringWithFormat:@"%@%.2f",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],([self getShippingCharges]*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue])] forKey:@"Shipping charges"];
        [totalDict setObject:[NSString stringWithFormat:@"-%@%.2f",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],([self getDiscount]*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue])] forKey:@"Discount"];
        [totalDict setObject:[NSString stringWithFormat:@"%@%.2f + %@ip",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],((subTotalPrice+[self getShippingCharges]-[self getDiscount])*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue]),cartModelData.impactPoints] forKey:@"Grand Total"];//Show subtotal and ip
        //Set for final checkout screen data
        [finalCheckoutPriceDict setObject:[NSNumber numberWithDouble:subTotalPrice] forKey:@"Cart subtotal"];
        [finalCheckoutPriceDict setObject:[NSString stringWithFormat:@"%@ip",cartModelData.impactPoints] forKey:@"Points subtotal"];
        [finalCheckoutPriceDict setObject:[NSNumber numberWithDouble:[self getShippingCharges]] forKey:@"Shipping charges"];
        [finalCheckoutPriceDict setObject:[NSNumber numberWithDouble:[self getDiscount]] forKey:@"Discount"];
    }
    [_totalTableView reloadData];
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
    selectedBillingRegionCode=@"";
    selectedShippingRegionCode=@"";
    selectedShippingRegionId=0;
    selectedBillingRegionId=0;
    [self viewObjectFraming];
    [self showSelectedTab:2];
    //Customized steps
    [self customizedSteps];
    [self setLocalizedText];
    [self setTextFieldPadding];
    [self setTextFieldBorder];
    if ((nil==[UserDefaultManager getValue:@"userId"])) {
        _shippingEditAddressButton.hidden=true;
        _billingEditAddressButton.hidden=true;
    }
    else {
        _shippingEditAddressButton.hidden=false;
        _billingEditAddressButton.hidden=false;
    }
}

- (void)viewObjectFraming {
    _bottomView.translatesAutoresizingMaskIntoConstraints=true;
    _mainCheckoutAddressView.translatesAutoresizingMaskIntoConstraints=true;
    _shippmentMethodTableView.translatesAutoresizingMaskIntoConstraints=true;
    _rewardBackView.translatesAutoresizingMaskIntoConstraints=true;
    _totalTableView.translatesAutoresizingMaskIntoConstraints=true;
    _scrollView.translatesAutoresizingMaskIntoConstraints=true;
    _totalTableView.frame=CGRectMake(13, 8, [[UIScreen mainScreen] bounds].size.width-26, 25*totalArray.count);
    _bottomView.frame=CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-60-(_totalTableView.frame.size.height+59), [[UIScreen mainScreen] bounds].size.width, (_totalTableView.frame.size.height+59));
    _shippmentMethodTableView.frame=CGRectMake(20, 933, [[UIScreen mainScreen] bounds].size.width-40, 50*cartModelData.shippmentMethodsArray.count);
    if ((nil==[UserDefaultManager getValue:@"userId"])) {
        _rewardBackView.hidden=true;
        _mainCheckoutAddressView.frame=CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 930+_shippmentMethodTableView.frame.size.height);
    }
    else {
        _rewardBackView.hidden=false;
        if (cartModelData.checkoutPromosArray.count>0) {
            _rewardBackView.frame=CGRectMake(0, _shippmentMethodTableView.frame.origin.y+_shippmentMethodTableView.frame.size.height, [[UIScreen mainScreen] bounds].size.width, 160);
        }
        else {
            _rewardBackView.frame=CGRectMake(0, _shippmentMethodTableView.frame.origin.y+_shippmentMethodTableView.frame.size.height, [[UIScreen mainScreen] bounds].size.width, 64);
        }
        _mainCheckoutAddressView.frame=CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 930+_shippmentMethodTableView.frame.size.height+_rewardBackView.frame.size.height);
    }
    _scrollView.frame=CGRectMake(0, 195, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-195-60-_bottomView.frame.size.height);
    _scrollView.contentSize = CGSizeMake(0,_mainCheckoutAddressView.frame.size.height);
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
    _shippingStateDropDown.hidden=false;
    _billingStateDropDown.hidden=false;
    _shippingStateButton.hidden=false;
    _billingStateButton.hidden=false;
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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"countryId == %@", cartModelData.shippingAddressDict[@"country_id"]];
    NSArray *filteredarray = [countryCodeArray filteredArrayUsingPredicate:predicate];
    if (filteredarray.count>0) {
        NSUInteger index = [countryCodeArray indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
            return [predicate evaluateWithObject:obj];
        }];
        ProfileModel *temp=[ProfileModel new];
        temp=[countryCodeArray objectAtIndex:index];
        shippingCountryIndex=(int)index;
        _shippingCountryTextField.text=temp.countryLocale;
        shippingRegionNameArray = [[[countryCodeArray objectAtIndex:shippingCountryIndex] regionArray] mutableCopy];
        [tempShippingRegionNameArray removeAllObjects];
        for (ProfileModel *tempRegionName in shippingRegionNameArray) {
            [tempShippingRegionNameArray addObject:tempRegionName.regionName];
        }
        DLog(@"%@",temp.countryLocale);
    }
    else {
        shippingCountryIndex=-1;
        _shippingCountryTextField.text=@"";
        shippingRegionNameArray=[NSMutableArray new];
        [tempShippingRegionNameArray removeAllObjects];
    }
    _shippingStateTextField.text=cartModelData.shippingAddressDict[@"region"];
    _shippingCityTextField.text=cartModelData.shippingAddressDict[@"city"];
    _shippingZipCodeTextField.text=cartModelData.shippingAddressDict[@"postcode"];
    if (shippingCountryIndex==-1) {
        [self setShippingRegionDataNotExist];
    }
    else {
        if (([[[countryCodeArray objectAtIndex:shippingCountryIndex] regionArray] count]>0)&&(![cartModelData.shippingAddressDict[@"region_id"] isKindOfClass:[NSString class]]||[cartModelData.shippingAddressDict[@"region_id"] intValue]!=0)) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"regionId == %@", cartModelData.shippingAddressDict[@"region_id"]];
            NSArray *filteredarray = [[[countryCodeArray objectAtIndex:shippingCountryIndex] regionArray] filteredArrayUsingPredicate:predicate];
            if (filteredarray.count>0) {
                NSUInteger index = [[[countryCodeArray objectAtIndex:shippingCountryIndex] regionArray] indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
                    return [predicate evaluateWithObject:obj];
                }];
                ProfileModel *temp=[ProfileModel new];
                temp=[[[countryCodeArray objectAtIndex:shippingCountryIndex] regionArray] objectAtIndex:index];
                shippingStateIndex=(int)index;
                _shippingStateDropDown.hidden=false;
                _shippingStateButton.hidden=false;
                selectedShippingRegionId=[[temp regionId] intValue];
                selectedShippingRegionCode=[temp regionCode];
                [_shippingStateTextField addTextFieldLeftRightPadding:_shippingStateTextField];
            }
            else {
                [self setShippingRegionDataNotExist];
            }
        }
        else {
            [self setShippingRegionDataNotExist];
        }
    }
}

- (void)setShippingRegionDataNotExist {
    _shippingStateDropDown.hidden=true;
    _shippingStateButton.hidden=true;
    selectedShippingRegionId=0;
    shippingStateIndex=-1;
    selectedShippingRegionCode=(nil!=cartModelData.shippingAddressDict[@"region_code"]?cartModelData.shippingAddressDict[@"region_code"]:@"");
    [_shippingStateTextField addTextFieldPaddingWithoutImages:_shippingStateTextField];
}

-(void)setInitailizedBillingAddressData:(BOOL)isYes {
    if (isYes) {
        //Set default billing address as shipping address bcz initially shipping address will be same.
        _billingFirstNameTextField.text=_shippingFirstNameTextField.text;
        _billingLastNameTextField.text=_shippingLastNameTextField.text;
        _billingPhoneNumberTextField.text=_shippingPhoneNumberTextField.text;
        _billingEmailTextField.text=_shippingEmailTextField.text;
        _billingAddressLine1TextField.text=_shippingAddressLine1TextField.text;
        _billingAddressLine2TextField.text=_shippingAddressLine2TextField.text;
        _billingCountryTextField.text=_shippingCountryTextField.text;
        _billingStateTextField.text=_shippingStateTextField.text;
        _billingCityTextField.text=_shippingCityTextField.text;
        _billingZipCodeTextField.text=_shippingZipCodeTextField.text;
        if ([_shippingStateDropDown isHidden]) {
            _billingStateDropDown.hidden=_shippingStateDropDown.hidden;
            _billingStateButton.hidden=_shippingStateButton.hidden;
            selectedBillingRegionId=selectedShippingRegionId;
            selectedBillingRegionCode=selectedShippingRegionCode;
            billingStateIndex=shippingStateIndex;
            if (billingStateIndex==-1) {
                [_billingStateTextField addTextFieldPaddingWithoutImages:_billingStateTextField];
            }
            else {
                [_billingStateTextField addTextFieldLeftRightPadding:_billingStateTextField];
            }
        }
        billingRegionNameArray=[NSMutableArray new];
        [tempbillingRegionNameArray removeAllObjects];
    }
    else {
        _billingFirstNameTextField.text=cartModelData.billingAddressDict[@"firstname"];
        _billingLastNameTextField.text=cartModelData.billingAddressDict[@"lastname"];
        _billingPhoneNumberTextField.text=cartModelData.billingAddressDict[@"telephone"];
        _billingEmailTextField.text=cartModelData.billingAddressDict[@"email"];
        _billingAddressLine1TextField.text=[cartModelData.billingAddressDict[@"street"] objectAtIndex:0];
        _billingAddressLine2TextField.text=([cartModelData.billingAddressDict[@"street"] count]>1?[cartModelData.billingAddressDict[@"street"] objectAtIndex:1]:@"");
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"countryId == %@", cartModelData.billingAddressDict[@"country_id"]];
        NSArray *filteredarray = [countryCodeArray filteredArrayUsingPredicate:predicate];
        if (filteredarray.count>0) {
            NSUInteger index = [countryCodeArray indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
                return [predicate evaluateWithObject:obj];
            }];
            ProfileModel *temp=[ProfileModel new];
            temp=[countryCodeArray objectAtIndex:index];
            billingCountryIndex=(int)index;
            _billingCountryTextField.text=temp.countryLocale;
             billingRegionNameArray = [[[countryCodeArray objectAtIndex:billingCountryIndex] regionArray] mutableCopy];
            [tempbillingRegionNameArray removeAllObjects];
            for (ProfileModel *tempRegionName in billingRegionNameArray) {
                [tempbillingRegionNameArray addObject:tempRegionName.regionName];
            }
            DLog(@"%@",temp.countryLocale);
        }
        else {
             billingRegionNameArray=[NSMutableArray new];
            [tempbillingRegionNameArray removeAllObjects];
            billingCountryIndex=-1;
            _billingCountryTextField.text=@"";
        }
        _billingStateTextField.text=cartModelData.billingAddressDict[@"region"];
        _billingCityTextField.text=cartModelData.billingAddressDict[@"city"];
        _billingZipCodeTextField.text=cartModelData.billingAddressDict[@"postcode"];
        if (billingCountryIndex==-1) {
            [self setBillingRegionDataNotExist];
        }
        else {
            if (([[[countryCodeArray objectAtIndex:billingCountryIndex] regionArray] count]>0)&&(![cartModelData.billingAddressDict[@"region_id"] isKindOfClass:[NSString class]]||[cartModelData.billingAddressDict[@"region_id"] intValue]!=0)) {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"regionId == %@", cartModelData.billingAddressDict[@"region_id"]];
                NSArray *filteredarray = [[[countryCodeArray objectAtIndex:billingCountryIndex] regionArray] filteredArrayUsingPredicate:predicate];
                if (filteredarray.count>0) {
                    NSUInteger index = [[[countryCodeArray objectAtIndex:billingCountryIndex] regionArray] indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
                        return [predicate evaluateWithObject:obj];
                    }];
                    ProfileModel *temp=[ProfileModel new];
                    temp=[[[countryCodeArray objectAtIndex:billingCountryIndex] regionArray] objectAtIndex:index];
                    billingStateIndex=(int)index;
                    _billingStateDropDown.hidden=false;
                    _billingStateButton.hidden=false;
                    selectedBillingRegionId=[[temp regionId] intValue];
                    selectedBillingRegionCode=[temp regionCode];
                    [_billingStateTextField addTextFieldLeftRightPadding:_billingStateTextField];
                }
                else {
                    [self setBillingRegionDataNotExist];
                }
            }
            else {
                [self setBillingRegionDataNotExist];
            }
        }
    }
    [self disableBillingAddress:isYes];
}

- (void)setBillingRegionDataNotExist {
    _billingStateDropDown.hidden=true;
    _billingStateButton.hidden=true;
    selectedBillingRegionId=0;
    billingStateIndex=-1;
    selectedBillingRegionCode=(nil!=cartModelData.billingAddressDict[@"region_code"]?cartModelData.billingAddressDict[@"region_code"]:@"");
    [_billingStateTextField addTextFieldPaddingWithoutImages:_billingStateTextField];
}

- (void)disableBillingAddress:(BOOL)isYes {
    if (isYes) {
        if ((nil==[UserDefaultManager getValue:@"userId"])) {
            _shippingEditAddressButton.hidden=true;
            _billingEditAddressButton.hidden=true;
        }
        else {
            _billingEditAddressButton.hidden=true;
        }
        _billingFirstNameTextField.enabled=false;
        _billingLastNameTextField.enabled=false;
        _billingPhoneNumberTextField.enabled=false;
        _billingEmailTextField.enabled=false;
        _billingAddressLine1TextField.enabled=false;
        _billingAddressLine2TextField.enabled=false;
        _billingStateTextField.enabled=false;
        _billingCityTextField.enabled=false;
        _billingZipCodeTextField.enabled=false;
        _billingStateButton.enabled=false;
        _billingCountryTextField.enabled=false;
        _billingCountryButton.enabled=false;
        billingCountryIndex=shippingCountryIndex;
        billingStateIndex=shippingStateIndex;
        selectedBillingRegionId=selectedShippingRegionId;
        selectedBillingRegionCode=selectedShippingRegionCode;
    }
    else {
        if ((nil==[UserDefaultManager getValue:@"userId"])) {
            _shippingEditAddressButton.hidden=true;
            _billingEditAddressButton.hidden=true;
        }
        else {
            _billingEditAddressButton.hidden=false;
        }
        _billingFirstNameTextField.enabled=true;
        _billingLastNameTextField.enabled=true;
        _billingPhoneNumberTextField.enabled=true;
        _billingEmailTextField.enabled=true;
        _billingAddressLine1TextField.enabled=true;
        _billingAddressLine2TextField.enabled=true;
        _billingStateTextField.enabled=true;
        _billingCityTextField.enabled=true;
        _billingZipCodeTextField.enabled=true;
        _billingStateButton.enabled=true;
        _billingCountryButton.enabled=true;
    }
}

- (void)setTextFieldKeyboard:(BOOL)isYes {
    NSMutableArray *keyboardField;
    if (isYes) {
        keyboardField=[[NSMutableArray alloc] initWithObjects: _shippingFirstNameTextField,_shippingLastNameTextField,_shippingPhoneNumberTextField,_shippingEmailTextField,_shippingAddressLine1TextField,_shippingAddressLine2TextField, nil];
        if (shippingRegionNameArray.count==0) {
            [keyboardField addObject:_shippingStateTextField];
        }
        [keyboardField addObject:_shippingCityTextField];
        [keyboardField addObject:_shippingZipCodeTextField];
        //Add textfield to keyboard controls array
        [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:keyboardField]];
    }
    else {
        keyboardField=[[NSMutableArray alloc] initWithObjects: _shippingFirstNameTextField,_shippingLastNameTextField,_shippingPhoneNumberTextField,_shippingEmailTextField,_shippingAddressLine1TextField,_shippingAddressLine2TextField, nil];
        if (shippingRegionNameArray.count==0) {
            [keyboardField addObject:_shippingStateTextField];
        }
        [keyboardField addObject:_shippingCityTextField];
        [keyboardField addObject:_shippingZipCodeTextField];
        [keyboardField addObjectsFromArray:@[_billingFirstNameTextField,_billingLastNameTextField,_billingPhoneNumberTextField,_billingEmailTextField,_billingAddressLine1TextField,_billingAddressLine2TextField]];
        if (billingRegionNameArray.count==0) {
            [keyboardField addObject:_billingStateTextField];
        }
        [keyboardField addObject:_billingCityTextField];
        [keyboardField addObject:_billingZipCodeTextField];
        //Add textfield to keyboard controls array
        [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:keyboardField]];
    }
    [_keyboardControls setDelegate:self];
}
#pragma mark - end

#pragma mark - IBActions
//Checkout address IBActions
- (IBAction)checkoutAddressContinueShopping:(UIButton *)sender {
    UIViewController * objReveal = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
    [myDelegate.window setRootViewController:objReveal];
    [myDelegate.window setBackgroundColor:[UIColor whiteColor]];
    [myDelegate.window makeKeyAndVisible];
}

- (IBAction)checkoutAddressNext:(UIButton *)sender {
    isPickerEnable=false;
    [gNPickerViewObj hidePickerView];
    [self.view endEditing:true];
    if ([self shippingAddressFieldValidations:true]&&[self billingAddressFieldValidations]) {
        [myDelegate showIndicator];
        [self performSelector:@selector(setUpdatedAddressShippingMethods:) withObject:[NSNumber numberWithInt:0] afterDelay:.1];
    }
}

- (IBAction)shippingEditAddress:(UIButton *)sender {
        
    //StoryBoard navigation
    isShippingAddress=true;
    isEditService=false;
    AddressListingViewController *obj = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddressListingViewController"];
    obj.checkoutAddressViewObj=self;
    obj.profileData.addressArray=[cartModelData.customerSavedAddressArray mutableCopy];
    [self.navigationController pushViewController:obj animated:YES];
}

- (IBAction)billingEditAddress:(UIButton *)sender {
    //StoryBoard navigation
    isBillingAddress=true;
    isEditService=false;
    AddressListingViewController *obj = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddressListingViewController"];
    obj.checkoutAddressViewObj=self;
    obj.profileData.addressArray=[cartModelData.customerSavedAddressArray mutableCopy];
    [self.navigationController pushViewController:obj animated:YES];
}

- (IBAction)shippingCountryAction:(UIButton *)sender {
    isPickerEnable = true;
    [self.view endEditing:true];
    currentSelectedTextField=_shippingCountryTextField;
    [self showKeyboardScrollView:230.0];
    [gNPickerViewObj showPickerView:countryNameArray selectedIndex:(shippingCountryIndex==-1?0:shippingCountryIndex) option:1 isCancelDelegate:true];
}

- (IBAction)shippingStateAction:(UIButton *)sender {
    isPickerEnable = true;
    [self.view endEditing:true];
    currentSelectedTextField=_shippingStateTextField;
    [self showKeyboardScrollView:230.0];
    [gNPickerViewObj showPickerView:tempShippingRegionNameArray selectedIndex:(shippingStateIndex==-1?0:shippingCountryIndex) option:2 isCancelDelegate:true];
}

- (IBAction)billingCountryAction:(UIButton *)sender {
    isPickerEnable = true;
    [self.view endEditing:true];
    currentSelectedTextField=_billingCountryTextField;
    [self showKeyboardScrollView:230.0];
    [gNPickerViewObj showPickerView:countryNameArray selectedIndex:(billingCountryIndex==-1?0:billingCountryIndex) option:3 isCancelDelegate:true];
}

- (IBAction)billingStateAction:(UIButton *)sender {
    isPickerEnable = true;
    [self.view endEditing:true];
    currentSelectedTextField=_billingStateTextField;
    [self showKeyboardScrollView:230.0];
    [gNPickerViewObj showPickerView:tempbillingRegionNameArray selectedIndex:(billingStateIndex==-1?0:billingStateIndex) option:4 isCancelDelegate:true];
}

- (IBAction)noSameAddress:(UIButton *)sender {
    isShippingAddreesSame=false;
    [self setRadioStyle:false];
    [self disableBillingAddress:false];
    [self setTextFieldKeyboard:isShippingAddreesSame];
}

- (IBAction)yesSameAddress:(UIButton *)sender {
    isShippingAddreesSame=true;
    [self setRadioStyle:true];
    [self setInitailizedBillingAddressData:true];
    [self setTextFieldKeyboard:isShippingAddreesSame];
}
#pragma mark - end

#pragma mark - Called update address service 
- (void)calledUpdateAddressServiceMethod {
        isPickerEnable=false;
        [gNPickerViewObj hidePickerView];
        [self.view endEditing:true];
        if ([self shippingAddressFieldValidations:true]) {
            [myDelegate showIndicator];
            [self performSelector:@selector(setUpdatedAddressShippingMethods:) withObject:[NSNumber numberWithInt:1] afterDelay:.1];
        }
}
#pragma mark - end

#pragma mark - Address fields validation
- (BOOL)shippingAddressFieldValidations:(BOOL)isAlertShow {
    if ([_shippingFirstNameTextField isEmpty] || [_shippingLastNameTextField isEmpty] || [_shippingPhoneNumberTextField isEmpty] || [_shippingEmailTextField isEmpty] || [_shippingAddressLine1TextField isEmpty] || [_shippingStateTextField isEmpty] || [_shippingCityTextField isEmpty] || [_shippingZipCodeTextField isEmpty]) {
        if (isAlertShow) {
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"emptyFieldMessage") closeButtonTitle:NSLocalizedText(@"alertOk") duration:0.0f];
        }
        return NO;
    }
    else if (![_shippingEmailTextField isValidEmail]) {
        if (isAlertShow) {
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"validEmailMessage") closeButtonTitle:NSLocalizedText(@"alertOk") duration:0.0f];
        }
        return NO;
    }else {
        return YES;
    }
}

- (BOOL)billingAddressFieldValidations {
    if ([_billingFirstNameTextField isEmpty] || [_billingLastNameTextField isEmpty] || [_billingPhoneNumberTextField isEmpty] || [_billingEmailTextField isEmpty] || [_billingAddressLine1TextField isEmpty] || [_billingStateTextField isEmpty] || [_billingCityTextField isEmpty] || [_billingZipCodeTextField isEmpty]) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"emptyFieldMessage") closeButtonTitle:NSLocalizedText(@"alertOk") duration:0.0f];
        return NO;
    }
    else if (![_billingEmailTextField isValidEmail]) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"validEmailMessage") closeButtonTitle:NSLocalizedText(@"alertOk") duration:0.0f];
        return NO;
    }else {
        return YES;
    }
}

- (BOOL)isShippingAddressDifferent {
    BOOL isStreetChange=false;
    NSArray *streets=[cartModelData.shippingAddressDict[@"street"] copy];
    if (![[streets objectAtIndex:0] isEqualToString:_shippingAddressLine1TextField.text]) {
        isStreetChange=true;
    }
    if ([streets count]>1) {
        if (![[streets objectAtIndex:1] isEqualToString:_shippingAddressLine2TextField.text]) {
            isStreetChange=true;
        }
    }
    else {
        if (![_shippingAddressLine2TextField isEmpty]) {
            isStreetChange=true;
        }
    }
    if (![_shippingStateTextField.text isEqualToString:cartModelData.shippingAddressDict[@"region"]]||![_shippingPhoneNumberTextField.text isEqualToString:cartModelData.shippingAddressDict[@"telephone"]]||![_shippingZipCodeTextField.text isEqualToString:cartModelData.shippingAddressDict[@"postcode"]]||![_shippingCityTextField.text isEqualToString:cartModelData.shippingAddressDict[@"city"]]||![_shippingFirstNameTextField.text isEqualToString:cartModelData.shippingAddressDict[@"firstname"]]||![_shippingLastNameTextField.text isEqualToString:cartModelData.shippingAddressDict[@"lastname"]]||![_shippingEmailTextField.text isEqualToString:cartModelData.shippingAddressDict[@"email"]]||isStreetChange) {
        return true;
    }
    return false;
}
#pragma mark - end

#pragma mark - Webservice
//Get country code listing
- (void)getCountryCode {
    countryCodeArray=[NSMutableArray new];
    ProfileModel *changePasswordModel = [ProfileModel sharedUser];
    [changePasswordModel getCountryCodeService:^(ProfileModel *userData) {
        countryCodeArray = userData.countryCodeArray;
        countryNameArray = [NSMutableArray new];
        for (ProfileModel *dataModel in countryCodeArray) {
            [countryNameArray addObject:dataModel.countryLocale];
        }
        [self setInitailizedShippingAddressData];
        [self setInitailizedBillingAddressData:false];
        [self setTextFieldKeyboard:false];
        if ((nil==[UserDefaultManager getValue:@"userId"])) {
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
        cartModelData.checkoutImpactPoint=[NSNumber numberWithInt:([userData.totalPoints intValue]-[cartModelData.impactPoints intValue])];
        _impactPointLabel.text=[NSString stringWithFormat:@"%@ %@ip",NSLocalizedText(@"checkoutAddressImpactPoint"),cartModelData.checkoutImpactPoint];
        [self getCheckoutPromos];
        //dispaly profile data
    } onfailure:^(NSError *error) {
        
    }];
}

//Get checkout promos
- (void)getCheckoutPromos {
    CartDataModel *cartData = [CartDataModel sharedUser];
    cartData.checkoutImpactPoint=cartModelData.checkoutImpactPoint;
    cartData.isRedeemProductExist=cartModelData.isRedeemProductExist;
    cartData.isSimpleProductExist=cartModelData.isSimpleProductExist;
    [cartData fetchCheckoutPromosOnSuccess:^(CartDataModel *shippmentDetailData)  {
        cartModelData.checkoutPromosArray=[[shippmentDetailData checkoutPromosArray] mutableCopy];
        if (cartModelData.checkoutPromosArray.count>0) {
            [_offersCollectionView reloadData];
        }
        if ([self shippingAddressFieldValidations:false]) {
            [self getShippmentMethodData:false];
        }
        else {
            [myDelegate stopIndicator];
        }
        [self viewObjectFraming];
    } onfailure:^(NSError *error) {
        
    }];
}

//Set addresses and shipping methods
- (void)setUpdatedAddressShippingMethods:(NSNumber *)serviceType {
    CartDataModel *cartData = [CartDataModel sharedUser];
    cartData=[cartModelData copy];
    cartData.shippingAddressDict=[[self setShippingAddressInCartModel] mutableCopy];
    cartData.billingAddressDict=[[self setBillingAddressInCartModel] mutableCopy];
    cartModelData.shippingAddressDict=[cartData.shippingAddressDict mutableCopy];
    cartModelData.billingAddressDict=[cartData.billingAddressDict mutableCopy];
    [cartData setUpdatedAddressShippingMethodsOnSuccess:^(CartDataModel *shippmentDetailData)  {
        cartModelData.checkoutFinalData=[shippmentDetailData.checkoutFinalData mutableCopy];
        if ([serviceType intValue]==1) {
            [self getShippmentMethodData:false];
        }
        else if ([serviceType intValue]==0) {
            if (selectedShippingMethodIndex==-1) {
                [self getShippmentMethodData:true];
            }
            else {
                DLog(@"called checkout promo");
                if (selectedCheckoutPromoIndex==-1||(nil==[UserDefaultManager getValue:@"userId"])) {
                    [myDelegate stopIndicator];
                    //Navigate to step3
                    [self navigateToFinalCheckout];
                }
                else {
                    [self setCheckoutPromos];
                }
            }
        }
        else if ([serviceType intValue]==2) {
            
            [myDelegate stopIndicator];
             //Navigate to step3
            [self navigateToFinalCheckout];
        }
    } onfailure:^(NSError *error) {
        
    }];
}

//Get shippment methods
- (void)getShippmentMethodData:(BOOL)serviceType {
    CartDataModel *cartData = [CartDataModel sharedUser];
    cartData=[cartModelData copy];
    [cartData fetchShippmentMethodsOnSuccess:^(CartDataModel *shippmentDetailData)  {
        [myDelegate stopIndicator];
        cartModelData.shippmentMethodsArray=[shippmentDetailData.shippmentMethodsArray
                                             mutableCopy];
        if (serviceType) {
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"ShippingMethodAlert") closeButtonTitle:NSLocalizedText(@"alertOk") duration:0.0f];
        }
        [self viewObjectFraming];
        selectedShippingMethodIndex=-1;
        [_shippmentMethodTableView reloadData];
    } onfailure:^(NSError *error) {
        
    }];
}

//Set checkout promos
- (void)setCheckoutPromos {
    CartDataModel *cartData = [CartDataModel sharedUser];
    NSDictionary *tempDict=[[cartModelData.checkoutPromosArray objectAtIndex:selectedCheckoutPromoIndex] copy];
    cartData.promoPoints=tempDict[@"promo_points"];
    if ([tempDict[@"promo_category"] isEqualToString:@"rebate"]) {
        cartData.promoDiscountValue=[NSString stringWithFormat:@"%f",[tempDict[@"promo_discount_value"] floatValue]*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue]];
    }
    else if ([tempDict[@"promo_category"] isEqualToString:@"percent_discount"]) {
        
        cartData.promoDiscountValue=[NSString stringWithFormat:@"%f",(subTotalPrice*[tempDict[@"promo_discount_value"] floatValue]/100)*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue]];
        DLog(@"%@",cartData.promoDiscountValue);
    }
    else {
        cartData.promoDiscountValue=[NSString stringWithFormat:@"%f",[[cartModelData.shippmentMethodsArray[selectedShippingMethodIndex] objectForKey:@"base_amount"] floatValue]*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue]];
    }
    [cartData setCheckoutPromosOnSuccess:^(CartDataModel *shippmentDetailData)  {
        [self setUpdatedAddressShippingMethods:[NSNumber numberWithInt:2]];
    } onfailure:^(NSError *error) {
        
    }];
}

#pragma mark - end

- (NSDictionary *)setShippingAddressInCartModel {
    NSMutableArray *streetTempArray=[NSMutableArray new];
    [streetTempArray addObject:_shippingAddressLine1TextField.text];
    if (![_shippingAddressLine2TextField isEmpty]) {
        [streetTempArray addObject:_shippingAddressLine2TextField.text];
    }
    NSDictionary *shippingAddress = @{@"id" : [UserDefaultManager getNumberValue:@"id" dictData:[cartModelData.shippingAddressDict copy]],
                                 @"region" : _shippingStateTextField.text,
                                 @"region_id" : [NSNumber numberWithInt:selectedShippingRegionId],
                                 @"region_code" : selectedShippingRegionCode,
                                      @"country_id" : (shippingCountryIndex!=-1?[[countryCodeArray objectAtIndex:shippingCountryIndex] countryId]:@""),
                                 @"company" : [UserDefaultManager checkStringNull:@"company" dictData:[cartModelData.shippingAddressDict copy]],
                                 @"telephone" : _shippingPhoneNumberTextField.text,
                                 @"fax" : [UserDefaultManager checkStringNull:@"fax" dictData:[cartModelData.shippingAddressDict copy]],
                                 @"postcode" : _shippingZipCodeTextField.text,
                                 @"city" : _shippingCityTextField.text,
                                 @"firstname" : _shippingFirstNameTextField.text,
                                 @"lastname" : _shippingLastNameTextField.text,
                                 @"email" : _shippingEmailTextField.text,
                                 @"customer_id": (nil!=[UserDefaultManager getValue:@"userId"]?[UserDefaultManager getValue:@"userId"]:[NSNumber numberWithInt:0]),
                                 @"street":[streetTempArray copy]
                                 };
    return shippingAddress;
}

- (NSDictionary *)setBillingAddressInCartModel {
    NSMutableArray *streetTempArray=[NSMutableArray new];
    [streetTempArray addObject:_billingAddressLine1TextField.text];
    if (![_billingAddressLine2TextField isEmpty]) {
        [streetTempArray addObject:_billingAddressLine2TextField.text];
    }
    NSDictionary *billingAddress = @{@"id" : [UserDefaultManager getNumberValue:@"id" dictData:[cartModelData.billingAddressDict copy]],
                                      @"region" : _billingStateTextField.text,
                                      @"region_id" : [NSNumber numberWithInt:selectedBillingRegionId],
                                      @"region_code" : selectedBillingRegionCode,
                                      @"country_id" : (billingCountryIndex!=-1?[[countryCodeArray objectAtIndex:billingCountryIndex] countryId]:@""),
                                      @"company" : [UserDefaultManager checkStringNull:@"company" dictData:[cartModelData.billingAddressDict copy]],
                                      @"telephone" : _billingPhoneNumberTextField.text,
                                      @"fax" : [UserDefaultManager checkStringNull:@"fax" dictData:[cartModelData.billingAddressDict copy]],
                                      @"postcode" : _billingZipCodeTextField.text,
                                      @"city" : _billingCityTextField.text,
                                      @"firstname" : _billingFirstNameTextField.text,
                                      @"lastname" : _billingLastNameTextField.text,
                                      @"email" : _billingEmailTextField.text,
                                      @"customer_id": (nil!=[UserDefaultManager getValue:@"userId"]?[UserDefaultManager getValue:@"userId"]:[NSNumber numberWithInt:0]),
                                      @"street":[streetTempArray copy]
                                      };
    return billingAddress;
}

#pragma mark - Custom picker delegate method
- (void)goNatuurPickerViewDelegateActionIndex:(int)tempSelectedIndex option:(int)option {
    if (option==1) {
        if (tempSelectedIndex!=shippingCountryIndex) {
            shippingRegionNameArray = [[[countryCodeArray objectAtIndex:tempSelectedIndex] regionArray] mutableCopy];
            [tempShippingRegionNameArray removeAllObjects];
            for (ProfileModel *tempRegionName in shippingRegionNameArray) {
                [tempShippingRegionNameArray addObject:tempRegionName.regionName];
            }
            ProfileModel *temp=[ProfileModel new];
            temp=[countryCodeArray objectAtIndex:tempSelectedIndex];
            shippingCountryIndex=tempSelectedIndex;
            _shippingCountryTextField.text=temp.countryLocale;
            if (shippingRegionNameArray.count>0) {
                [self setShippingRegionDataNotExist];
                _shippingStateDropDown.hidden=false;
                _shippingStateButton.hidden=false;
                selectedShippingRegionCode=@"";
            }
            else {
                [self setShippingRegionDataNotExist];
                selectedShippingRegionCode=@"";
            }
            _shippingStateTextField.text=@"";
            _shippingCityTextField.text=@"";
            _shippingZipCodeTextField.text=@"";
            [self setTextFieldKeyboard:isShippingAddreesSame];
        }
    } else if (option==2) {
        if (tempSelectedIndex!=shippingStateIndex) {
            ProfileModel *temp=[ProfileModel new];
            temp=[shippingRegionNameArray objectAtIndex:tempSelectedIndex];
            shippingStateIndex=tempSelectedIndex;
            _shippingStateTextField.text=temp.regionName;
            selectedShippingRegionId=[temp.regionId intValue];
            selectedShippingRegionCode=temp.regionCode;
        }
    }
    else if (option==3) {
        if (tempSelectedIndex!=billingCountryIndex) {
            billingRegionNameArray = [[[countryCodeArray objectAtIndex:tempSelectedIndex] regionArray] mutableCopy];
            [tempbillingRegionNameArray removeAllObjects];
            for (ProfileModel *tempRegionName in billingRegionNameArray) {
                [tempbillingRegionNameArray addObject:tempRegionName.regionName];
            }
            ProfileModel *temp=[ProfileModel new];
            temp=[countryCodeArray objectAtIndex:tempSelectedIndex];
            billingCountryIndex=tempSelectedIndex;
            _billingCountryTextField.text=temp.countryLocale;
            if (billingRegionNameArray.count>0) {
                [self setBillingRegionDataNotExist];
                _billingStateDropDown.hidden=false;
                _billingStateButton.hidden=false;
                selectedBillingRegionCode=@"";
            }
            else {
                [self setBillingRegionDataNotExist];
                selectedBillingRegionCode=@"";
            }
            _billingStateTextField.text=@"";
            _billingCityTextField.text=@"";
            _billingZipCodeTextField.text=@"";
            [self setTextFieldKeyboard:isShippingAddreesSame];
        }
    } else if (option==4) {
        if (tempSelectedIndex!=billingStateIndex) {
            ProfileModel *temp=[ProfileModel new];
            temp=[billingRegionNameArray objectAtIndex:tempSelectedIndex];
            billingStateIndex=tempSelectedIndex;
            _billingStateTextField.text=temp.regionName;
            selectedBillingRegionId=[temp.regionId intValue];
            selectedBillingRegionCode=temp.regionCode;
        }
    }
    isPickerEnable = false;
    [self hideKeyboardScrollView];
}

- (void)cancelDelegateMethod {
    isPickerEnable = false;
    [self hideKeyboardScrollView];
}
#pragma mark - end

#pragma mark - Table view datasource delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView==_totalTableView) {
        return totalArray.count;
    }
    return cartModelData.shippmentMethodsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView==_totalTableView) {
        return 25.0;
    }
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView==_totalTableView) {
        NSString *simpleTableIdentifier=@"totalCell";
        CheckoutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            cell = [[CheckoutTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        [cell displayPriceCellData:[totalDict mutableCopy] priceTitleArray:[totalArray objectAtIndex:indexPath.row] islastIndex:((totalArray.count-1)==indexPath.row)?true:false];
        return cell;
    }
    else {
        NSString *simpleTableIdentifier=@"shippingMethodCell";
        CheckoutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            cell = [[CheckoutTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        [cell displayCellData:[cartModelData.shippmentMethodsArray objectAtIndex:indexPath.row] isSelected:(selectedShippingMethodIndex==(int)indexPath.row?true:false) totalPrice:subTotalPrice];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView!=_totalTableView) {
        selectedShippingMethodIndex=(int)indexPath.row;
        cartModelData.selectedShippingMethod=[cartModelData.shippmentMethodsArray[selectedShippingMethodIndex] objectForKey:@"method_code"];
        [_shippmentMethodTableView reloadData];
        [self setPrices];
    }
}
#pragma mark - end

#pragma mark - Collection view datasource methods
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return cartModelData.checkoutPromosArray.count;
}

- (CheckoutCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
        CheckoutCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"checkoutPromoCell" forIndexPath:indexPath];
    [cell displayPromoData:[cartModelData.checkoutPromosArray objectAtIndex:indexPath.row] isSelected:(selectedCheckoutPromoIndex==(int)indexPath.row?true:false)];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (![[[cartModelData.checkoutPromosArray objectAtIndex:indexPath.row] objectForKey:@"HiddenPromo"] boolValue]) {
        if (selectedCheckoutPromoIndex==(int)indexPath.row) {
            selectedCheckoutPromoIndex=-1;
            _impactPointLabel.text=[NSString stringWithFormat:@"%@ %@ip",NSLocalizedText(@"checkoutAddressImpactPoint"),cartModelData.checkoutImpactPoint];
        }
        else {
            selectedCheckoutPromoIndex=(int)indexPath.row;
            NSDictionary *tempDict=[[cartModelData.checkoutPromosArray objectAtIndex:selectedCheckoutPromoIndex] copy];
            _impactPointLabel.text=[NSString stringWithFormat:@"%@ %dip",NSLocalizedText(@"checkoutAddressImpactPoint"),[cartModelData.checkoutImpactPoint intValue]-[tempDict[@"promo_points"] intValue]];
        }
        [_offersCollectionView reloadData];
        [self setPrices];
    }
}
#pragma mark - end

#pragma mark - Navigate to checkout step3 screen
- (void)navigateToFinalCheckout {
    FinalCheckoutViewController *obj = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FinalCheckoutViewController"];
    obj.cartModelData=[cartModelData copy];
    obj.cartListDataArray=[cartListDataArray mutableCopy];
    [self.navigationController pushViewController:obj animated:YES];
}
#pragma mark - end
@end
