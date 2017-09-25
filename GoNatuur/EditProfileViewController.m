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
#import "UIImage+UIImage_fixOrientation.h"
#import "DynamicHeightWidth.h"
#import "AddressListingViewController.h"
#import "DashboardDataModel.h"

@interface EditProfileViewController ()<BSKeyboardControlsDelegate,GoNatuurPickerViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    UITextField *currentSelectedTextField;
    NSMutableArray *changeCurrencyArray;
    NSMutableArray *changeLanguageArray;
    GoNatuurPickerView *gNPickerViewObj;
    int languagePickerIndex, currencyPickerIndex;
    NSString *languageValue;
    ProfileModel *profileData;
    BOOL isImagePicker;
}
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *changeLaguageTextField;
@property (weak, nonatomic) IBOutlet UITextField *changeCurrencyTextField;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) BSKeyboardControls *keyboardControls;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userEmailLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *settingsLabel;
@property (weak, nonatomic) IBOutlet UIButton *manageAddButton;
@end

@implementation EditProfileViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    changeLanguageArray=[[NSMutableArray alloc]initWithObjects:NSLocalizedText(@"en"), NSLocalizedText(@"zh"), NSLocalizedText(@"cn"), nil];
    changeCurrencyArray = [[UserDefaultManager getValue:@"AvailableCurrencyCodes"] mutableCopy];
    languagePickerIndex=-1;
    currencyPickerIndex=-1;
     isImagePicker=false;
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
    if (!isImagePicker) {
        [self customizeViewFields];
        [self addCustomPickerView];
        [self localizedText];
    }
}

- (void)viewDidAppear:(BOOL)animated {
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
    _firstNameTextField.placeholder=NSLocalizedText(@"firstName");
    _lastNameTextField.placeholder=NSLocalizedText(@"lastName");
    _changeLaguageTextField.placeholder=NSLocalizedText(@"changeLanguage");
    _changeCurrencyTextField.placeholder=NSLocalizedText(@"changeCurrency");
    _detailsTitleLabel.text=NSLocalizedText(@"personalDetails");
    _settingsLabel.text=NSLocalizedText(@"personalSetting");
    [_saveButton setTitle:NSLocalizedText(@"save") forState:UIControlStateNormal];
    [_manageAddButton setTitle:NSLocalizedText(@"manageAddress") forState:UIControlStateNormal];
    _manageAddButton.translatesAutoresizingMaskIntoConstraints=YES;
    [_manageAddButton sizeToFit];
    _manageAddButton.frame=CGRectMake(([[UIScreen mainScreen] bounds].origin.x+[[UIScreen mainScreen] bounds].size.width/2)-(_manageAddButton.frame.size.width/2), _saveButton.frame.origin.y+_saveButton.frame.size.height+8, _manageAddButton.frame.size.width, 22);
    [_manageAddButton setBottomBorder:_manageAddButton color:[UIColor colorWithRed:182.0/255.0 green:37.0/255.0 blue:70.0/255.0 alpha:1.0]];
}
#pragma mark - end

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
    //customisation of save button
    [_saveButton setCornerRadius:20.0];
    [_saveButton addShadow:_saveButton color:[UIColor blackColor]];
    [_userImageView setBorder:_userImageView color:[UIColor colorWithRed:194.0/255.0 green:194.0/255.0 blue:194.0/255.0 alpha:1.0] borderWidth:3.0];
    [_userImageView setCornerRadius:60.0];
    [ImageCaching downloadImages:_userImageView imageUrl:[UserDefaultManager getValue:@"profilePicture"] placeholderImage:@"profile_placeholder" isDashboardCell:true];
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
    [myDelegate showIndicator];
    [self performSelector:@selector(saveUserProfile) withObject:nil afterDelay:.1];
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
- (IBAction)editUserImageButtonAction:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedText(@"TakePhoto")
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedText(@"alertCancel")
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedText(@"Camera"), NSLocalizedText(@"Gallery"), nil];
    [actionSheet showInView:self.view];
}
#pragma mark - end

#pragma mark - Action sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if (buttonIndex==0)
    {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedText(@"error")
                                                                  message:NSLocalizedText(@"noCamera")
                                                                 delegate:nil
                                                        cancelButtonTitle:NSLocalizedText(@"alertOk")
                                                        otherButtonTitles: nil];
            [myAlertView show];
        }
        else
        {
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
    UIImage *correctOrientationImage = [image fixOrientation];
    _userImageView.image=correctOrientationImage;
     isImagePicker=true;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [myDelegate showIndicator];
    [self performSelector:@selector(editProfileImageService) withObject:nil afterDelay:.1];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark - end


#pragma mark - Add picker
- (void)addCustomPickerView {
    //Set initial index of picker view and initialized picker view
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
            languageValue=@"4";
        } else if (tempSelectedIndex == 1) {
            [UserDefaultManager setValue:@"zh" key:@"Language"];
            languageValue=@"5";
        } else if (tempSelectedIndex == 2) {
            [UserDefaultManager setValue:@"cn" key:@"Language"];
            languageValue=@"6";
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
        profileData = userData;
        [myDelegate stopIndicator];
        //dispaly profile data
        for (NSDictionary *aDict in userData.customAttributeArray) {
            if ([[aDict objectForKey:@"attribute_code"] isEqualToString:@"DefaultLanguage"]) {
                userData.defaultLanguage=[aDict objectForKey:@"value"];
            }
        }
        for (NSDictionary *aDict in userData.customAttributeArray) {
            if ([[aDict objectForKey:@"attribute_code"] isEqualToString:@"DefaultCurrency"]) {
                userData.defaultCurrency=[aDict objectForKey:@"value"];
            }
        }
        [self displayData:userData];
    } onfailure:^(NSError *error) {
        
    }];
}

//edit profile
- (void)editProfileImageService {
    ProfileModel *userData = [ProfileModel sharedUser];
    userData.userImage=_userImageView.image;
    [userData updateUserProfileImage:^(ProfileModel *userData) {
        [myDelegate stopIndicator];
         isImagePicker=false;
        //dispaly profile data
    } onfailure:^(NSError *error) {
        
    }];
}

//display profile data
- (void)displayData:(ProfileModel *)data {
    _firstNameTextField.text=data.firstName;
    _lastNameTextField.text=data.lastName;
    _userEmailLabel.text=[UserDefaultManager getValue:@"emailId"];
    _userEmailLabel.translatesAutoresizingMaskIntoConstraints=YES;
    _userEmailLabel.numberOfLines=2;
    float newHeight =[DynamicHeightWidth getDynamicLabelHeight:_userEmailLabel.text font:[UIFont montserratSemiBoldWithSize:15] widthValue:[[UIScreen mainScreen] bounds].size.width-50 heightValue:50];
    _userEmailLabel.frame=CGRectMake(25, _userEmailLabel.frame.origin.y,[[UIScreen mainScreen] bounds].size.width-50, newHeight);
    //zh for traditional and cn for simplified
    //4=> English,5=>traditional,6=>simplified
    if ([data.defaultLanguage isEqualToString:@""] || data.defaultLanguage==nil) {
        _changeLaguageTextField.text=@"English";
        languageValue=@"4";
    }
    else {
        if ([data.defaultLanguage intValue] == 4) {
            _changeLaguageTextField.text=NSLocalizedText(@"en");
            languagePickerIndex=0;
            languageValue=@"4";
        }
        else if ([data.defaultLanguage intValue] == 5) {
            _changeLaguageTextField.text=NSLocalizedText(@"zh");
            languagePickerIndex=1;
            languageValue=@"5";
        }
        else if ([data.defaultLanguage intValue] == 6) {
            _changeLaguageTextField.text=NSLocalizedText(@"cn");
            languagePickerIndex=2;
            languageValue=@"6";
        }
    }
    if ([data.defaultCurrency isEqualToString:@""] || data.defaultCurrency==nil) {
        _changeCurrencyTextField.text=@"INR";
    }
    else {
        _changeCurrencyTextField.text=data.defaultCurrency;
    }
    int indexValue = (int)[changeCurrencyArray indexOfObject:_changeCurrencyTextField.text];
    currencyPickerIndex=indexValue;
}

//save user profile data
- (void)saveUserProfile {
    ProfileModel *userData = [ProfileModel sharedUser];
    userData.firstName=_firstNameTextField.text;
    userData.lastName=_lastNameTextField.text;
    userData.email=[UserDefaultManager getValue:@"emailId"];
    bool isLanguageExists=false;
    bool isCurrencyExists=false;
    for (NSDictionary *aDict in userData.customAttributeArray) {
        if ([[aDict objectForKey:@"attribute_code"] isEqualToString:@"DefaultLanguage"]) {
            [aDict setValue:languageValue forKey:@"value"];
            isLanguageExists=true;
            break;
        }
    }
    if (!isLanguageExists) {
        NSDictionary *dictionary= [NSDictionary dictionaryWithObjectsAndKeys:
                                   @"DefaultLanguage", @"attribute_code",
                                   languageValue, @"value", nil];
        [userData.customAttributeArray addObject:dictionary];
    }
    for (NSDictionary *aDict in userData.customAttributeArray) {
        if ([[aDict objectForKey:@"attribute_code"] isEqualToString:@"DefaultCurrency"]) {
            [aDict setValue:_changeCurrencyTextField.text forKey:@"value"];
            isCurrencyExists=true;
            break;
        }
    }
    if (!isCurrencyExists) {
        NSDictionary *dictionary= [NSDictionary dictionaryWithObjectsAndKeys:
                                   @"DefaultCurrency", @"attribute_code",
                                   _changeCurrencyTextField.text, @"value", nil];
        [userData.customAttributeArray addObject:dictionary];
    }
    
    [userData saveUserProfile:^(ProfileModel *userData) {
        [self getCategoryListData];
        NSMutableArray *ratesArray=[NSMutableArray new];
        for (int i =0; i<[[UserDefaultManager getValue:@"availableCurrencyRatesArray"] count]; i++) {
            NSDictionary * footerDataDict =[[UserDefaultManager getValue:@"availableCurrencyRatesArray"] objectAtIndex:i];
            CurrencyDataModel * exchangeData = [[CurrencyDataModel alloc]init];
            exchangeData.currencyExchangeCode = footerDataDict[@"currency_to"];
            exchangeData.currencyExchangeRates = footerDataDict[@"rate"];
            exchangeData.currencysymbol = footerDataDict[@"currency_symbol"];
            [ratesArray addObject:exchangeData];
        }
        for (int i=0; i<ratesArray.count; i++) {
            if ([[UserDefaultManager getValue:@"DefaultCurrencyCode"] containsString:[[ratesArray objectAtIndex:i] currencyExchangeCode]]) {
                [UserDefaultManager setValue:[[ratesArray objectAtIndex:i] currencyExchangeRates] key:@"ExchangeRates"];
                if ([[[ratesArray objectAtIndex:i] currencysymbol] isEqualToString:@""] || [[ratesArray objectAtIndex:i] currencysymbol]==nil) {
                    [UserDefaultManager setValue:[UserDefaultManager getValue:@"DefaultCurrencyCode"] key:@"DefaultCurrencySymbol"];
                }
                else {
                    [UserDefaultManager setValue:[[ratesArray objectAtIndex:i] currencysymbol] key:@"DefaultCurrencySymbol"];
                }
            }
        }
    } onfailure:^(NSError *error) {
        
    }];
}

//Get category list data
- (void)getCategoryListData {
    DashboardDataModel *categoryList = [DashboardDataModel sharedUser];
    categoryList.categoryId=@"2";
    [categoryList getCategoryListDataOnSuccess:^(DashboardDataModel *userData)  {
        myDelegate.categoryNameArray=[userData.categoryNameArray mutableCopy];
        self.categorySliderObjc.categoryDataArray=[myDelegate.categoryNameArray mutableCopy];
        [self.categorySliderObjc.categorySliderCollectionView reloadData];
         [myDelegate stopIndicator];
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert addButton:NSLocalizedText(@"alertOk") actionBlock:^(void) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"profileSuccess")  closeButtonTitle:nil duration:0.0f];
    } onfailure:^(NSError *error) {
        
    }];
}
#pragma mark - end
@end
