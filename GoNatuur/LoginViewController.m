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

@interface LoginViewController ()<UIGestureRecognizerDelegate, SocialLoginDelegate, BSKeyboardControlsDelegate> {
    UITextField *currentSelectedTextField;
    float loginBackViewY;
    int isSocialLogin;
    float mainViewHeight;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIView *loginBackView;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UILabel *registerLabel;
@property (strong, nonatomic) BSKeyboardControls *keyboardControls;
@end

@implementation LoginViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self authenticationToken];
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
    obj.fbText=@"Log in with Facebook";
    obj.weChatText=@"Log in with WeChat account";
    obj.wieboText=@"Log in with Wiebo";
    obj.googlPlusText=@"Log in with google plus";
    obj.delegate=self;
    [self addChildViewController:obj];
    [self.mainView addSubview:obj.view];
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
    self.loginBackView.translatesAutoresizingMaskIntoConstraints=true;
    self.loginBackView.frame=CGRectMake(13, loginBackViewY, [[UIScreen mainScreen] bounds].size.width-26, 500);
    self.mainView.translatesAutoresizingMaskIntoConstraints=true;
    self.mainView.frame=CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, mainViewHeight);
    self.scrollView.contentSize = CGSizeMake(0,self.mainView.frame.size.height);
    //Set privacy policy attributed text
    [self setAttributString];
    [self customizedTextField];
}

- (void)setAttributString {
    NSString *str=NSLocalizedText(@"loginNewUserText");
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:str];
    NSRange registerTextRange = [str rangeOfString:@"Register"];
    [string setAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName: [UIFont montserratLightWithSize:13], NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:registerTextRange];
    self.registerLabel.attributedText=string;
    //Add tap gesture at label
    self.registerLabel.userInteractionEnabled = YES;
    [self.registerLabel addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnLabel:)]];
}

- (void)customizedTextField {
    //Add textfield to keyboard controls array
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:@[self.emailTextField, self.passwordTextField]]];
    [self.keyboardControls setDelegate:self];
    //Add text field border and padding
    [self.emailTextField setTextBorder:self.emailTextField color:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0]];
    [self.passwordTextField setTextBorder:self.passwordTextField color:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0]];
    [self.emailTextField addTextFieldLeftRightPadding:self.emailTextField];
    [self.passwordTextField addTextFieldLeftRightPadding:self.passwordTextField];
}
#pragma mark - end

#pragma mark - Keyboard control delegate
- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction {
    UIView *view;
    view = field.superview.superview.superview;
}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls {
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [keyboardControls.activeField resignFirstResponder];
}
#pragma mark - end

#pragma mark - Textfield delegates
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.keyboardControls setActiveField:textField];
    currentSelectedTextField=textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    //Set field position after show keyboard
    NSDictionary* info = [notification userInfo];
    NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    //Set condition according to check if current selected textfield is behind keyboard
    if (loginBackViewY+currentSelectedTextField.frame.origin.y+currentSelectedTextField.frame.size.height<([UIScreen mainScreen].bounds.size.height)-[aValue CGRectValue].size.height) {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else {
        [self.scrollView setContentOffset:CGPointMake(0, ((loginBackViewY+currentSelectedTextField.frame.origin.y+currentSelectedTextField.frame.size.height)- ([UIScreen mainScreen].bounds.size.height-[aValue CGRectValue].size.height))+10) animated:NO];
    }
    //Change content size of scroll view if current selected textfield is behind keyboard
    if ([aValue CGRectValue].size.height-([UIScreen mainScreen].bounds.size.height-(loginBackViewY+self.passwordTextField.frame.origin.y+self.passwordTextField.frame.size.height))>0) {
        
        self.scrollView.contentSize = CGSizeMake(0,[UIScreen mainScreen].bounds.size.height+([aValue CGRectValue].size.height-([UIScreen mainScreen].bounds.size.height-(loginBackViewY+self.passwordTextField.frame.origin.y+self.passwordTextField.frame.size.height))) + 150);
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.scrollView.contentSize = CGSizeMake(0,self.mainView.frame.size.height);
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)login:(id)sender {
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:false];
    [self.keyboardControls.activeField resignFirstResponder];
    //Perform signUp validations
    if([self performValidationsForLogin]) {
        [myDelegate showIndicator];
        isSocialLogin=0;
        [self performSelector:@selector(userLogin) withObject:nil afterDelay:.1];
    }
}

- (IBAction)forgotPassword:(UIButton *)sender {
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:false];
}

- (IBAction)skipAndContinue:(UIButton *)sender {
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:false];
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:false];
    [self.keyboardControls.activeField resignFirstResponder];
    [myDelegate showIndicator];
    [self performSelector:@selector(userLoginAsGuest) withObject:nil afterDelay:.1];
}

//Privacy policy, terms & condition and login tap gesture handler
- (void)handleTapOnLabel:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:self.registerLabel];
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

#pragma mark - SignUp validation
- (BOOL)performValidationsForLogin {
    if ([self.emailTextField isEmpty] || [self.passwordTextField isEmpty] ) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"emptyFieldMessage") closeButtonTitle:NSLocalizedText(@"alertOk") duration:0.0f];
        return NO;
    }
    else if (![self.emailTextField isValidEmail]) {
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
//Community code webservice called
- (void)authenticationToken {
//    [myDelegate showIndicator];
    LoginModel *authToken = [LoginModel sharedUser];
    authToken.username=@"";
    authToken.password=@"";
    [authToken accessToken:^(LoginModel *userData) {
//        [self userLogin];
    } onfailure:^(NSError *error) {
        
    }];
}

//User login webservice called
- (void)userLogin {
    LoginModel *userLogin = [LoginModel sharedUser];
    userLogin.email = self.emailTextField.text;
    userLogin.password = self.passwordTextField.text;
    userLogin.isSocialLogin=[NSNumber numberWithInt:isSocialLogin];
    [userLogin loginUserOnSuccess:^(LoginModel *userData) {
        if (nil==[UserDefaultManager getValue:@"deviceToken"]||NULL==[UserDefaultManager getValue:@"deviceToken"]) {
            [myDelegate stopIndicator];
            //Navigate user to dashboard
            [self navigateToDashboard];
        }
        else{
            [self saveDeviceToken];
        }

    } onfailure:^(NSError *error) {
        
    }];
}

//Save device token for push notifications
- (void)saveDeviceToken {
    LoginModel *saveDeviceToken = [LoginModel sharedUser];
    [saveDeviceToken saveDeviceToken:^(LoginModel *deviceToken) {
        [myDelegate stopIndicator];
        [self navigateToDashboard];
    } onfailure:^(NSError *error) {
        
    }];
}

- (void)userLoginAsGuest {
    LoginModel *userLogin = [LoginModel sharedUser];
    [userLogin loginGuestUserOnSuccess:^(LoginModel *userData) {
        [myDelegate stopIndicator];
        // Navigate user to dashboard
        [self navigateToDashboard];
    } onfailure:^(NSError *error) {
        
    }];
}
#pragma mark - end

#pragma mark - Navigate to dashboard
- (void)navigateToDashboard {
    UIViewController * objReveal = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
    [myDelegate.window setRootViewController:objReveal];
    [myDelegate.window setBackgroundColor:[UIColor whiteColor]];
    [myDelegate.window makeKeyAndVisible];
}
#pragma mark - end

#pragma mark - Social login xib delegate method
- (void)socialLoginResponse:(ConstantType)option result:(NSDictionary *)result {
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:false];
    [self.keyboardControls.activeField resignFirstResponder];
    isSocialLogin=1;
    self.emailTextField.text=[result objectForKey:@"email"];
    [myDelegate showIndicator];
    [self performSelector:@selector(userLogin) withObject:nil afterDelay:.1];
}
#pragma mark - end
@end
