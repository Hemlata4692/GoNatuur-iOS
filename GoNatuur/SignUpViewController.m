//
//  SignUpViewController.m
//  GoNatuur
//
//  Created by Ranosys on 04/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "SignUpViewController.h"
#import "SocialLoginViewController.h"
#import "BSKeyboardControls.h"
#import "UITextField+Validations.h"
#import "UITextField+Padding.h"
#import "LoginModel.h"
#import "CMSPageViewController.h"

@interface SignUpViewController ()<UIGestureRecognizerDelegate, SocialLoginDelegate, BSKeyboardControlsDelegate> {
    int pageCounter;
    NSArray *swipeImageArray;
    int currentSelectedImage;
    UITextField *currentSelectedTextField;
    float screenHeightScaleFactorDifference;
    float signUpBackViewY;
    int isSocialLogin;
    NSString *firstName, *lastName;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIImageView *swipeImageView;
@property (strong, nonatomic) IBOutlet UIView *signUpBackView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (strong, nonatomic) IBOutlet UILabel *privacyPolicyLoginLabel;
//Declare BSKeyboard variable
@property (strong, nonatomic) BSKeyboardControls *keyboardControls;
@end

@implementation SignUpViewController
@synthesize scrollView;
@synthesize mainView;
@synthesize swipeImageView;
@synthesize signUpBackView;
@synthesize pageControl;
@synthesize emailTextField;
@synthesize passwordTextField;
@synthesize confirmPasswordTextField;
@synthesize privacyPolicyLoginLabel;
@synthesize keyboardControls;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    obj.view.frame=CGRectMake(13, signUpBackViewY, [[UIScreen mainScreen] bounds].size.width-26, 212);
    obj.fbText=@"Sign up with Facebook";
    obj.weChatText=@"Sign up with WeChat account";
    obj.wieboText=@"Sign up with Wiebo";
    obj.googlPlusText=@"Sign up with google plus";
    obj.delegate=self;
    [self addChildViewController:obj];
    [mainView addSubview:obj.view];
    [obj didMoveToParentViewController:self];
}

- (void)initializedView {
    
    pageControl.transform = CGAffineTransformMakeScale(1.4, 1.4);
    swipeImageArray = @[@"SwipeImage.png", @"SwipeImage.png", @"SwipeImage.png", @"SwipeImage.png"];
    pageControl.numberOfPages = [swipeImageArray count];
    pageCounter = currentSelectedImage;
    pageControl.currentPage = pageCounter;
    swipeImageView.image=[UIImage imageNamed:[swipeImageArray objectAtIndex:pageCounter]];
    swipeImageView.userInteractionEnabled = YES;
    
    //Swipe gesture to swipe images to left
    UISwipeGestureRecognizer *swipeImageLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeIntroImageLeft)];
    swipeImageLeft.delegate=self;
    UISwipeGestureRecognizer *swipeImageRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeIntroImageRight)];
    swipeImageRight.delegate=self;
    
    // Setting the swipe direction.
    [swipeImageLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeImageRight setDirection:UISwipeGestureRecognizerDirectionRight];
    // Adding the swipe gesture on image view
    [[self swipeImageView] addGestureRecognizer:swipeImageLeft];
    [[self swipeImageView] addGestureRecognizer:swipeImageRight];

    float scaleFactor = [[UIScreen mainScreen]bounds].size.height/568.0;
    signUpBackViewY=42+(scaleFactor*128.0)+28;
    mainView.translatesAutoresizingMaskIntoConstraints=true;
    mainView.frame=CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, signUpBackViewY+538.0);
    scrollView.contentSize = CGSizeMake(0,mainView.frame.size.height);
    //Set privacy policy attributed text
    [self setAttributString];
    [self customizedTextField];
}

- (void)setAttributString {
    
    NSString *str=NSLocalizedText(@"privacyPolicyText");
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:str];
    NSRange termConditionTextRange = [str rangeOfString:@"Terms & Conditions"];// * Notice that usage of rangeOfString in this case may cause some bugs - I use it here only for demonstration
    [string setAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName: [UIFont montserratLightWithSize:13], NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:termConditionTextRange];
    NSRange policyTextRange = [str rangeOfString:@"Privacy Policy"];
    [string setAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName: [UIFont montserratLightWithSize:13], NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:policyTextRange];
    NSRange logInTextRange = [str rangeOfString:@"Log In"];
    [string setAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName: [UIFont montserratLightWithSize:13], NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:logInTextRange];
    privacyPolicyLoginLabel.attributedText=string;
    //Add tap gesture at UiLabel
    privacyPolicyLoginLabel.userInteractionEnabled = YES;
    [privacyPolicyLoginLabel addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self
                                             action:@selector(handleTapOnLabel:)]];
}

- (void)customizedTextField {
    //Adding textfield to keyboard controls array
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:@[emailTextField, passwordTextField, confirmPasswordTextField]]];
    [keyboardControls setDelegate:self];
    [emailTextField setTextBorder:emailTextField color:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0]];
    [passwordTextField setTextBorder:passwordTextField color:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0]];
    [confirmPasswordTextField setTextBorder:confirmPasswordTextField color:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0]];
    [emailTextField addTextFieldLeftRightPadding:emailTextField];
    [passwordTextField addTextFieldLeftRightPadding:passwordTextField];
    [confirmPasswordTextField addTextFieldLeftRightPadding:confirmPasswordTextField];
}
#pragma mark - end

#pragma mark - Keyboard control delegate
- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction {
    UIView *view;
    view = field.superview.superview.superview;
}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls {
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [keyboardControls.activeField resignFirstResponder];
}
#pragma mark - end

#pragma mark - Textfield delegates
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [keyboardControls setActiveField:textField];
    currentSelectedTextField=textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    //Set field position after show keyboard
    NSDictionary* info = [notification userInfo];
    NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    //Set condition according to check if current selected textfield is behind keyboard
    if (signUpBackViewY+currentSelectedTextField.frame.origin.y+currentSelectedTextField.frame.size.height<([UIScreen mainScreen].bounds.size.height)-[aValue CGRectValue].size.height) {
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else {
        [scrollView setContentOffset:CGPointMake(0, ((signUpBackViewY+currentSelectedTextField.frame.origin.y+currentSelectedTextField.frame.size.height)- ([UIScreen mainScreen].bounds.size.height-[aValue CGRectValue].size.height))+10) animated:NO];
    }
    
    //Change content size of scroll view if current selected textfield is behind keyboard
    if ([aValue CGRectValue].size.height-([UIScreen mainScreen].bounds.size.height-(signUpBackViewY+confirmPasswordTextField.frame.origin.y+confirmPasswordTextField.frame.size.height))>0) {
        
        scrollView.contentSize = CGSizeMake(0,[UIScreen mainScreen].bounds.size.height+([aValue CGRectValue].size.height-([UIScreen mainScreen].bounds.size.height-(signUpBackViewY+confirmPasswordTextField.frame.origin.y+confirmPasswordTextField.frame.size.height))) + 150);
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    scrollView.contentSize = CGSizeMake(0,mainView.frame.size.height);
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)createAccount:(UIButton *)sender {
    [scrollView setContentOffset:CGPointMake(0, 0) animated:false];
    [keyboardControls.activeField resignFirstResponder];
    
    //Perform signUp validations
    if([self performValidationsForSignUp]) {
        isSocialLogin=0;
        firstName=@"";
        lastName=@"";
        [myDelegate showIndicator];
        [self performSelector:@selector(userSignUp) withObject:nil afterDelay:.1];
    }
}

- (IBAction)skipAndContinue:(UIButton *)sender {
    [scrollView setContentOffset:CGPointMake(0, 0) animated:false];
    [keyboardControls.activeField resignFirstResponder];
    [myDelegate showIndicator];
    [self performSelector:@selector(userLoginAsGuest) withObject:nil afterDelay:.1];
}

//Privacy policy, terms & condition and login tap gesture handler
- (void)handleTapOnLabel:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:privacyPolicyLoginLabel];
    CGPoint position = CGPointMake(location.x, location.y);
    
    if ([ConstantCode checkDeviceType] == Device5s) {
        if ((position.y<16.0 && position.x>199.0 && position.x<255.0)||(position.y>17.0 && position.y<31.0 && position.x<95.0)) {
            [self termsNCondition];
        }
        else if (position.y>16.0 && position.y<32.0 && position.x>118.0 && position.x<214.0) {
            [self privacyPolicy];
        }
        else if (position.y>32.0 && position.y<47.0 && position.x>172.0 && position.x<217.0) {
            [self logIn];
        }
    }
    else if ([ConstantCode checkDeviceType] == Device6) {
        if (position.y<15.0 && position.x>190.0 && position.x<318.0) {
            [self termsNCondition];
        }
        else if (position.y>16.0 && position.y<31.0 && position.x>36.0 && position.x<127.0) {
            [self privacyPolicy];
        }
        else if (position.y>33.0 && position.y<48.0 && position.x>121.0 && position.x<170.0) {
            [self logIn];
        }
    }
    else {
        if ((position.y<23.0 && position.x>195.0 && position.x<326.0)) {
            [self termsNCondition];
        }
        else if (position.y>24.0 && position.y<40.0 && position.x<97.0) {
            [self privacyPolicy];
        }
        else if (position.y>23.0 && position.y<40.0 && position.x>282.0 && position.x<330.0) {
            [self logIn];
        }
    }
    DLog(@"%f, %f", position.x, position.y);
}

//Privacy policy, termCondition and login click action
- (void)privacyPolicy {
    [scrollView setContentOffset:CGPointMake(0, 0) animated:false];
    DLog("Privacy");
    CMSPageViewController *obj = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CMSPageViewController"];
    obj.isPrivacyPolicy=true;
    [self.navigationController pushViewController:obj animated:true];
}

- (void)termsNCondition {
    [scrollView setContentOffset:CGPointMake(0, 0) animated:false];
    DLog("termsNCondition");
    CMSPageViewController *obj = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CMSPageViewController"];
    obj.isPrivacyPolicy=false;
    [self.navigationController pushViewController:obj animated:true];
}

- (void)logIn {
    [scrollView setContentOffset:CGPointMake(0, 0) animated:false];
    [self.navigationController popViewControllerAnimated:true];
    DLog("logIn");
}
#pragma mark - end

#pragma mark - SignUp validation
- (BOOL)performValidationsForSignUp {
    if ([emailTextField isEmpty] || [passwordTextField isEmpty] || [confirmPasswordTextField isEmpty]) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        
        [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"emptyFieldMessage") closeButtonTitle:NSLocalizedText(@"alertOk") duration:0.0f];
        return NO;
    }
    else if (![emailTextField isValidEmail]) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"validEmailMessage") closeButtonTitle:NSLocalizedText(@"alertOk") duration:0.0f];
        return NO;
    }
    else if (passwordTextField.text.length<8) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"passwordMinimumCharater") closeButtonTitle:NSLocalizedText(@"alertOk") duration:0.0f];
        return NO;
    }
    else if (![passwordTextField isValidPassword]) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"validPassword") closeButtonTitle:NSLocalizedText(@"alertOk") duration:0.0f];
        return NO;
    }
    else if (![passwordTextField.text isEqualToString:confirmPasswordTextField.text]) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"passwordMatchMessage") closeButtonTitle:NSLocalizedText(@"alertOk") duration:0.0f];
        return NO;
    }
    else {
        return YES;
    }
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

//Swipe images in left direction
- (void)swipeIntroImageLeft {
    pageCounter++;
    if (pageCounter < swipeImageArray.count) {
        pageControl.currentPage = pageCounter;
        swipeImageView.image=[UIImage imageNamed:[swipeImageArray objectAtIndex:pageCounter]];
        UIImageView *moveIMageView = swipeImageView;
        [self addLeftAnimationPresentToView:moveIMageView];
    }
    else {
        pageCounter = (int)swipeImageArray.count - 1;
    }
}

//Swipe images in right direction
- (void)swipeIntroImageRight {
    pageCounter--;
    if (pageCounter>=0) {
        pageControl.currentPage = pageCounter;
        swipeImageView.image=[UIImage imageNamed:[swipeImageArray objectAtIndex:pageCounter]];
        UIImageView *moveIMageView = swipeImageView;
        [self addRightAnimationPresentToView:moveIMageView];
    }
    else {
        pageCounter = 0;
    }
}
#pragma mark - end

#pragma mark - Social login xib delegate method
- (void)socialLoginResponse:(ConstantType)option result:(NSDictionary *)result {
    DLog(@"email:%@  userId:%@", [result objectForKey:@"email"],[result objectForKey:@"id"]);
    isSocialLogin=1;
    emailTextField.text=[result objectForKey:@"email"];
    firstName=[result objectForKey:@"firstName"];
    lastName=[result objectForKey:@"lastName"];
    [myDelegate showIndicator];
    [self performSelector:@selector(userSignUp) withObject:nil afterDelay:.1];
}
#pragma mark - end

#pragma mark - Webservice
- (void)userSignUp {
    LoginModel *userLogin = [LoginModel sharedUser];
    userLogin.email = emailTextField.text;
    userLogin.password = passwordTextField.text;
    userLogin.firstName=firstName;
    userLogin.lastName=lastName;
//    userLogin.isSocialLogin=[NSNumber numberWithInt:isSocialLogin];
    [userLogin signUpUserService:^(LoginModel *userData) {
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
        //Navigate user to dashboard
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

@end
