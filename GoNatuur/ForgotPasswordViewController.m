//
//  ForgotPasswordViewController.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 04/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "LoginModel.h"
#import "UITextField+Validations.h"
#import "UITextField+Padding.h"
#import "BSKeyboardControls.h"
#import "UITextField+Validations.h"
#import "UITextField+Padding.h"

@interface ForgotPasswordViewController ()<BSKeyboardControlsDelegate> {
@private
    UITextField *currentSelectedTextField;
    float forgotBackViewY;
    UIView *currentView;
}
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIView *forgotPasswordView;
@property (strong, nonatomic) IBOutlet UILabel *forgotYourPasswordLabel;
@property (strong, nonatomic) IBOutlet UIView *resetPasswordView;
@property (strong, nonatomic) IBOutlet UITextField *otpTextField;
@property (strong, nonatomic) IBOutlet UITextField *resetEmailTextField;
@property (strong, nonatomic) IBOutlet UITextField *resetPasswordTextField;
@property (strong, nonatomic) IBOutlet UITextField *resetConfirmPasswordTextField;
@property (strong, nonatomic) BSKeyboardControls *keyboardControls;
@end

@implementation ForgotPasswordViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden=YES;
    [self initializedView];
    //add text field padding
    [_emailTextField addTextFieldLeftRightPadding:self.emailTextField];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    //Allocate keyboard notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
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
#pragma mark - end

#pragma mark - View initialization
- (void)initializedView {
    _forgotYourPasswordLabel.text=NSLocalizedText(@"forgotpassword");
    float scaleFactor = [[UIScreen mainScreen]bounds].size.height/568.0;
    forgotBackViewY=100*scaleFactor;
    _forgotPasswordView.translatesAutoresizingMaskIntoConstraints=true;
    _resetPasswordView.translatesAutoresizingMaskIntoConstraints=true;
    _forgotPasswordView.frame=CGRectMake(13, forgotBackViewY, [[UIScreen mainScreen] bounds].size.width-26, 350);
    _resetPasswordView.frame=CGRectMake(13, forgotBackViewY, [[UIScreen mainScreen] bounds].size.width-26, 350);
    _forgotPasswordView.hidden=false;
    _resetPasswordView.hidden=true;
    [self customizedTextField];
    currentView=_forgotPasswordView;
}

- (void)customizedTextField {
    //Add textfield to keyboard controls array
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:@[_emailTextField]]];
    [_keyboardControls setDelegate:self];
    //Add text field border and padding
    [_emailTextField setTextBorder:_emailTextField color:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0]];
    [_otpTextField setTextBorder:_otpTextField color:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0]];
    [_resetEmailTextField setTextBorder:_resetEmailTextField color:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0]];
    [_resetPasswordTextField setTextBorder:_resetPasswordTextField color:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0]];
    [_resetConfirmPasswordTextField setTextBorder:_resetConfirmPasswordTextField color:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0]];
    [_emailTextField addTextFieldLeftRightPadding:_emailTextField];
    [_otpTextField addTextFieldLeftRightPadding:_otpTextField];
    [_resetEmailTextField addTextFieldLeftRightPadding:_resetEmailTextField];
    [_resetPasswordTextField addTextFieldLeftRightPadding:_resetPasswordTextField];
    [_resetConfirmPasswordTextField addTextFieldLeftRightPadding:_resetConfirmPasswordTextField];
}
#pragma mark - end

#pragma mark - Keyboard control delegate
- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction {
    UIView *view;
    view = field.superview.superview.superview;
}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls {
    currentView.frame=CGRectMake(13, forgotBackViewY, [[UIScreen mainScreen] bounds].size.width-26, 350);
    [keyboardControls.activeField resignFirstResponder];
}
#pragma mark - end

#pragma mark - Textfield delegates
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [_keyboardControls setActiveField:textField];
    currentSelectedTextField=textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    currentView.frame=CGRectMake(13, forgotBackViewY, [[UIScreen mainScreen] bounds].size.width-26, 350);
    [textField resignFirstResponder];
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    //Set field position after show keyboard
    NSDictionary* info = [notification userInfo];
    NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    //Set condition according to check if current selected textfield is behind keyboard
    if (forgotBackViewY+currentSelectedTextField.frame.origin.y+currentSelectedTextField.frame.size.height<([UIScreen mainScreen].bounds.size.height)-[aValue CGRectValue].size.height) {
        currentView.frame=CGRectMake(13, forgotBackViewY, [[UIScreen mainScreen] bounds].size.width-26, 350);
    }
    else {
        currentView.frame=CGRectMake(13, forgotBackViewY-(((forgotBackViewY+currentSelectedTextField.frame.origin.y+currentSelectedTextField.frame.size.height)- ([UIScreen mainScreen].bounds.size.height-[aValue CGRectValue].size.height))+10), [[UIScreen mainScreen] bounds].size.width-26, 350);
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    currentView.frame=CGRectMake(13, forgotBackViewY, [[UIScreen mainScreen] bounds].size.width-26, 350);
}
#pragma mark - end

#pragma mark - IBAction
- (IBAction)goBackToLoginViewButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)resendOTPButtonAction:(id)sender {
    [self.view endEditing:true];
    currentView.frame=CGRectMake(13, forgotBackViewY, [[UIScreen mainScreen] bounds].size.width-26, 350);
    UIView *moveResetView = _forgotPasswordView;
    [self addRightAnimationPresentToView:moveResetView];
    _resetPasswordView.hidden=true;
    _forgotPasswordView.hidden=false;
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:@[_emailTextField]]];
    [_keyboardControls setDelegate:self];
    currentView=_forgotPasswordView;
}

- (IBAction)sendPasswordButtonAction:(id)sender {
    [self.view endEditing:true];
    currentView.frame=CGRectMake(13, forgotBackViewY, [[UIScreen mainScreen] bounds].size.width-26, 350);
    //Perform forgot password validations
    if([self performValidationsForForgotPassword]) {
        [myDelegate showIndicator];
        [self performSelector:@selector(forgotPassword) withObject:nil afterDelay:.1];
    }
}

- (IBAction)resetPassword:(UIButton *)sender {
    [self.view endEditing:true];
    currentView.frame=CGRectMake(13, forgotBackViewY, [[UIScreen mainScreen] bounds].size.width-26, 350);
    //Perform reset password validations
    if([self performValidationsForResetPassword]) {
        [myDelegate showIndicator];
        [self performSelector:@selector(resetPassword) withObject:nil afterDelay:.1];
    }
}
#pragma mark - end

#pragma mark - Form validations
- (BOOL)performValidationsForForgotPassword {
    if ([_emailTextField isEmpty]) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"emptyFieldMessage") closeButtonTitle:NSLocalizedText(@"alertOk") duration:0.0f];
        return NO;
    }
    else if (![_emailTextField isValidEmail]) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"validEmailMessage") closeButtonTitle:NSLocalizedText(@"alertOk") duration:0.0f];
        return NO;
    }
    else {
        return YES;
    }
}

- (BOOL)performValidationsForResetPassword {
    if ([_emailTextField isEmpty]||[_otpTextField isEmpty]||[_resetPasswordTextField isEmpty]||[_resetConfirmPasswordTextField isEmpty]) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"emptyFieldMessage") closeButtonTitle:NSLocalizedText(@"alertOk") duration:0.0f];
        return NO;
    }
    else if (![_emailTextField isValidEmail]) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"validEmailMessage") closeButtonTitle:NSLocalizedText(@"alertOk") duration:0.0f];
        return NO;
    }
    else if (![_emailTextField isValidEmail]) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"validEmailMessage") closeButtonTitle:NSLocalizedText(@"alertOk") duration:0.0f];
        return NO;
    }
    else if (_resetPasswordTextField.text.length<8) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"passwordMinimumCharater") closeButtonTitle:NSLocalizedText(@"alertOk") duration:0.0f];
        return NO;
    }
    else if (![_resetPasswordTextField isValidPassword]) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"validPassword") closeButtonTitle:NSLocalizedText(@"alertOk") duration:0.0f];
        return NO;
    }
    else if (![_resetPasswordTextField.text isEqualToString:_resetConfirmPasswordTextField.text]) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"passwordMatchMessage") closeButtonTitle:NSLocalizedText(@"alertOk") duration:0.0f];
        return NO;
    }
    else {
        return YES;
    }
}
#pragma mark - end

#pragma mark - Webservices
//Forgot password webservice called
- (void)forgotPassword {
    LoginModel *userLogin = [LoginModel sharedUser];
    userLogin.email = _emailTextField.text;
    [userLogin forgotPasswordService:^(LoginModel *userData) {
        [myDelegate stopIndicator];
        _resetEmailTextField.text=_emailTextField.text;
        UIView *moveForgotView = _resetPasswordView;
        [self addLeftAnimationPresentToView:moveForgotView];
        _resetPasswordView.hidden=false;
        _forgotPasswordView.hidden=true;
        [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:@[_otpTextField, _resetEmailTextField, _resetPasswordTextField, _resetConfirmPasswordTextField]]];
        [_keyboardControls setDelegate:self];
        currentView=_resetPasswordView;
    } onfailure:^(NSError *error) {
        
    }];
}

//Reset password webservice called
- (void)resetPassword {
    LoginModel *userLogin = [LoginModel sharedUser];
    userLogin.email=_resetEmailTextField.text;
    userLogin.otpNumber=_otpTextField.text;
    userLogin.password=_resetPasswordTextField.text;
    [userLogin resetPasswordService:^(LoginModel *userData) {
        [myDelegate stopIndicator];
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert addButton:@"Ok" actionBlock:^(void) {
            //add action
            [self.navigationController popViewControllerAnimated:true];
        }];
        [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"resetPasswordSuccess") closeButtonTitle:nil duration:0.0f];
    } onfailure:^(NSError *error) {
        
    }];
}
#pragma mark - end

#pragma mark - Swipe Images
//Adding left animation to banner images
- (void)addLeftAnimationPresentToView:(UIView *)viewTobeAnimatedLeft {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [transition setValue:@"IntroSwipeIn" forKey:@"IntroAnimation"];
    transition.fillMode=kCAFillModeForwards;
    transition.type = kCATransitionPush;
    transition.subtype =kCATransitionFromRight;
    [viewTobeAnimatedLeft.layer addAnimation:transition forKey:nil];
}

//Adding right animation to banner images
- (void)addRightAnimationPresentToView:(UIView *)viewTobeAnimatedRight {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [transition setValue:@"IntroSwipeIn" forKey:@"IntroAnimation"];
    transition.fillMode=kCAFillModeForwards;
    transition.type = kCATransitionPush;
    transition.subtype =kCATransitionFromLeft;
    [viewTobeAnimatedRight.layer addAnimation:transition forKey:nil];
}
@end
