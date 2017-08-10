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
    obj.view.frame=CGRectMake(60, loginBackViewY, [[UIScreen mainScreen] bounds].size.width-120, 174);
    obj.delegate=self;
    [self addChildViewController:obj];
    [self.mainView addSubview:obj.view];
    [obj didMoveToParentViewController:self];
}

- (void)initializedView {
    isSocialLogin=0;
    loginBackViewY=(([[UIScreen mainScreen] bounds].size.height/2.0)-(417.0/2.0))+65.0;
    self.mainView.translatesAutoresizingMaskIntoConstraints=true;
    self.mainView.frame=CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height);
    //Set privacy policy attributed text
    [self setAttributString];
    [self customizedTextField];
}

- (void)setAttributString {
    NSString *str=@"If you are a new uesr, you can Register an account with us and start shopping with GoPurpose.";
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:str];
    NSRange registerTextRange = [str rangeOfString:@"Register"];
    [string setAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName: [UIFont helveticaNeueMediumWithSize:11], NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:registerTextRange];
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
    loginBackViewY=(([[UIScreen mainScreen] bounds].size.height/2.0)-(417.0/2.0))+65.0;
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
    UIViewController * objReveal = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
    [myDelegate.window setRootViewController:objReveal];
    [myDelegate.window setBackgroundColor:[UIColor whiteColor]];
    [myDelegate.window makeKeyAndVisible];
    //Perform signUp validations
//    if([self performValidationsForLogin]) {
//        isSocialLogin=0;
////        [myDelegate showIndicator];
////        [self performSelector:@selector(userLogin) withObject:nil afterDelay:.1];
//    }
}

- (IBAction)forgotPassword:(UIButton *)sender {
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:false];
}

- (IBAction)skipAndContinue:(UIButton *)sender {
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:false];
}

//Privacy policy, terms & condition and login tap gesture handler
- (void)handleTapOnLabel:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:self.registerLabel];
    CGPoint position = CGPointMake(location.x, location.y);
    
    if ([ConstantCode checkDeviceType] == Device5s) {
        if (position.y<15.0 && position.x>115.0 && position.x<158.0) {
            [self signUp];
        }
    }
    else if ([ConstantCode checkDeviceType] == Device6) {
        if (position.y<12.0 && position.x>123.0 && position.x<194.0) {
            [self signUp];
        }
    }
    else {
        if (position.y>4.0 && position.y<16.0 && position.x>128.0 && position.x<198.0) {
            [self signUp];
        }
    }
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
        [alert showWarning:nil title:@"Alert" subTitle:@"Please fill in all the required fields." closeButtonTitle:@"Ok" duration:0.0f];
        return NO;
    }
    else if (![self.emailTextField isValidEmail]) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:nil title:@"Alert" subTitle:@"Please enter a valid email address." closeButtonTitle:@"Ok" duration:0.0f];
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
    userLogin.countryCode=@"";
    [userLogin loginUserOnSuccess:^(LoginModel *userData) {
        if (nil==[UserDefaultManager getValue:@"deviceToken"]||NULL==[UserDefaultManager getValue:@"deviceToken"]) {
            [myDelegate stopIndicator];
        }
        else{
            [self saveDeviceToken];
        }
//        Navigate user to dashboard
    } onfailure:^(NSError *error) {
        
    }];
}

//Save device token for push notifications
- (void)saveDeviceToken {
    LoginModel *saveDeviceToken = [LoginModel sharedUser];
    [saveDeviceToken saveDeviceToken:^(LoginModel *deviceToken) {
        [myDelegate stopIndicator];
    } onfailure:^(NSError *error) {
        
    }];
}
#pragma mark - end

#pragma mark - Social login xib delegate method
- (void)socialLoginResponse:(ConstantType)option result:(NSDictionary *)result {
    isSocialLogin=1;
    DLog(@"email:%@  userId:%@", [result objectForKey:@"email"],[result objectForKey:@"id"]);
}
#pragma mark - end
@end
