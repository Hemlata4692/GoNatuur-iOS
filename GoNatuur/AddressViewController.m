//
//  AddressViewController.m
//  GoNatuur
//
//  Created by Monika on 8/30/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "AddressViewController.h"
#import "BSKeyboardControls.h"
#import "UITextField+Validations.h"
#import "UITextField+Padding.h"
#import "DynamicHeightWidth.h"
#import "ProfileModel.h"
#import "GoNatuurPickerView.h"
#import "UIImage+UIImage_fixOrientation.h"

@interface AddressViewController ()<BSKeyboardControlsDelegate,GoNatuurPickerViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
@private
    UITextField *currentSelectedTextField;
    NSMutableArray *regionNameArray, *regionArray;
    NSArray *countryCodeArray;
    int selectedCountryCodeIndex, selectedRegionIndex;
    GoNatuurPickerView *gNPickerViewObj;
    NSString *selectedCountryId, *selectedRegionId, *selectedRegionCode;
    BOOL isBilling, isShipping, isPickerEnable;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *addressContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UIView *addressFieldsContainerView;
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;
@property (weak, nonatomic) IBOutlet UITextField *companyField;
@property (weak, nonatomic) IBOutlet UITextField *firstAddressField;
@property (weak, nonatomic) IBOutlet UITextField *secondAddressField;
@property (weak, nonatomic) IBOutlet UITextField *countryField;
@property (weak, nonatomic) IBOutlet UITextField *stateField;
@property (weak, nonatomic) IBOutlet UITextField *cityField;
@property (weak, nonatomic) IBOutlet UITextField *ZipcodeField;
@property (weak, nonatomic) IBOutlet UITextField *faxField;
@property (weak, nonatomic) IBOutlet UIButton *saveAddressButton;
@property (weak, nonatomic) IBOutlet UIButton *isBillingButton;
@property (weak, nonatomic) IBOutlet UIButton *isShippingButton;
@property (weak, nonatomic) IBOutlet UIImageView *billingImageView;
@property (weak, nonatomic) IBOutlet UIImageView *shippingImageView;
@property (weak, nonatomic) IBOutlet UILabel *personalDetailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressDetailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *setAsDefaultLabel;
@property (weak, nonatomic) IBOutlet UILabel *staticAddressLabel;
//Declare BSKeyboard variable
@property (strong, nonatomic) BSKeyboardControls *keyboardControls;
@property (weak, nonatomic) IBOutlet UIImageView *stateDropDownArrowImage;
@property (weak, nonatomic) IBOutlet UIButton *stateButton;

@end

@implementation AddressViewController
@synthesize profileData,isEditScreen,addressIndex;
@synthesize checkoutAddressViewObj;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    countryCodeArray = [NSArray new];
    regionArray = [NSMutableArray new];
    self.title=NSLocalizedText(@"personalDetails");
    self.navigationController.navigationBarHidden=false;
    [self addLeftBarButtonWithImage:true];
    selectedRegionCode=@"";
    selectedRegionId=@"0";
    //View initialized
    [self initializedView];
    //Add custom picker view and initialized indexs
    [self addCustomPickerView];
    //Get country code listing
    [myDelegate showIndicator];
    [self performSelector:@selector(getCountryCode) withObject:nil afterDelay:.1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.title=NSLocalizedText(@"personalDetails");
    self.navigationController.navigationBarHidden=false;
    [self addLeftBarButtonWithImage:true];
    //Allocate keyboard notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    //Bring front view picker view
    [self.view bringSubviewToFront:gNPickerViewObj.goNatuurPickerViewObj];
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

- (void)localizedText {
    _firstNameField.placeholder=NSLocalizedText(@"firstName");
    _lastNameField.placeholder=NSLocalizedText(@"lastName");
    _phoneNumberField.placeholder=NSLocalizedText(@"phoneNumber");
    _companyField.placeholder=NSLocalizedText(@"companyPlaceholder");
    _firstAddressField.placeholder=NSLocalizedText(@"address1");
    _secondAddressField.placeholder=NSLocalizedText(@"address2");
    _countryField.placeholder=NSLocalizedText(@"country");
    _stateField.placeholder=NSLocalizedText(@"state");
    _cityField.placeholder=NSLocalizedText(@"city");
    _ZipcodeField.placeholder=NSLocalizedText(@"postal");
    _faxField.placeholder=NSLocalizedText(@"fax");
    if (isEditScreen) {
        [_saveAddressButton setTitle:NSLocalizedText(@"updateSave") forState:UIControlStateNormal];
    }
    else {
        [_saveAddressButton setTitle:NSLocalizedText(@"save") forState:UIControlStateNormal];
    }
    [_isBillingButton setTitle:NSLocalizedText(@"billing") forState:UIControlStateNormal];
    [_isShippingButton setTitle:NSLocalizedText(@"shipping") forState:UIControlStateNormal];
    _personalDetailsLabel.text=NSLocalizedText(@"personalDetails");
    _addressDetailsLabel.text=NSLocalizedText(@"addressDetails");
    _setAsDefaultLabel.text=NSLocalizedText(@"setAsDefault");
    _staticAddressLabel.text=NSLocalizedText(@"address");
}
#pragma mark - end

#pragma mark - View initialization
- (void)initializedView {
        //Set frames
    _emailLabel.translatesAutoresizingMaskIntoConstraints=true;
    _addressFieldsContainerView.translatesAutoresizingMaskIntoConstraints=true;
    _addressContainerView.translatesAutoresizingMaskIntoConstraints=true;
    float newHeight =[DynamicHeightWidth getDynamicLabelHeight:[UserDefaultManager getValue:@"emailId"] font:[UIFont montserratSemiBoldWithSize:15] widthValue:[[UIScreen mainScreen] bounds].size.width-40 heightValue:50];
    _emailLabel.text = [UserDefaultManager getValue:@"emailId"];
    _emailLabel.frame=CGRectMake(20, _profileImageView.frame.origin.y + _profileImageView.frame.size.height + 10 ,[[UIScreen mainScreen] bounds].size.width-40, newHeight);
    _addressFieldsContainerView.frame=CGRectMake(0, _emailLabel.frame.origin.y + _emailLabel.frame.size.height + 10, [[UIScreen mainScreen]bounds].size.width,_addressFieldsContainerView.frame.size.height);
    _addressContainerView.frame=CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 180+newHeight+_addressFieldsContainerView.frame.size.height);
    _scrollView.contentSize = CGSizeMake(0,_addressContainerView.frame.size.height);
    //set llocalized text
    [self localizedText];
    //Customise view
    [self customizedTextField];
    [self viewCustomisation];
}

- (void)viewCustomisation {
    [_profileImageView setCornerRadius:_profileImageView.frame.size.width/2];
    [_profileImageView setBorder:_profileImageView color:[UIColor colorWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:1.0] borderWidth:3.0];
    [ImageCaching downloadImages:_profileImageView imageUrl:[UserDefaultManager getValue:@"profilePicture"] placeholderImage:@"profile_placeholder" isDashboardCell:true];
}

- (void)customizedTextField {
    //Adding textfield to keyboard controls array
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:@[_firstNameField, _lastNameField, _phoneNumberField,_companyField, _stateField, _cityField,_ZipcodeField, _firstAddressField, _secondAddressField,_faxField]]];
    [_keyboardControls setDelegate:self];
    [_firstNameField setTextBorder:_firstNameField color:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0]];
    [_lastNameField setTextBorder:_lastNameField color:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0]];
    [_phoneNumberField setTextBorder:_phoneNumberField color:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0]];
    [_stateField setTextBorder:_stateField color:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0]];
    [_cityField setTextBorder:_cityField color:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0]];
    [_firstAddressField setTextBorder:_firstAddressField color:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0]];
    [_secondAddressField setTextBorder:_secondAddressField color:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0]];
    [_ZipcodeField setTextBorder:_ZipcodeField color:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0]];
    [_countryField setTextBorder:_countryField color:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0]];
    [_companyField setTextBorder:_companyField color:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0]];
    [_faxField setTextBorder:_faxField color:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0]];
    [self addPaddingShadow];
}

- (void)addPaddingShadow {
    [_firstNameField addTextFieldPaddingWithoutImages:_firstNameField];
    [_lastNameField addTextFieldPaddingWithoutImages:_lastNameField];
    [_phoneNumberField addTextFieldPaddingWithoutImages:_phoneNumberField];
    [_stateField addTextFieldPaddingWithoutImages:_stateField];
    [_cityField addTextFieldPaddingWithoutImages:_cityField];
    [_firstAddressField addTextFieldPaddingWithoutImages:_firstAddressField];
    [_secondAddressField addTextFieldPaddingWithoutImages:_secondAddressField];
    [_ZipcodeField addTextFieldPaddingWithoutImages:_ZipcodeField];
    [_countryField addTextFieldPaddingWithoutImages:_countryField];
    [_companyField addTextFieldPaddingWithoutImages:_companyField];
    [_faxField addTextFieldPaddingWithoutImages:_faxField];
    //customisation of change password button
    [_saveAddressButton setCornerRadius:20.0];
    [_saveAddressButton addShadow:_saveAddressButton color:[UIColor blackColor]];
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
    [_keyboardControls setActiveField:textField];
    [gNPickerViewObj hidePickerView];
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

- (void)showKeyboardScrollView:(float)keyboardHeight {
    float backViewY=265 + _emailLabel.frame.size.height;
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

- (void)keyboardWillHide:(NSNotification *)notification {
    [self hideKeyboardScrollView];
}

- (void)hideKeyboardScrollView {
    if (!isPickerEnable) {
        _scrollView.contentSize = CGSizeMake(0,_addressContainerView.frame.size.height);
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:false];
    }
}

#pragma mark - end

#pragma mark - IBActions
- (IBAction)SelectProfilePhotoButtonAction:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedText(@"TakePhoto")                                                             delegate:self cancelButtonTitle:NSLocalizedText(@"alertCancel")destructiveButtonTitle:nil otherButtonTitles:NSLocalizedText(@"Camera"), NSLocalizedText(@"Gallery"), nil];
    [actionSheet showInView:self.view];
}

- (IBAction)selectCountryAction:(id)sender {
    isPickerEnable = true;
    [self.keyboardControls.activeField resignFirstResponder];
    NSMutableArray *countryNameArray = [NSMutableArray new];
    for (int i = 0; i < countryCodeArray.count; i++) {
        ProfileModel *dataModel=[countryCodeArray objectAtIndex:i];
        [countryNameArray addObject:dataModel.countryLocale];
    }
    currentSelectedTextField=_countryField;
    [self showKeyboardScrollView:230.0];
    [gNPickerViewObj showPickerView:countryNameArray selectedIndex:selectedCountryCodeIndex option:1 isCancelDelegate:false];
}

- (IBAction)selectStateAction:(id)sender {
    isPickerEnable = true;
    currentSelectedTextField=_stateField;
    [self showKeyboardScrollView:230.0];
    [gNPickerViewObj showPickerView:regionNameArray selectedIndex:selectedRegionIndex option:2 isCancelDelegate:false];
}

- (IBAction)setBillingAddressAction:(id)sender {
    [self.keyboardControls.activeField resignFirstResponder];
    if (isBilling) {
        isBilling = false;
        _billingImageView.image = [UIImage imageNamed:@"unselected"];
    } else {
        isBilling = true;
        _billingImageView.image = [UIImage imageNamed:@"selected"];
    }
}

- (IBAction)setShippingAddressAction:(id)sender {
    [self.keyboardControls.activeField resignFirstResponder];
    if (isShipping) {
        isShipping = false;
        _shippingImageView.image = [UIImage imageNamed:@"unselected"];
    } else {
        isShipping = true;
        _shippingImageView.image = [UIImage imageNamed:@"selected"];
    }
}

- (IBAction)saveAndUpdateButtonAction:(id)sender {
    [self.keyboardControls.activeField resignFirstResponder];
    //Perform change password validations
    if([self performValidations]) {
        [myDelegate showIndicator];
        [self performSelector:@selector(saveAndUpdateAddress) withObject:nil afterDelay:.1];
    }
}
#pragma mark - end

#pragma mark - Display edit address data
- (void) displayEditAddressData {
    NSDictionary *addressDict = [NSDictionary new];
    addressDict = [profileData.addressArray objectAtIndex:[addressIndex longValue]];
    for (int i = 0; i < countryCodeArray.count; i++) {
        if ([addressDict[@"country_id"] containsString:[[countryCodeArray objectAtIndex:i] countryId]]) {
            selectedCountryCodeIndex = i;
            [self displayCountryData:i];
        }
    }
    _firstNameField.text = addressDict[@"firstname"];
    _lastNameField.text = addressDict[@"lastname"];
    _phoneNumberField.text = addressDict[@"telephone"];
    _companyField.text = addressDict[@"company"];
    if (regionNameArray.count > 1) {
        for (int i = 0; i < regionNameArray.count; i++) {
            if ([[[addressDict objectForKey:@"region"]objectForKey:@"region"] containsString:[regionNameArray objectAtIndex:i]]) {
                selectedRegionIndex = i;
                [self displayRegionData:i];
            }
        }
    } else {
        _stateField.text = [[addressDict objectForKey:@"region"]objectForKey:@"region"];
        selectedRegionId=[[addressDict objectForKey:@"region"]objectForKey:@"region_id"];
        selectedRegionCode=[[addressDict objectForKey:@"region"]objectForKey:@"region_code"];
    }
    _cityField.text = addressDict[@"city"];
    NSArray *streetArray = addressDict[@"street"];
    _firstAddressField.text = [streetArray objectAtIndex:0];
    if (streetArray.count > 1) {
        _secondAddressField.text = [streetArray objectAtIndex:1];
    }
    _ZipcodeField.text = addressDict[@"postcode"];
    _faxField.text = addressDict[@"fax"];
    //Display address type data
    [self setaddressTypeData:addressDict];
}

- (void)setaddressTypeData:(NSDictionary *)addressDict {
    if ([addressDict[@"default_billing"]boolValue]==1 && [addressDict[@"default_shipping"]boolValue]==1) {
        isShipping = true;
        isBilling = true;
        _shippingImageView.image = [UIImage imageNamed:@"selected"];
        _billingImageView.image = [UIImage imageNamed:@"selected"];
    } else if ([addressDict[@"default_shipping"]boolValue]==1) {
        isShipping = true;
        isBilling = false;
        _shippingImageView.image = [UIImage imageNamed:@"selected"];
        _billingImageView.image = [UIImage imageNamed:@"unselected"];
    } else if ([addressDict[@"default_billing"]boolValue]==1) {
        isShipping = false;
        isBilling = true;
        _shippingImageView.image = [UIImage imageNamed:@"unselected"];
        _billingImageView.image = [UIImage imageNamed:@"selected"];
    } else {
        isShipping = false;
        isBilling = false;
        _shippingImageView.image = [UIImage imageNamed:@"unselected"];
        _billingImageView.image = [UIImage imageNamed:@"unselected"];
    }
}
#pragma mark - end

#pragma mark - Validations
- (BOOL)performValidations {
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    if ([_firstNameField isEmpty] || [_lastNameField isEmpty] || [_phoneNumberField isEmpty] || [_countryField isEmpty] || [_phoneNumberField isEmpty] || [_cityField isEmpty] || [_firstAddressField isEmpty] || [_ZipcodeField isEmpty]) {
        [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"emptyFieldMessage") closeButtonTitle:NSLocalizedText(@"alertOk") duration:0.0f];
        return NO;
    } else {
        return YES;
    }
}
#pragma mark - end

#pragma mark - Web services
//Get country code listing
- (void)getCountryCode {
    ProfileModel *changePasswordModel = [ProfileModel sharedUser];
    [changePasswordModel getCountryCodeService:^(ProfileModel *userData) {
        [myDelegate stopIndicator];
        NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"countryNameEnglish" ascending:YES];
        countryCodeArray = [userData.countryCodeArray
                            sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
        if (isEditScreen) {
            [self displayEditAddressData];
        }
    } onfailure:^(NSError *error) {
        
    }];
}

//Save and edit address
- (void)saveAndUpdateAddress {
    ProfileModel *dataModel = [ProfileModel sharedUser];
    NSDictionary * dataDict = @{@"city" : _cityField.text,
                                @"company" : _companyField.text,
                                @"country_id":selectedCountryId,
                                @"customer_id":[UserDefaultManager getValue:@"userId"],
                                @"default_billing":isBilling ? @"YES" : @"NO",
                                @"default_shipping":isShipping ? @"YES" : @"NO",
                                @"firstname":_firstNameField.text,
                                @"lastname":_lastNameField.text,
                                @"postcode":_ZipcodeField.text,
                                @"region": @{@"region" : _stateField.text,
                                             @"region_code":selectedRegionCode
                                             ,@"region_id":selectedRegionId},
                                @"region_id":selectedRegionId,
                                @"street": @[_firstAddressField.text,_secondAddressField.text],
                                @"telephone":_phoneNumberField.text,
                                @"fax":_faxField.text
                                };
    if (nil!=checkoutAddressViewObj) {
        [self popToCheckoutAddressScreen:[dataDict copy]];
        return;
    }
    if (isEditScreen) {
        NSDictionary *addressDict = [NSDictionary new];
        addressDict = [profileData.addressArray objectAtIndex:[addressIndex longValue]];
        [dataModel.addressArray removeObjectAtIndex:[addressIndex longValue]];
        [dataModel.addressArray insertObject:dataDict atIndex:[addressIndex longValue]];
    } else {
        [dataModel.addressArray addObject:dataDict];
    }
    dataModel.firstName = profileData.firstName;
    dataModel.lastName = profileData.lastName;
    dataModel.email = profileData.email;
    dataModel.websiteId = profileData.websiteId;
    dataModel.groupId = profileData.groupId;
    dataModel.customAttributeArray = profileData.customAttributeArray;
    [dataModel saveAndUpdateAddress:^(ProfileModel *userData) {
        [myDelegate stopIndicator];
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert addButton:NSLocalizedText(@"alertOk") actionBlock:^(void) {
            //Success action
            self.addressListView.profileData = userData;
            [self.navigationController popViewControllerAnimated:true];
        }];
        if (isEditScreen) {
            [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"updateAddressSuccessMessage") closeButtonTitle:nil duration:0.0f];
        } else {
            [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"addAddressSuccessMessage") closeButtonTitle:nil duration:0.0f];
        }
    } onfailure:^(NSError *error) {
        
    }];
}

//edit profile
- (void)editProfileImage {
    ProfileModel *userData = [ProfileModel sharedUser];
    userData.userImage=_profileImageView.image;
    [userData updateUserProfileImage:^(ProfileModel *userData) {
        [myDelegate stopIndicator];
        //dispaly profile data
    } onfailure:^(NSError *error) {
        
    }];
}
#pragma mark - end

- (void)popToCheckoutAddressScreen:(NSDictionary *)tempDict {
    NSMutableArray *streetTempArray=[NSMutableArray new];
    for (NSString *street in tempDict[@"street"]) {
        [streetTempArray addObject:street];
    }
    NSDictionary *parameters = @{@"id" : [UserDefaultManager getNumberValue:@"id" dictData:tempDict],
                                 @"region" : [tempDict[@"region"] objectForKey:@"region"],
                                 @"region_id" : [UserDefaultManager getNumberValue:[tempDict objectForKey:@"region_id"] dictData:tempDict],
                                 @"region_code" : [tempDict[@"region"] objectForKey:@"region_code"],
                                 @"country_id" : [UserDefaultManager checkStringNull:@"country_id" dictData:tempDict],
                                 @"company" : [UserDefaultManager checkStringNull:@"company" dictData:tempDict],
                                 @"telephone" : tempDict[@"telephone"],
                                 @"fax" : [UserDefaultManager checkStringNull:@"fax" dictData:tempDict],
                                 @"postcode" : tempDict[@"postcode"],
                                 @"city" : tempDict[@"city"],
                                 @"firstname" : tempDict[@"firstname"],
                                 @"lastname" : tempDict[@"lastname"],
                                 @"email" : [UserDefaultManager getValue:@"emailId"],
                                 @"customer_id": [UserDefaultManager getValue:@"userId"],
                                 @"street":[streetTempArray copy]
                                 };
    if (checkoutAddressViewObj.isBillingAddress) {
        checkoutAddressViewObj.cartModelData.billingAddressDict=[parameters mutableCopy];
    }
    else {
        checkoutAddressViewObj.cartModelData.shippingAddressDict=[parameters mutableCopy];
    }
    checkoutAddressViewObj.isEditService=true;
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[CheckoutAddressViewController class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
            
            break;
        }
    }
}

#pragma mark - Add picker
- (void)addCustomPickerView {
    //Set initial index of picker view and initialized picker view
    selectedCountryCodeIndex=0;
    gNPickerViewObj=[[GoNatuurPickerView alloc] initWithFrame:self.view.frame delegate:self pickerHeight:230];
    [self.view addSubview:gNPickerViewObj.goNatuurPickerViewObj];
}
#pragma mark - end

#pragma mark - Custom picker delegate method
- (void)goNatuurPickerViewDelegateActionIndex:(int)tempSelectedIndex option:(int)option {
    if (option==1) {
        _stateField.text = @"";
        selectedCountryCodeIndex=tempSelectedIndex;
        [self displayCountryData:tempSelectedIndex];
    } else {
        selectedRegionIndex=tempSelectedIndex;
        [self displayRegionData:tempSelectedIndex];
    }
}
#pragma mark - end

#pragma mark - Display picker data
- (void)displayRegionData:(long)index {
    ProfileModel *dataModel=[countryCodeArray objectAtIndex:selectedCountryCodeIndex];
    regionArray = dataModel.regionArray;
    dataModel=[regionArray objectAtIndex:index];
    selectedRegionId=dataModel.regionId;
    selectedRegionCode=dataModel.regionCode;
    _stateField.text=dataModel.regionName;
    [_stateField endEditing:YES];
}

- (void)displayCountryData:(long)index {
    ProfileModel *dataModel=[countryCodeArray objectAtIndex:index];
    selectedCountryId=dataModel.countryId;
    _countryField.text=dataModel.countryLocale;
    regionNameArray = [NSMutableArray new];
    dataModel=[countryCodeArray objectAtIndex:selectedCountryCodeIndex];
    regionArray = dataModel.regionArray;
    for (int i = 0; i < regionArray.count; i++) {
        ProfileModel *dataModel=[regionArray objectAtIndex:i];
        [regionNameArray addObject:dataModel.regionName];
    }
    if (regionNameArray.count > 0) {
        _stateDropDownArrowImage.hidden = NO;
        _stateButton.hidden = NO;
        //Adding textfield to keyboard controls array
        [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:@[_firstNameField, _lastNameField, _phoneNumberField,_companyField, _cityField,_ZipcodeField, _firstAddressField, _secondAddressField,_faxField]]];
        [_keyboardControls setDelegate:self];
    } else {
        _stateDropDownArrowImage.hidden = YES;
        _stateButton.hidden = YES;
        //Adding textfield to keyboard controls array
        [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:@[_firstNameField, _lastNameField, _phoneNumberField,_companyField, _stateField, _cityField,_ZipcodeField, _firstAddressField, _secondAddressField,_faxField]]];
        [_keyboardControls setDelegate:self];
    }
}
#pragma mark - end

#pragma mark - Action sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if (buttonIndex==0) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedText(@"error") message:NSLocalizedText(@"noCamera")delegate:nil cancelButtonTitle:NSLocalizedText(@"alertOk") otherButtonTitles: nil];
            [myAlertView show];
        }
        else {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:NULL];
        }
    }
    if ([buttonTitle isEqualToString:NSLocalizedText(@"Gallery")]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.navigationBar.translucent = NO;
        picker.navigationBar.barTintColor = [UIColor colorWithRed:242.0/255.0 green:233.0/255.0 blue:237.0/255.0 alpha:1];
        picker.navigationBar.tintColor = [UIColor blackColor];
        picker.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor]};
        [self presentViewController:picker animated:YES completion:NULL];
    }
}
#pragma mark - end

#pragma mark - Image picker controller delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)info {
    isPickerEnable = false;
    UIImage *correctOrientationImage = [image fixOrientation];
    _profileImageView.image=correctOrientationImage;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [myDelegate showIndicator];
    [self performSelector:@selector(editProfileImage) withObject:nil afterDelay:.1];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    isPickerEnable = false;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark - end
@end
