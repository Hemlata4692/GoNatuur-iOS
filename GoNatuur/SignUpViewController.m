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
#import "UIView+RoundedCorner.h"
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
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIImageView *swipeImageView;
@property (strong, nonatomic) IBOutlet UIView *loginBackView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (strong, nonatomic) IBOutlet UILabel *privacyPolicyLoginLabel;

//Declare BSKeyboard variable
@property (strong, nonatomic) BSKeyboardControls *keyboardControls;
@end

@implementation SignUpViewController

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
    obj.view.frame=CGRectMake(60, 259.0+screenHeightScaleFactorDifference-1.0, [[UIScreen mainScreen] bounds].size.width-120, 174);
    obj.delegate=self;
    [self addChildViewController:obj];
    [self.mainView addSubview:obj.view];
    [obj didMoveToParentViewController:self];
}

- (void)initializedView {
    swipeImageArray = @[@"SwipeImage.png", @"SwipeImage.png", @"SwipeImage.png", @"SwipeImage.png"];
    self.pageControl.numberOfPages = [swipeImageArray count];
    pageCounter = currentSelectedImage;
    self.pageControl.currentPage = pageCounter;
    self.swipeImageView.image=[UIImage imageNamed:[swipeImageArray objectAtIndex:pageCounter]];
    self.swipeImageView.userInteractionEnabled = YES;
    
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

    float scaleFactor = 230.0 / ([[UIScreen mainScreen]bounds].size.width-90);
    screenHeightScaleFactorDifference = 230.0-(scaleFactor*230.0);
    self.mainView.translatesAutoresizingMaskIntoConstraints=true;
    self.mainView.frame=CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 256.5+screenHeightScaleFactorDifference+508.0);
    
    //Set privacy policy attributed text
    [self setAttributString];
    [self customizedTextField];
}

- (void)setAttributString {
    NSString *str=privacyPolicyText;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:str];
    
    NSRange termConditionTextRange = [str rangeOfString:@"terms & conditions"];// * Notice that usage of rangeOfString in this case may cause some bugs - I use it here only for demonstration
    [string setAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} range:termConditionTextRange];
    
    NSRange policyTextRange = [str rangeOfString:@"privacy policy"];
    [string setAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} range:policyTextRange];
    
    NSRange logInTextRange = [str rangeOfString:@"Log In"];
    [string setAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName: [UIFont helveticaNeueMediumWithSize:11], NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:logInTextRange];
    self.privacyPolicyLoginLabel.attributedText=string;
    
    //Add tap gesture at UiLabel
    self.privacyPolicyLoginLabel.userInteractionEnabled = YES;
    [self.privacyPolicyLoginLabel addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self
                                             action:@selector(handleTapOnLabel:)]];
}

- (void)customizedTextField {
    //Adding textfield to keyboard controls array
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:@[self.emailTextField, self.passwordTextField, self.confirmPasswordTextField]]];
    [self.keyboardControls setDelegate:self];
    
    [self.emailTextField setTextBorder:self.emailTextField color:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0]];
    [self.passwordTextField setTextBorder:self.passwordTextField color:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0]];
    [self.confirmPasswordTextField setTextBorder:self.confirmPasswordTextField color:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0]];
    
     [self.emailTextField addTextFieldLeftRightPadding:self.emailTextField];
    [self.passwordTextField addTextFieldLeftRightPadding:self.passwordTextField];
    [self.confirmPasswordTextField addTextFieldLeftRightPadding:self.confirmPasswordTextField];
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
    
    float loginBackViewY=screenHeightScaleFactorDifference+256.5;
    //Set condition according to check if current selected textfield is behind keyboard
    if (loginBackViewY+currentSelectedTextField.frame.origin.y+currentSelectedTextField.frame.size.height<([UIScreen mainScreen].bounds.size.height)-[aValue CGRectValue].size.height) {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else {
        [self.scrollView setContentOffset:CGPointMake(0, ((loginBackViewY+currentSelectedTextField.frame.origin.y+currentSelectedTextField.frame.size.height)- ([UIScreen mainScreen].bounds.size.height-[aValue CGRectValue].size.height))+10) animated:NO];
    }
    
    //Change content size of scroll view if current selected textfield is behind keyboard
    if ([aValue CGRectValue].size.height-([UIScreen mainScreen].bounds.size.height-(loginBackViewY+self.confirmPasswordTextField.frame.origin.y+self.confirmPasswordTextField.frame.size.height))>0) {
        
        self.scrollView.contentSize = CGSizeMake(0,[UIScreen mainScreen].bounds.size.height+([aValue CGRectValue].size.height-([UIScreen mainScreen].bounds.size.height-(loginBackViewY+self.confirmPasswordTextField.frame.origin.y+self.confirmPasswordTextField.frame.size.height))) + 150);
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.scrollView.contentSize = CGSizeMake(0,self.mainView.frame.size.height);
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)createAccount:(UIButton *)sender {
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:false];
    [self.keyboardControls.activeField resignFirstResponder];
    
    //Perform signUp validations
    if([self performValidationsForSignUp]) {
        [myDelegate showIndicator];
        [self performSelector:@selector(userSignUp) withObject:nil afterDelay:.1];
    }
}

- (IBAction)skipAndContinue:(UIButton *)sender {
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:false];
    [self.keyboardControls.activeField resignFirstResponder];
    [myDelegate showIndicator];
    [self performSelector:@selector(userLoginAsGuest) withObject:nil afterDelay:.1];
}

//Privacy policy, terms & condition and login tap gesture handler
- (void)handleTapOnLabel:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:self.privacyPolicyLoginLabel];
    CGPoint position = CGPointMake(location.x, location.y);
    
    if ([ConstantCode checkDeviceType] == Device5s) {
        if ((position.y<11.0 && position.x>118.0 && position.x<153.0)||(position.y>12.0 && position.y<22.0 && position.x<40.0)) {
            [self termsNCondition];
        }
        else if (position.y>12.0 && position.y<22.0 && position.x>57.0 && position.x<110.0) {
            [self privacyPolicy];
        }
        else if (position.y>23.0 && position.y<35.0 && position.x>93.0 && position.x<131.0) {
            [self logIn];
        }
    }
    else if ([ConstantCode checkDeviceType] == Device6) {
        if (position.y<11.0 && position.x>117.0 && position.x<189.0) {
            [self termsNCondition];
        }
        else if (position.y>13.0 && position.y<25.0 && position.x<51.0) {
            [self privacyPolicy];
        }
        else if (position.y>12.0 && position.y<25.0 && position.x>170.0 && position.x<208.0) {
            [self logIn];
        }
    }
    else {
        if (position.y>6.0 && position.y<16.0 && position.x>118.0 && position.x<189.0) {
            [self termsNCondition];
        }
        else if ((position.y>6.0 && position.y<16.0 && position.x>206.0 && position.x<237.0)||(position.y>18.0 && position.y<30.0 && position.x>0.0 && position.x<24.0)) {
            [self privacyPolicy];
        }
        else if (position.y>17.0 && position.y<30.0 && position.x>142.0 && position.x<180.0) {
            [self logIn];
        }
    }
    DLog(@"%f, %f", position.x, position.y);
}

//Privacy policy, termCondition and login click action
- (void)privacyPolicy {
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:false];
    DLog("Privacy");
    CMSPageViewController *obj = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CMSPageViewController"];
    obj.isPrivacyPolicy=true;
    [self.navigationController pushViewController:obj animated:true];
}

- (void)termsNCondition {
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:false];
    DLog("termsNCondition");
    CMSPageViewController *obj = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CMSPageViewController"];
    obj.isPrivacyPolicy=false;
    [self.navigationController pushViewController:obj animated:true];
}

- (void)logIn {
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:false];
    [self.navigationController popViewControllerAnimated:true];
    DLog("logIn");
}
#pragma mark - end

#pragma mark - SignUp validation
- (BOOL)performValidationsForSignUp {
    if ([self.emailTextField isEmpty] || [self.passwordTextField isEmpty] || [self.confirmPasswordTextField isEmpty]) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:nil title:alertTitle subTitle:emptyFieldMessage closeButtonTitle:alertOk duration:0.0f];
        return NO;
    }
    else if (![self.emailTextField isValidEmail]) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:nil title:alertTitle subTitle:validEmailMessage closeButtonTitle:alertOk duration:0.0f];
        return NO;
    }
    else if ([self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text]) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:nil title:alertTitle subTitle:passwordMatchMessage closeButtonTitle:alertOk duration:0.0f];
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
        self.pageControl.currentPage = pageCounter;
        self.swipeImageView.image=[UIImage imageNamed:[swipeImageArray objectAtIndex:pageCounter]];
        UIImageView *moveIMageView = self.swipeImageView;
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
        self.pageControl.currentPage = pageCounter;
        self.swipeImageView.image=[UIImage imageNamed:[swipeImageArray objectAtIndex:pageCounter]];
        UIImageView *moveIMageView = self.swipeImageView;
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
}
#pragma mark - end

#pragma mark - Webservice
- (void)userSignUp {}

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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
