//
//  SignUpViewController.m
//  GoNatuur
//
//  Created by Ranosys on 04/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "SignUpViewController.h"
#import "SocialLoginViewController.h"

@interface SignUpViewController ()<UIGestureRecognizerDelegate> {
    
    int pageCounter;
    NSArray *swipeImageArray;
    int currentSelectedImage;
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
@property (strong, nonatomic) IBOutlet UIView *socialLoginButtonBackView;
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
    [self integrateSocialLoginView];
    [self initializedView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - View initialization
- (void)integrateSocialLoginView {

    float scaleFactor = 230.0 / ([[UIScreen mainScreen]bounds].size.width-90);
    float difference = 230.0-(scaleFactor*230.0);
    SocialLoginViewController *obj = [[SocialLoginViewController alloc] initWithNibName:@"SocialLoginViewController" bundle:nil];
    obj.view.translatesAutoresizingMaskIntoConstraints=YES;
    obj.view.frame=CGRectMake(60, 259.0+difference-1.0, [[UIScreen mainScreen] bounds].size.width-120, 174);
//    obj.delegate=self;
    [self addChildViewController:obj];
    [self.mainView addSubview:obj.view];
    [obj didMoveToParentViewController:self];
}

- (void)initializedView {
    swipeImageArray=@[@"SwipeImage.png",@"SwipeImage.png",@"SwipeImage.png",@"SwipeImage.png"];
    self.pageControl.numberOfPages = [swipeImageArray count];
    pageCounter = currentSelectedImage;
    self.pageControl.currentPage = pageCounter;
//    self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
//    self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:178.0/255.0 green:198.0/255.0 blue:58.0/255.0 alpha:1.0];
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
    float difference = 230.0-(scaleFactor*230.0);
    self.mainView.translatesAutoresizingMaskIntoConstraints=true;
    self.mainView.frame=CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 688+difference+10);
//    self.scrollView.contentSize = CGSizeMake(0.0,1000);
    
    [self setAttributString];
}

- (void)setAttributString {

    NSString *str=@"By signing up, you agree to our terms & conditions and privacy policy. If you already have an account, Log In here";
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:str];
    
    NSRange redTextRange = [str rangeOfString:@"terms & conditions"];// * Notice that usage of rangeOfString in this case may cause some bugs - I use it here only for demonstration
    [string setAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} range:redTextRange];
    NSRange redTextRange1 = [str rangeOfString:@"privacy policy"];
    [string setAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} range:redTextRange1];
    
    NSRange redTextRange2 = [str rangeOfString:@"Log In"];
    [string setAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:11], NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:redTextRange2];
    self.privacyPolicyLoginLabel.attributedText=string;
}

#pragma mark - IBActions
- (IBAction)createAccount:(UIButton *)sender {
    
}

- (IBAction)skipAndContinue:(UIButton *)sender {
    
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
