//
//  LoginViewController.m
//  GoNatuur
//
//  Created by Hemlata Khajanchi on 17/07/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginModel.h"
#import "SignUpViewController.h"
#import "SocialLoginViewController.h"
#import "BSKeyboardControls.h"
#import "UITextField+Validations.h"
#import "UITextField+Padding.h"
#import "UIView+Toast.h"

@interface LoginViewController ()<UIGestureRecognizerDelegate, SocialLoginDelegate, BSKeyboardControlsDelegate> {
@private
    UITextField *currentSelectedTextField;
    float loginBackViewY;
    int isSocialLogin;
    float mainViewHeight;
    NSString *socialLoginID;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIView *loginBackView;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UILabel *registerLabel;
@property (strong, nonatomic) BSKeyboardControls *keyboardControls;
@property (weak, nonatomic) IBOutlet UILabel *orSeperatorLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginbutton;
@property (weak, nonatomic) IBOutlet UIButton *skipButton;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;
@end

@implementation LoginViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //        [self authenticationToken];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=true;
    //Allocate keyboard notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    //View initialized
    [self initializedView];
    //Add social login xib
    [self integrateSocialLoginView];
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
    _emailTextField.text=@"";
    _passwordTextField.text=@"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - View initialization
- (void)integrateSocialLoginView {
    SocialLoginViewController *obj = [[SocialLoginViewController alloc] initWithNibName:@"SocialLoginViewController" bundle:nil];
    obj.view.translatesAutoresizingMaskIntoConstraints=YES;
    obj.view.frame=CGRectMake(13, loginBackViewY, [[UIScreen mainScreen] bounds].size.width-26, 212);
    obj.fbText=NSLocalizedText(@"loginFb");
    obj.weChatText=NSLocalizedText(@"loginWeChat");
    obj.wieboText=NSLocalizedText(@"loginWiebo");
    obj.googlPlusText=NSLocalizedText(@"loginGooglePlus");
    obj.delegate=self;
    [self addChildViewController:obj];
    [_mainView addSubview:obj.view];
    [obj didMoveToParentViewController:self];
}

- (void)initializedView {
    isSocialLogin=0;
    float scaleFactor = [[UIScreen mainScreen]bounds].size.height/568.0;
    loginBackViewY=100*scaleFactor;
    mainViewHeight=loginBackViewY+540.0;
    if (mainViewHeight<=[[UIScreen mainScreen]bounds].size.height) {
        mainViewHeight=[[UIScreen mainScreen]bounds].size.height;
    }
    _loginBackView.translatesAutoresizingMaskIntoConstraints=true;
    _loginBackView.frame=CGRectMake(13, loginBackViewY, [[UIScreen mainScreen] bounds].size.width-26, 500);
    _mainView.translatesAutoresizingMaskIntoConstraints=true;
    _mainView.frame=CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, mainViewHeight);
    _scrollView.contentSize = CGSizeMake(0,_mainView.frame.size.height);
    //Set privacy policy attributed text
    [self setAttributString];
    [self customizedTextField];
    [self localizedText];
}

- (void) localizedText {
    _emailTextField.placeholder=NSLocalizedText(@"Email");
    _passwordTextField.placeholder=NSLocalizedText(@"Password");
    _orSeperatorLabel.text=NSLocalizedText(@"or");
    [_loginbutton setTitle:NSLocalizedText(@"Log In") forState:UIControlStateNormal];
    [_forgotPasswordButton setTitle:NSLocalizedText(@"ForgotPassword") forState:UIControlStateNormal];
    [_forgotPasswordButton sizeToFit];
    _forgotPasswordButton.frame=CGRectMake(([[UIScreen mainScreen] bounds].origin.x+[[UIScreen mainScreen] bounds].size.width/2)-(_forgotPasswordButton.frame.size.width/2), _loginbutton.frame.origin.y+_loginbutton.frame.size.height+8, _forgotPasswordButton.frame.size.width, 18);
    [_forgotPasswordButton setBottomBorder:_forgotPasswordButton color:[UIColor blackColor]];
    [_skipButton setTitle:NSLocalizedText(@"Skip") forState:UIControlStateNormal];
}

- (void)setAttributString {
    NSString *str=NSLocalizedText(@"loginNewUserText");
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:str];
    NSRange registerTextRange = [str rangeOfString:NSLocalizedText(@"Register")];
    [string setAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName: [UIFont montserratLightWithSize:13]} range:registerTextRange];
    _registerLabel.attributedText=string;
    
    if ([ConstantCode checkDeviceType] == Device5s) {
        UILabel *templabel=[[UILabel alloc] initWithFrame:CGRectMake(188, 21, 50, 1)];
        templabel.backgroundColor=[UIColor blackColor];
        [_registerLabel addSubview:templabel];
    }
    else if ([ConstantCode checkDeviceType] == Device6) {
        UILabel *templabel=[[UILabel alloc] initWithFrame:CGRectMake(190, 29, 50, 1)];
        templabel.backgroundColor=[UIColor blackColor];
        [_registerLabel addSubview:templabel];
    }
    else {
        UILabel *templabel=[[UILabel alloc] initWithFrame:CGRectMake(186.5, 28, 50, 1)];
        templabel.backgroundColor=[UIColor blackColor];
        [_registerLabel addSubview:templabel];
    }
    _registerLabel.attributedText=string;
    //Add tap gesture at label
    _registerLabel.userInteractionEnabled = YES;
    [_registerLabel addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnLabel:)]];
}

- (void)customizedTextField {
    //Add textfield to keyboard controls array
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:@[_emailTextField, _passwordTextField]]];
    [_keyboardControls setDelegate:self];
    //Add text field border and padding
    [_emailTextField setTextBorder:_emailTextField color:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0]];
    [_passwordTextField setTextBorder:_passwordTextField color:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0]];
    [_emailTextField addTextFieldLeftRightPadding:_emailTextField];
    [_passwordTextField addTextFieldLeftRightPadding:_passwordTextField];
    _forgotPasswordButton.translatesAutoresizingMaskIntoConstraints=YES;
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
    //Set condition according to check if current selected textfield is behind keyboard
    if (loginBackViewY+currentSelectedTextField.frame.origin.y+currentSelectedTextField.frame.size.height<([UIScreen mainScreen].bounds.size.height)-[aValue CGRectValue].size.height) {
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else {
        [_scrollView setContentOffset:CGPointMake(0, ((loginBackViewY+currentSelectedTextField.frame.origin.y+currentSelectedTextField.frame.size.height)- ([UIScreen mainScreen].bounds.size.height-[aValue CGRectValue].size.height))+10) animated:NO];
    }
    //Change content size of scroll view if current selected textfield is behind keyboard
    if ([aValue CGRectValue].size.height-([UIScreen mainScreen].bounds.size.height-(loginBackViewY+_passwordTextField.frame.origin.y+_passwordTextField.frame.size.height))>0) {
        
        _scrollView.contentSize = CGSizeMake(0,[UIScreen mainScreen].bounds.size.height+([aValue CGRectValue].size.height-([UIScreen mainScreen].bounds.size.height-(loginBackViewY+_passwordTextField.frame.origin.y+_passwordTextField.frame.size.height))) + 150);
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    _scrollView.contentSize = CGSizeMake(0,_mainView.frame.size.height);
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)login:(id)sender {
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:false];
    [self.keyboardControls.activeField resignFirstResponder];
    //Perform login validations
    if([self performValidationsForLogin]) {
        [myDelegate showIndicator];
        isSocialLogin=0;
        [self performSelector:@selector(userLogin) withObject:nil afterDelay:.1];
    }
}

- (IBAction)forgotPassword:(UIButton *)sender {
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:false];
    //Screen navigation through seague
}

- (IBAction)skipAndContinue:(UIButton *)sender {
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:false];
    [self.keyboardControls.activeField resignFirstResponder];
    [myDelegate showIndicator];
    [self performSelector:@selector(userLoginAsGuest) withObject:nil afterDelay:.1];
}

//Privacy policy, terms & condition and login tap gesture handler
- (void)handleTapOnLabel:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:_registerLabel];
    CGPoint position = CGPointMake(location.x, location.y);
    
    if ([ConstantCode checkDeviceType] == Device5s) {
        if (position.y>6.5 && position.y<22.0 && position.x>184.0 && position.x<245.0) {
            [self signUp];
        }
    }
    else if ([ConstantCode checkDeviceType] == Device6) {
        if (position.y>16 && position.y<32.0 && position.x>188.0 && position.x<245.0) {
            [self signUp];
        }
    }
    else {
        if (position.y>12.0 && position.y<30.0 && position.x>184.0 && position.x<245.0) {
            [self signUp];
        }
    }
    DLog(@"%f, %f", position.x, position.y);
}

- (void)signUp {
    DLog("signUp");
    //StoryBoard navigation
    UIViewController *obj = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SignUpViewController"];
    [self.navigationController pushViewController:obj animated:true];
}
#pragma mark - end

#pragma mark - Login validation
- (BOOL)performValidationsForLogin {
    if ([_emailTextField isEmpty] || [_passwordTextField isEmpty] ) {
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
#pragma mark - end

#pragma mark - Webservice
//User login webservice called
- (void)userLogin {
    LoginModel *userLogin = [LoginModel sharedUser];
    userLogin.email = _emailTextField.text;
    userLogin.password = _passwordTextField.text;
    userLogin.isSocialLogin=[NSNumber numberWithInt:isSocialLogin];
    userLogin.socialUserId=socialLoginID;
    [userLogin loginUserOnSuccess:^(LoginModel *userData) {
        [myDelegate stopIndicator];
        //Navigate user to dashboard
        [self navigateToDashboard];
    } onfailure:^(NSError *error) {
        
    }];
}

- (void)userLoginAsGuest {
    LoginModel *userLogin = [LoginModel sharedUser];
    [userLogin loginGuestUserOnSuccess:^(LoginModel *userData) {
        [myDelegate stopIndicator];
        UIViewController * objReveal = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
        [myDelegate.window setRootViewController:objReveal];
        [myDelegate.window setBackgroundColor:[UIColor whiteColor]];
        [myDelegate.window makeKeyAndVisible];
    } onfailure:^(NSError *error) {
        
    }];
}
#pragma mark - end

#pragma mark - Navigate to dashboard
- (void)navigateToDashboard {
    //StoryBoard navigation
    UIViewController *obj = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EnableNotificationViewController"];
    [self.navigationController pushViewController:obj animated:true];
}
#pragma mark - end

#pragma mark - Social login xib delegate method
- (void)socialLoginResponse:(ConstantType)option result:(NSDictionary *)result {
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:false];
    [_keyboardControls.activeField resignFirstResponder];
    if (option==FacebookLogin || option==GoogleLogin || option==WeiboLogin) {
        isSocialLogin=1;
        socialLoginID=[result objectForKey:@"id"];
        _emailTextField.text=[result objectForKey:@"email"];
        if (![_emailTextField isEmpty]) {
            [myDelegate showIndicator];
            [self performSelector:@selector(userLogin) withObject:nil afterDelay:.1];
        }
    }
    else {
        [self.view makeToast:NSLocalizedText(@"featureNotAvailable")];
    }
}
#pragma mark - end
@end
