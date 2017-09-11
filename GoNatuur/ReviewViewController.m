//
//  ReviewViewController.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 19/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "ReviewViewController.h"
#import "EDStarRating.h"
#import "UITextField+Padding.h"
#import "UIPlaceHolderTextView.h"
#import "BSKeyboardControls.h"
#import "ReviewService.h"
#import "ReviewDataModel.h"
#import "ReviewListingViewController.h"
#import "UITextField+Validations.h"

@interface ReviewViewController ()<EDStarRatingProtocol,BSKeyboardControlsDelegate> {
@private
    NSString *starRatingValue;
    NSMutableArray *ratingOptionArray;
}

@property (strong, nonatomic) IBOutlet UILabel *reviewScreenTitle;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *reviewTextView;
@property (weak, nonatomic) IBOutlet EDStarRating *starRatingView;
@property (weak, nonatomic) IBOutlet UIButton *submitReviewButton;
@property (strong, nonatomic) BSKeyboardControls *keyboardControls;
@property (weak, nonatomic) IBOutlet UILabel *rateProductLabel;
@end

@implementation ReviewViewController
@synthesize selectedProductId;
@synthesize reviewData;
@synthesize isEditMode;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ratingOptionArray=[[NSMutableArray alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.title=NSLocalizedText(@"Review");
    self.navigationController.navigationBarHidden=false;
    [self addLeftBarButtonWithImage:true];
    [self viewCustomisation];
}

- (void)viewCustomisation {
    //Add textfield to keyboard controls array
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:@[_titleTextField, _reviewTextView]]];
    [_keyboardControls setDelegate:self];
    //customisation of objects
    [_submitReviewButton setCornerRadius:17.0];
    [_submitReviewButton addShadow:_submitReviewButton color:[UIColor blackColor]];
    [_titleTextField setTextBorder:_titleTextField color:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0]];
    [_titleTextField addTextFieldLeftRightPadding:_titleTextField];
    [_reviewTextView setTextViewBorder:_reviewTextView color:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0]];
    [_reviewTextView setPlaceholder:NSLocalizedText(@"textViewPlaceholder")];
    _reviewTextView.textContainer.lineFragmentPadding = 10;
    _titleTextField.placeholder=NSLocalizedText(@"title");
    _rateProductLabel.text=NSLocalizedText(@"rateProductLabelText");
    if ([isEditMode isEqualToString:@"1"]) {
        [_submitReviewButton setTitle:NSLocalizedText(@"UPDATE REVIEW") forState:UIControlStateNormal];
        _reviewScreenTitle.text=NSLocalizedText(@"Update Your Review");
         [self displayData];
    }
    else {
        [_submitReviewButton setTitle:NSLocalizedText(@"SUBMIT REVIEW") forState:UIControlStateNormal];
        _reviewScreenTitle.text=NSLocalizedText(@"Write New Review");
        [self addstarRating:0];
    }
}
#pragma mark - end

#pragma mark - Add rating methods
- (void)addstarRating:(NSString *)rating {
    _starRatingView.starImage = [UIImage imageNamed:@"star-unselected"];
    _starRatingView.starHighlightedImage = [UIImage imageNamed:@"star"];
    _starRatingView.maxRating = 5.0;
    _starRatingView.delegate = self;
    _starRatingView.horizontalMargin = 5;
    _starRatingView.editable=YES;
    _starRatingView.rating= [rating floatValue];
    _starRatingView.displayMode=EDStarRatingDisplayFull;
    if ([isEditMode isEqualToString:@"1"]) {
       [self starsSelectionChanged:_starRatingView rating:[starRatingValue floatValue]];
    }
    else {
        [self starsSelectionChanged:_starRatingView rating:0];
    }
}

- (void)starsSelectionChanged:(EDStarRating *)control rating:(float)rating {
    starRatingValue = [NSString stringWithFormat:@"%.1f", rating];
}
#pragma mark - end

#pragma mark - IBAction
- (IBAction)addReviewButtonAction:(id)sender {
    [self.view endEditing:true];
    if([self performValidations]) {
        [myDelegate showIndicator];
        [self performSelector:@selector(addProductReview) withObject:nil afterDelay:.1];
    }
}
#pragma mark - end

#pragma mark - Review validation
- (BOOL)performValidations {
    if ([starRatingValue isEqualToString:@"0.0"]) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"RateProduct") closeButtonTitle:NSLocalizedText(@"alertOk") duration:0.0f];
        return NO;
    }
    else {
        return YES;
    }
}
#pragma mark - end

#pragma mark - Webservice
- (void)addProductReview {
    ReviewDataModel *addReview = [ReviewDataModel sharedUser];
    addReview.productId=selectedProductId;
    addReview.username=[UserDefaultManager getValue:@"firstname"];
    addReview.reviewTitle=_titleTextField.text;
    addReview.reviewDescription=_reviewTextView.text;
    addReview.ratingId=starRatingValue;
    if([isEditMode isEqualToString:@"1"]) {
        addReview.reviewId=reviewData.reviewId;
    }
    else {
        addReview.reviewId=@"0";
    }
    [addReview addCustomerReview:^(ReviewDataModel *userData)  {
        [myDelegate stopIndicator];
        [self popToReviewList];
    } onfailure:^(NSError *error) {
    }];
}

- (void)popToReviewList {
    _reviewListObj.reviewAdded=@"1";
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)displayData {
    _titleTextField.text=reviewData.reviewTitle;
    _reviewTextView.text=reviewData.reviewDescription;
    starRatingValue=reviewData.ratingId;
   [self addstarRating:reviewData.ratingId];
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

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [_keyboardControls setActiveField:textField];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [_keyboardControls setActiveField:textView];
}
#pragma mark - end
@end
