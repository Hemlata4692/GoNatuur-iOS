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

@interface AddressViewController ()<BSKeyboardControlsDelegate,GoNatuurPickerViewDelegate>
{
@private
    UITextField *currentSelectedTextField;
    NSMutableArray *countryCodeArray;
    int selectedCountryCodeIndex;
    GoNatuurPickerView *gNPickerViewObj;
    NSString *selectedCountryId;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *addressContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UIView *addressFieldsContainerView;
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;
@property (weak, nonatomic) IBOutlet UITextField *firstAddressField;
@property (weak, nonatomic) IBOutlet UITextField *secondAddressField;
@property (weak, nonatomic) IBOutlet UITextField *countryField;
@property (weak, nonatomic) IBOutlet UITextField *stateField;
@property (weak, nonatomic) IBOutlet UITextField *cityField;
@property (weak, nonatomic) IBOutlet UITextField *ZipcodeField;
@property (weak, nonatomic) IBOutlet UIButton *saveAddressButton;
//Declare BSKeyboard variable
@property (strong, nonatomic) BSKeyboardControls *keyboardControls;

@end

@implementation AddressViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    //Add custom picker view and initialized indexs
    [self addCustomPickerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    countryCodeArray = [NSMutableArray new];
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
    //View initialized
    [self initializedView];
    //Get country code listing
    [myDelegate showIndicator];
    [self performSelector:@selector(getCountryCode) withObject:nil afterDelay:.1];
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
#pragma mark - end

#pragma mark - View initialization
- (void)initializedView {
    //Bring front view picker view
    [self.view bringSubviewToFront:gNPickerViewObj.goNatuurPickerViewObj];
    //Set frames
    _emailLabel.translatesAutoresizingMaskIntoConstraints=true;
    _addressFieldsContainerView.translatesAutoresizingMaskIntoConstraints=true;
    _addressContainerView.translatesAutoresizingMaskIntoConstraints=true;
    float newHeight =[DynamicHeightWidth getDynamicLabelHeight:[UserDefaultManager getValue:@"emailId"] font:[UIFont montserratSemiBoldWithSize:15] widthValue:[[UIScreen mainScreen] bounds].size.width-80 heightValue:50];
    _emailLabel.text = [UserDefaultManager getValue:@"emailId"];
    _emailLabel.frame=CGRectMake(40, _profileImageView.frame.origin.y + _profileImageView.frame.size.height + 10 ,[[UIScreen mainScreen] bounds].size.width-80, newHeight);
    _addressFieldsContainerView.frame=CGRectMake(0, _emailLabel.frame.origin.y + _emailLabel.frame.size.height + 10, [[UIScreen mainScreen]bounds].size.width,_addressFieldsContainerView.frame.size.height);
    _addressContainerView.frame=CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 200+newHeight+_addressFieldsContainerView.frame.size.height);
    _scrollView.contentSize = CGSizeMake(0,_addressContainerView.frame.size.height);
    //Customise
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
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:@[_firstNameField, _lastNameField, _phoneNumberField, _stateField, _cityField, _firstAddressField, _secondAddressField,_ZipcodeField]]];
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
    //customisation of change password button
    [_saveAddressButton setCornerRadius:17.0];
    [_saveAddressButton addShadow:_saveAddressButton color:[UIColor blackColor]];
}
#pragma mark - end

#pragma mark - Keyboard control delegate
- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction {
    UIView *view;
    view = field.superview.superview.superview;
}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControl {
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [keyboardControl.activeField resignFirstResponder];
}
#pragma mark - end

#pragma mark - Textfield delegates
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [_keyboardControls setActiveField:textField];
    currentSelectedTextField=textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    //Set field position after show keyboard
    NSDictionary* info = [notification userInfo];
    NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    float addressViewY = 255 + _emailLabel.frame.size.height;
    //Set condition according to check if current selected textfield is behind keyboard
    if (addressViewY+currentSelectedTextField.frame.origin.y+currentSelectedTextField.frame.size.height<([UIScreen mainScreen].bounds.size.height)-[aValue CGRectValue].size.height) {
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else {
        [_scrollView setContentOffset:CGPointMake(0, ((addressViewY+currentSelectedTextField.frame.origin.y+currentSelectedTextField.frame.size.height)- ([UIScreen mainScreen].bounds.size.height-[aValue CGRectValue].size.height))+10) animated:NO];
    }
    //Change content size of scroll view if current selected textfield is behind keyboard
    if ([aValue CGRectValue].size.height-([UIScreen mainScreen].bounds.size.height-(addressViewY+_ZipcodeField.frame.origin.y+_ZipcodeField.frame.size.height))>0) {
        _scrollView.contentSize = CGSizeMake(0,[UIScreen mainScreen].bounds.size.height+([aValue CGRectValue].size.height-([UIScreen mainScreen].bounds.size.height-(addressViewY+_ZipcodeField.frame.origin.y+_ZipcodeField.frame.size.height))));
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    _scrollView.contentSize = CGSizeMake(0,_addressContainerView.frame.size.height);
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)SelectProfilePhotoButtonAction:(id)sender {
}

- (IBAction)selectCountryAction:(id)sender {
    NSMutableArray *countryNameArray = [NSMutableArray new];
    for (int i = 0; i < countryCodeArray.count; i++) {
        ProfileModel *dataModel=[countryCodeArray objectAtIndex:i];
        //show language change picker
        [countryNameArray addObject:dataModel.countryLocale];
    }
    [gNPickerViewObj showPickerView:countryNameArray selectedIndex:selectedCountryCodeIndex option:1 isCancelDelegate:false];
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

#pragma mark - Web services
//Get country code listing
- (void)getCountryCode {
    ProfileModel *changePasswordModel = [ProfileModel sharedUser];
    [changePasswordModel getCountryCodeService:^(ProfileModel *userData) {
        [myDelegate stopIndicator];
        countryCodeArray = userData.countryCodeArray;
    } onfailure:^(NSError *error) {
        
    }];
}

//Save and edit address
- (void)saveAndUpdateAddress {
    
}
#pragma mark - end

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
        selectedCountryCodeIndex=tempSelectedIndex;
        ProfileModel *dataModel=[countryCodeArray objectAtIndex:tempSelectedIndex];
        selectedCountryId=dataModel.countryId;
        _countryField.text=dataModel.countryLocale;
    }
}
#pragma mark - end

@end
