//
//  SubscriptionViewController.m
//  GoNatuur
//
//  Created by Monika on 23/11/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "SubscriptionViewController.h"
#import "GoNatuurPickerView.h"
#import "BSKeyboardControls.h"
#import "UITextField+Padding.h"
#import <MessageUI/MessageUI.h>
#import "UITextField+Validations.h"

@interface SubscriptionViewController ()<BSKeyboardControlsDelegate,GoNatuurPickerViewDelegate,MFMailComposeViewControllerDelegate>
{
@private
    UITextField *currentSelectedTextField;
    GoNatuurPickerView *gNPickerViewObj;
    int selectedIndex;
    BOOL isPickerEnable;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *startDateField;
@property (weak, nonatomic) IBOutlet UITextField *maxBillingField;
@property (weak, nonatomic) IBOutlet UITextField *billingFrequencyField;
@property (weak, nonatomic) IBOutlet UITextField *periodUnitField;
@property (weak, nonatomic) IBOutlet UILabel *subscriptionReminderLabel;
@property (weak, nonatomic) IBOutlet UILabel *mailInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) UIDatePicker *datepicker;
@property (weak, nonatomic) IBOutlet UIView *containerView;

//Declare BSKeyboard variable
@property (strong, nonatomic) BSKeyboardControls *keyboardControls;
@end

@implementation SubscriptionViewController
@synthesize datepicker;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    //Bring front view picker view
    [self.view bringSubviewToFront:gNPickerViewObj.goNatuurPickerViewObj];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.title=NSLocalizedText(@"subscriptionOption");
    self.navigationController.navigationBarHidden=false;
    [self addLeftBarButtonWithImage:true];
    [self customizedTextField];
    //Allocate keyboard notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - Customise view
- (void)customizedTextField {
    //Adding textfield to keyboard controls array
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:@[_maxBillingField, _billingFrequencyField]]];
    [_keyboardControls setDelegate:self];
    [_startDateField setTextBorder:_startDateField color:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0]];
    [_maxBillingField setTextBorder:_maxBillingField color:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0]];
    [_billingFrequencyField setTextBorder:_billingFrequencyField color:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0]];
    [_periodUnitField setTextBorder:_periodUnitField color:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0]];
    [self addPaddingShadow];
}

- (void)addPaddingShadow {
    [_startDateField addTextFieldPaddingWithoutImages:_startDateField];
    [_maxBillingField addTextFieldPaddingWithoutImages:_maxBillingField];
    [_billingFrequencyField addTextFieldPaddingWithoutImages:_billingFrequencyField];
    [_periodUnitField addTextFieldPaddingWithoutImages:_periodUnitField];
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
    [gNPickerViewObj hidePickerView];
    currentSelectedTextField=textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    isPickerEnable = false;
    //Set field position after show keyboard
    NSDictionary* info = [notification userInfo];
    NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    [self showKeyboardScrollView:[aValue CGRectValue].size.height];
}

- (void)showKeyboardScrollView:(float)keyboardHeight {
    float backViewY=265 + _emailLabel.frame.size.height;
    //Set condition according to check if current selected textfield is behind keyboard
    if (backViewY+currentSelectedTextField.frame.origin.y+currentSelectedTextField.frame.size.height<([UIScreen mainScreen].bounds.size.height)-keyboardHeight) {
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else {
        [_scrollView setContentOffset:CGPointMake(0, ((backViewY+currentSelectedTextField.frame.origin.y+currentSelectedTextField.frame.size.height)- ([UIScreen mainScreen].bounds.size.height-keyboardHeight))+10) animated:NO];
    }
    //Change content size of scroll view if current selected textfield is behind keyboard
    if (keyboardHeight-([UIScreen mainScreen].bounds.size.height-(backViewY+824))>0) {
        _scrollView.contentSize = CGSizeMake(0,[UIScreen mainScreen].bounds.size.height+(keyboardHeight-([UIScreen mainScreen].bounds.size.height-(backViewY+824)))-250);
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [self hideKeyboardScrollView];
}

- (void)hideKeyboardScrollView {
    if (!isPickerEnable) {
        _scrollView.contentSize = CGSizeMake(0,_containerView.frame.size.height);
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:false];
    }
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)selectDateAction:(id)sender {
    datepicker=[[UIDatePicker alloc] initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - 230 - 64, [[UIScreen mainScreen] bounds].size.width, 230)];
    datepicker.datePickerMode = UIDatePickerModeDate;
    datepicker.hidden = NO;
    datepicker.date = [NSDate date];
    
    [datepicker addTarget:self action:@selector(LabelChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datepicker];
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd/MM/yyyy"];
    _startDateField.text=[df stringFromDate:datepicker.date];
}

- (void)LabelChange:(id)sender{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd/MM/yyyy"];
    _startDateField.text = [NSString stringWithFormat:@"%@",
                          [df stringFromDate:datepicker.date]];
    [datepicker removeFromSuperview];
}

- (IBAction)periodUnitAction:(id)sender {
    isPickerEnable = true;
    [self.keyboardControls.activeField resignFirstResponder];
    currentSelectedTextField=_periodUnitField;
    [self showKeyboardScrollView:230.0];
    NSArray *arr = [NSArray arrayWithObjects:@"a",@"b", nil];
    [gNPickerViewObj showPickerView:arr selectedIndex:selectedIndex option:1 isCancelDelegate:false isFilterScreen:false];
}

- (IBAction)subscriptionReminderAction:(id)sender {
    if ([sender isSelected]) {
        [sender setSelected:false];
    } else {
        [sender setSelected:true];
    }
}

- (IBAction)emailClickAction:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setSubject:@"GoNatuur"];
        [mail setToRecipients:@[_emailLabel.text]];
        [self presentViewController:mail animated:YES completion:NULL];
    }
    else {
        NSLog(@"This device cannot send email");
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"You sent the email.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)cancelAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveAction:(id)sender {
}
#pragma mark - end

#pragma mark - Validations
- (BOOL)performValidations {
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    if ([_startDateField isEmpty] || [_maxBillingField isEmpty] || [_billingFrequencyField isEmpty] || [_periodUnitField isEmpty]) {
        [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"emptyFieldMessage") closeButtonTitle:NSLocalizedText(@"alertOk") duration:0.0f];
        return NO;
    } else {
        return YES;
    }
}
#pragma mark - end

#pragma mark - Add picker
- (void)addCustomPickerView {
    //Set initial index of picker view and initialized picker view
    selectedIndex=0;
    gNPickerViewObj=[[GoNatuurPickerView alloc] initWithFrame:self.view.frame delegate:self pickerHeight:230];
    [self.view addSubview:gNPickerViewObj.goNatuurPickerViewObj];
}
#pragma mark - end

#pragma mark - Custom picker delegate method
- (void)goNatuurPickerViewDelegateActionIndex:(int)tempSelectedIndex option:(int)option {
    if (option==1) {
        _periodUnitField.text = @"";
        selectedIndex=tempSelectedIndex;
    }
}
#pragma mark - end
@end
