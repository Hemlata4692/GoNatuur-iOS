//
//  EditProfileViewController.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 30/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "EditProfileViewController.h"
#import "UITextField+Padding.h"
#import "BSKeyboardControls.h"
#import "GoNatuurPickerView.h"
#import "CurrencyDataModel.h"
#import "ProfileModel.h"
#import "AddressListingViewController.h"
#import "AddressViewController.h"

@interface EditProfileViewController ()<BSKeyboardControlsDelegate,GoNatuurPickerViewDelegate> {
    UITextField *currentSelectedTextField;
    NSMutableArray *changeCurrencyArray;
    NSArray *changeLanguageArray;
    GoNatuurPickerView *gNPickerViewObj;
    int languagePickerIndex, currencyPickerIndex;
    ProfileModel *profileData;
}
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *changeLaguageTextField;
@property (weak, nonatomic) IBOutlet UITextField *changeCurrencyTextField;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) BSKeyboardControls *keyboardControls;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *mainView;

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    changeLanguageArray = @[NSLocalizedText(@"en"), NSLocalizedText(@"zh"), NSLocalizedText(@"cn")];
    changeCurrencyArray = [[UserDefaultManager getValue:@"AvailableCurrencyCodes"] mutableCopy];
    
    [myDelegate showIndicator];
    [self performSelector:@selector(getUserProfile) withObject:nil afterDelay:.1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self customizeViewFields];
    [self addCustomPickerView];
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
    _firstNameTextField.text=@"";
    _lastNameTextField.text=@"";
}

#pragma mark - Customise text fields
- (void)customizeViewFields {
    //Add textfield to keyboard controls array
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:@[_firstNameTextField, _lastNameTextField]]];
    [_keyboardControls setDelegate:self];
    //Add text field border and padding
    [_firstNameTextField setTextBorder:_firstNameTextField color:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0]];
    [_lastNameTextField setTextBorder:_lastNameTextField color:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0]];
    [_changeLaguageTextField setTextBorder:_changeLaguageTextField color:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0]];
    [_changeCurrencyTextField setTextBorder:_changeCurrencyTextField color:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0]];
    [_firstNameTextField addTextFieldPaddingWithoutImages:_firstNameTextField];
    [_lastNameTextField addTextFieldPaddingWithoutImages:_lastNameTextField];
    [_changeLaguageTextField addTextFieldPaddingWithoutImages:_changeLaguageTextField];
    [_changeCurrencyTextField addTextFieldPaddingWithoutImages:_changeCurrencyTextField];
    //customisation of change password button
    [_saveButton setCornerRadius:17.0];
    [_saveButton addShadow:_saveButton color:[UIColor blackColor]];
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
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [_keyboardControls setActiveField:textField];
    currentSelectedTextField=textField;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    //Set field position after show keyboard
    NSDictionary* info = [notification userInfo];
    NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    float keyboardHeight=[aValue CGRectValue].size.height;
    [self scrollViewInsetes:keyboardHeight];
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    _scrollView.contentSize = CGSizeMake(0,_mainView.frame.size.height+30);
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)scrollViewInsetes:(float)height {
    //Set condition according to check if current selected textfield is behind keyboard
    if (110+currentSelectedTextField.frame.origin.y+currentSelectedTextField.frame.size.height<([UIScreen mainScreen].bounds.size.height)-height) {
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else {
        [_scrollView setContentOffset:CGPointMake(0, ((110+currentSelectedTextField.frame.origin.y+currentSelectedTextField.frame.size.height)- ([UIScreen mainScreen].bounds.size.height-height))+10) animated:NO];
    }
    //Change content size of scroll view if current selected textfield is behind keyboard
    if (height-([UIScreen mainScreen].bounds.size.height-(205+_lastNameTextField.frame.origin.y+_lastNameTextField.frame.size.height))>0) {
        _scrollView.contentSize = CGSizeMake(0,[UIScreen mainScreen].bounds.size.height+(height-([UIScreen mainScreen].bounds.size.height-(_lastNameTextField.frame.origin.y+_lastNameTextField.frame.size.height))) + 210);
    }
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)saveButtonAction:(id)sender {
}

- (IBAction)manageAddressesButtionAction:(id)sender {
    ////4=> English,5=>traditional,6=>simplified
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddressListingViewController * nextView=[sb instantiateViewControllerWithIdentifier:@"AddressListingViewController"];
    nextView.profileData = profileData;
    [self.navigationController pushViewController:nextView animated:YES];
}

- (IBAction)languagePickerButtonActio:(id)sender {
    //show language change picker
    currentSelectedTextField=_changeLaguageTextField;
    [self scrollViewInsetes:230];
    [gNPickerViewObj showPickerView:changeLanguageArray selectedIndex:languagePickerIndex option:1 isCancelDelegate:true];
}

- (IBAction)currencyPickerButtonActio:(id)sender {
    //show currency change picker
    currentSelectedTextField=_changeCurrencyTextField;
    [self scrollViewInsetes:230];
    [gNPickerViewObj showPickerView:changeCurrencyArray selectedIndex:currencyPickerIndex option:2 isCancelDelegate:true];
}
#pragma mark - end

#pragma mark - Add picker
- (void)addCustomPickerView {
    //Set initial index of picker view and initialized picker view
    languagePickerIndex=-1;
    currencyPickerIndex=-1;
    gNPickerViewObj=[[GoNatuurPickerView alloc] initWithFrame:self.view.frame delegate:self pickerHeight:230];
    [self.view addSubview:gNPickerViewObj.goNatuurPickerViewObj];
}
#pragma mark - end

#pragma mark - Custom picker delegate method
- (void)goNatuurPickerViewDelegateActionIndex:(int)tempSelectedIndex option:(int)option {
    _scrollView.contentSize = CGSizeMake(0,_mainView.frame.size.height+30);
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    if (option==1) {
        languagePickerIndex=tempSelectedIndex;
        if (tempSelectedIndex == 0) {
            [UserDefaultManager setValue:@"en" key:@"Language"];
        } else if (tempSelectedIndex == 1) {
            [UserDefaultManager setValue:@"zh" key:@"Language"];
        } else if (tempSelectedIndex == 2) {
            [UserDefaultManager setValue:@"cn" key:@"Language"];
        }
        _changeLaguageTextField.text=[changeLanguageArray objectAtIndex:tempSelectedIndex];
    }
    else {
        currencyPickerIndex=tempSelectedIndex;
        _changeCurrencyTextField.text=[changeCurrencyArray objectAtIndex:tempSelectedIndex];
    }
}

- (void)cancelDelegateMethod {
    _scrollView.contentSize = CGSizeMake(0,_mainView.frame.size.height+30);
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}
#pragma mark - end

#pragma mark - Web services
//Get user profile
- (void)getUserProfile {
    ProfileModel *userData = [ProfileModel sharedUser];
    [userData getUserProfile:^(ProfileModel *userData) {
        [myDelegate stopIndicator];
        profileData = userData;
        //dispaly profile data
        [self displayData:userData];
    } onfailure:^(NSError *error) {
        
    }];
}

//display profile data
- (void)displayData:(ProfileModel *)data {
    _firstNameTextField.text=data.firstName;
    _lastNameTextField.text=data.lastName;
    //zh for traditional and cn for simplified
    //4=> English,5=>traditional,6=>simplified
    if ([data.defaultLanguage isEqualToString:@""] || data.defaultLanguage==nil) {
        _changeLaguageTextField.text=@"English";
    }
    else {
        if ([data.defaultLanguage intValue] == 4) {
            _changeLaguageTextField.text=NSLocalizedText(@"en");
        }
        else if ([data.defaultLanguage intValue] == 5) {
            _changeLaguageTextField.text=NSLocalizedText(@"zh");
        }
        else if ([data.defaultLanguage intValue] == 6) {
            _changeLaguageTextField.text=NSLocalizedText(@"cn");
        }
    }
    if ([data.defaultCurrency isEqualToString:@""] || data.defaultCurrency==nil) {
        _changeCurrencyTextField.text=@"INR";
    }
    else {
        _changeCurrencyTextField.text=data.defaultCurrency;
    }
}
#pragma mark - end
@end
