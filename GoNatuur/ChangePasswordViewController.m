//
//  ChangePasswordViewController.m
//  GoNatuur
//
//  Created by Monika on 8/29/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "BSKeyboardControls.h"
#import "BSKeyboardControls.h"
#import "UITextField+Validations.h"
#import "UITextField+Padding.h"
#import "ProfileModel.h"

@interface ChangePasswordViewController ()<BSKeyboardControlsDelegate>

@property (weak, nonatomic) IBOutlet UITextField *oldPassword;
@property (weak, nonatomic) IBOutlet UITextField *changePassword;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;
@property (weak, nonatomic) IBOutlet UIButton *changePasswordButton;
//Declare BSKeyboard variable
@property (strong, nonatomic) BSKeyboardControls *keyboardControls;

@end

@implementation ChangePasswordViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.title=NSLocalizedText(@"profileTitle");
    self.navigationController.navigationBarHidden=false;
    [self addLeftBarButtonWithImage:true];
    [self customizeViewFields];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    _oldPassword.text=@"";
    _changePassword.text=@"";
    _confirmPassword.text=@"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - end

#pragma mark - Customise text fields
- (void)customizeViewFields {
    //Add textfield to keyboard controls array
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:@[_oldPassword, _changePassword,_confirmPassword]]];
    [_keyboardControls setDelegate:self];
    //Add text field border and padding
    [_oldPassword setTextBorder:_oldPassword color:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0]];
    [_changePassword setTextBorder:_changePassword color:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0]];
    [_confirmPassword setTextBorder:_confirmPassword color:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0]];
    [_oldPassword addTextFieldPaddingWithoutImages:_oldPassword];
    [_changePassword addTextFieldPaddingWithoutImages:_changePassword];
    [_confirmPassword addTextFieldPaddingWithoutImages:_confirmPassword];
    //customisation of change password button
    [_changePasswordButton setCornerRadius:17.0];
    [_changePasswordButton addShadow:_changePasswordButton color:[UIColor blackColor]];
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
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - end

#pragma mark - Change password validation
- (BOOL)performValidations {
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    if ([_oldPassword isEmpty] || [_changePassword isEmpty] || [_confirmPassword isEmpty] ) {
        [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"emptyFieldMessage") closeButtonTitle:NSLocalizedText(@"alertOk") duration:0.0f];
        return NO;
    } else if (_oldPassword.text.length<8 || _changePassword.text.length<8 || _confirmPassword.text.length<8) {
        [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"validPassword") closeButtonTitle:NSLocalizedText(@"alertOk") duration:0.0f];
        return NO;
    } else if (!([_oldPassword isValidPassword] || [_changePassword isValidPassword] || [_confirmPassword isValidPassword])) {
        [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"validPassword") closeButtonTitle:NSLocalizedText(@"alertOk") duration:0.0f];
        return NO;
    } else if ([_oldPassword.text isEqualToString:_changePassword.text]) {
        [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"oldPasswordMatchMessage") closeButtonTitle:NSLocalizedText(@"alertOk") duration:0.0f];
        return NO;
    } else if (![_changePassword.text isEqualToString:_confirmPassword.text]) {
        [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"passwordMatchMessage") closeButtonTitle:NSLocalizedText(@"alertOk") duration:0.0f];
        return NO;
    } else {
        return YES;
    }
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)changePasswordAction:(id)sender {
    [self.keyboardControls.activeField resignFirstResponder];
    //Perform change password validations
    if([self performValidations]) {
        [myDelegate showIndicator];
        [self performSelector:@selector(changePasswordService) withObject:nil afterDelay:.1];
    }
}
#pragma mark - end

#pragma mark - Webservice
//Change user password
- (void)changePasswordService {
    ProfileModel *changePasswordModel = [ProfileModel sharedUser];
    changePasswordModel.currentPassword = _oldPassword.text;
    changePasswordModel.changePassword = _changePassword.text;
    [changePasswordModel changePasswordService:^(ProfileModel *userData) {
        [myDelegate stopIndicator];
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert addButton:@"Ok" actionBlock:^(void) {
            //Change password successful action
            [self.navigationController popViewControllerAnimated:true];
        }];
        [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"changePasswordSuccessMessage") closeButtonTitle:nil duration:0.0f];
    } onfailure:^(NSError *error) {
        
    }];
}
#pragma mark - end
@end
