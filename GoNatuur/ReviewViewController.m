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

@interface ReviewViewController ()<EDStarRatingProtocol,BSKeyboardControlsDelegate> {
@private
    NSString *starRatingValue;
    NSMutableArray *ratingOptionArray;
}

@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *reviewTextView;
@property (weak, nonatomic) IBOutlet EDStarRating *starRatingView;
@property (weak, nonatomic) IBOutlet UIButton *submitReviewButton;
@property (strong, nonatomic) BSKeyboardControls *keyboardControls;
@end

@implementation ReviewViewController
@synthesize selectedProductId;

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
    [_shadowView addShadow:_shadowView color:[UIColor blackColor]];
    [_submitReviewButton setCornerRadius:17.0];
    [_submitReviewButton addShadow:_submitReviewButton color:[UIColor blackColor]];
    [_titleTextField setTextBorder:_titleTextField color:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0]];
    [_titleTextField addTextFieldLeftRightPadding:_titleTextField];
    [_reviewTextView setTextViewBorder:_reviewTextView color:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0]];
    [_reviewTextView setPlaceholder:NSLocalizedText(@"textViewPlaceholder")];    _reviewTextView.textContainer.lineFragmentPadding = 10;
    [self addstarRating];
}
#pragma mark - end

#pragma mark - Add rating methods
- (void)addstarRating {
    _starRatingView.starImage = [UIImage imageNamed:@"star-unselected"];
    _starRatingView.starHighlightedImage = [UIImage imageNamed:@"star"];
    _starRatingView.maxRating = 5.0;
    _starRatingView.delegate = self;
    _starRatingView.horizontalMargin = 5;
    _starRatingView.editable=YES;
    _starRatingView.rating= 0;
    _starRatingView.displayMode=EDStarRatingDisplayHalf;
    [self starsSelectionChanged:_starRatingView rating:0];
}

- (void)starsSelectionChanged:(EDStarRating *)control rating:(float)rating {
    starRatingValue = [NSString stringWithFormat:@"%.1f", rating];
}
#pragma mark - end

#pragma mark - IBAction
- (IBAction)addReviewButtonAction:(id)sender {
    [myDelegate showIndicator];
    [self performSelector:@selector(addProductReview) withObject:nil afterDelay:.1];
}
#pragma mark - end

#pragma mark - Webservice
- (void)addProductReview {
    ReviewDataModel *addReview = [ReviewDataModel sharedUser];
    addReview.productId=selectedProductId;
    addReview.username=@"";
    addReview.reviewTitle=_titleTextField.text;
    addReview.reviewDescription=_reviewTextView.text;
    addReview.ratingId=starRatingValue;
    [addReview addCustomerReview:^(ReviewDataModel *userData)  {
        [myDelegate stopIndicator];
        [self popToReviewList];
        ratingOptionArray=[userData.rationOptionsArray mutableCopy];
    } onfailure:^(NSError *error) {
    }];

}

- (void)popToReviewList {
    [self.navigationController popViewControllerAnimated:YES];
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
