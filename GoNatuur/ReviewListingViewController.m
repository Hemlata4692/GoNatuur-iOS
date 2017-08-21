//
//  ReviewListingViewController.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 19/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "ReviewListingViewController.h"
#import "ReviewDataModel.h"
#import "UITextField+Padding.h"
#import "ReviewViewController.h"
#import "GoNatuurPickerView.h"

@interface ReviewListingViewController ()<GoNatuurPickerViewDelegate> {
    @private
    GoNatuurPickerView *sortingPickerView;
    ReviewDataModel *reviewList;
     int selectedStarFilterIndex, selectedPickerIndex, selectedSortByFilterIndex, selectedSortFilterIndex;
    NSMutableArray *reviewListingDataAray, *sortByDataArray, *starFilterDataArray;
    NSString *starFilter, *sortByFilter;
}
@property (weak, nonatomic) IBOutlet UITableView *reviewListingTableView;
@property (weak, nonatomic) IBOutlet UIView *filterView;
@property (weak, nonatomic) IBOutlet UIButton *writeReviewButton;
@property (weak, nonatomic) IBOutlet UIButton *starFilterButton;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *sortByFilterButton;
@end

@implementation ReviewListingViewController
@synthesize productID;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    starFilterDataArray=[[NSMutableArray alloc]initWithObjects:@"1 Star",@"2 Stars",@"3 Stars",@"4 Stars",@"5 Stars", nil];
    sortByDataArray=[[NSMutableArray alloc]initWithObjects:@"Most Recent",@"Stars low to high",@"Stars high to low", nil];
    sortByFilter=@"";
    starFilter=@"";
    [myDelegate showIndicator];
    [self performSelector:@selector(getReviewListingData) withObject:nil afterDelay:.1];
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
    //customisation of objects
    [_writeReviewButton setCornerRadius:17.0];
    [_writeReviewButton addShadow:_writeReviewButton color:[UIColor blackColor]];
    [_searchTextField addTextFieldLeftRightPadding:_searchTextField];
     [self addCustomPickerView];
}

#pragma mark - end

- (void)addCustomPickerView {
    //Set initial index of picker view and initialized picker view
    selectedStarFilterIndex=0;
    selectedPickerIndex=0;
    selectedSortByFilterIndex=0;
    sortingPickerView=[[GoNatuurPickerView alloc] initWithFrame:self.view.frame delegate:self pickerHeight:230];
    [self.view addSubview:sortingPickerView.goNatuurPickerViewObj];
}

#pragma mark - Custom picker delegate method
- (void)goNatuurPickerViewDelegateActionIndex:(int)tempSelectedIndex option:(int)option {
    if (option==1) {
        if (selectedPickerIndex!=tempSelectedIndex) {
            selectedPickerIndex=tempSelectedIndex;
            [_starFilterButton setTitle:[starFilterDataArray objectAtIndex:tempSelectedIndex] forState:UIControlStateNormal];
            starFilter=[NSString stringWithFormat:@"%d",selectedPickerIndex+1];
//            [myDelegate showIndicator];
//            [self performSelector:@selector(getReviewListingData) withObject:nil afterDelay:.1];
        }
    }
    else if (option==2) {
        if (selectedSortFilterIndex!=tempSelectedIndex) {
            selectedSortFilterIndex=tempSelectedIndex;
            [_sortByFilterButton setTitle:[sortByDataArray objectAtIndex:tempSelectedIndex] forState:UIControlStateNormal];
            sortByFilter=@"";
            //            [myDelegate showIndicator];
            //            [self performSelector:@selector(getReviewListingData) withObject:nil afterDelay:.1];
        }
    }
}
#pragma mark - end
//:(NSString *)userName starValue:(NSString *)starValue sortFilter:(NSString *)sortFilter
#pragma mark - Webservice
//Get review list data
- (void)getReviewListingData {
    reviewList = [ReviewDataModel sharedUser];
    reviewList.productId=productID;
    reviewList.username=_searchTextField.text;
    reviewList.reviewDescription=_searchTextField.text;
    reviewList.reviewTitle=_searchTextField.text;
    reviewList.sortBy=sortByFilter;
    reviewList.starFilter=starFilter;
    [reviewList getUserReviewListingData:^(ReviewDataModel *userData)  {
        [myDelegate stopIndicator];
    } onfailure:^(NSError *error) {
    }];
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)starFilterButtonAction:(id)sender {
    [sortingPickerView showPickerView:starFilterDataArray selectedIndex:selectedPickerIndex option:1];
}

- (IBAction)sortByFilterAction:(id)sender {
     [sortingPickerView showPickerView:sortByDataArray selectedIndex:selectedSortFilterIndex option:2];
}

- (IBAction)writeReviewButtonAction:(id)sender {
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ReviewViewController * reviewView=[sb instantiateViewControllerWithIdentifier:@"ReviewViewController"];
    [self.navigationController pushViewController:reviewView animated:YES];
}
#pragma mark - end

#pragma mark Text Field Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
   [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    // add your method here
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}
#pragma mark - end

#pragma mark - Table view data source and delgate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"reviewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return UITableViewAutomaticDimension;
//}
#pragma mark - end
@end
