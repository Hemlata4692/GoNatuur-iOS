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
#import "ReviewTableViewCell.h"

@interface ReviewListingViewController ()<GoNatuurPickerViewDelegate> {
@private
    GoNatuurPickerView *sortingPickerView;
    ReviewDataModel *reviewList;
    int selectedStarFilterIndex, selectedPickerIndex, selectedSortByFilterIndex, selectedSortFilterIndex, pageCount, totalCount;
    NSMutableArray *reviewListingDataAray, *sortByDataArray, *starFilterDataArray;
    NSString *starFilter, *sortByFilter, *sortByValue, *applyStarFilter;
    UIView *footerView;
}
@property (weak, nonatomic) IBOutlet UITableView *reviewListingTableView;
@property (weak, nonatomic) IBOutlet UIView *filterView;
@property (weak, nonatomic) IBOutlet UIButton *writeReviewButton;
@property (weak, nonatomic) IBOutlet UIButton *starFilterButton;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *sortByFilterButton;
@property (weak, nonatomic) IBOutlet UILabel *noRecordLabel;
@end

@implementation ReviewListingViewController
@synthesize productID;
@synthesize reviewId;
@synthesize reviewAdded;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    starFilterDataArray=[[NSMutableArray alloc]initWithObjects:@"All",@"5 Stars",@"4 Stars",@"3 Stars",@"2 Stars",@"1 Star", nil];
    sortByDataArray=[[NSMutableArray alloc]initWithObjects:@"Most Recent",@"Rating low to high",@"Rating high to low", nil];
    sortByFilter=@"created_at";
    sortByValue=@"DESC";
    starFilter=@"5";
    pageCount=1;
    applyStarFilter=@"1";
    _noRecordLabel.hidden=YES;
    reviewListingDataAray=[[NSMutableArray alloc]init];
    if ([reviewAdded isEqualToString:@"1"]) {
        _writeReviewButton.enabled=false;
    }
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
    [self initFooterView];
    [myDelegate showIndicator];
    [self performSelector:@selector(getReviewListingData) withObject:nil afterDelay:.1];
}

- (void)viewCustomisation {
    //customisation of objects
    [_writeReviewButton setCornerRadius:17.0];
    [_writeReviewButton addShadow:_writeReviewButton color:[UIColor blackColor]];
    [_searchTextField addTextFieldLeftRightPadding:_searchTextField];
//    _reviewListingTableView.estimatedRowHeight = 500.0;//set maximum row height
//    _reviewListingTableView.rowHeight = UITableViewAutomaticDimension;//set dynamic height of row according to text
    _reviewListingTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//remove extra cell from table view

    [self addCustomPickerView];
}

#pragma mark - end

- (void)addCustomPickerView {
    //Set initial index of picker view and initialized picker view
    selectedStarFilterIndex=0;
    selectedPickerIndex=-1;
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
            if ([_starFilterButton.titleLabel.text isEqualToString:@"All"]) {
                applyStarFilter=@"0";
            }
            else {
                applyStarFilter=@"1";
            }
        }
    }
    else if (option==2) {
        if (selectedSortFilterIndex!=tempSelectedIndex) {
            selectedSortFilterIndex=tempSelectedIndex;
            [_sortByFilterButton setTitle:[sortByDataArray objectAtIndex:tempSelectedIndex] forState:UIControlStateNormal];
            sortByFilter=@"created_at";
            sortByValue=@"DESC";
        }
    }
    reviewListingDataAray=[[NSMutableArray alloc]init];
    [myDelegate showIndicator];
    [self performSelector:@selector(getReviewListingData) withObject:nil afterDelay:.1];
}
#pragma mark - end

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
    reviewList.sortByValue=sortByValue;
    reviewList.applyStarFilter=applyStarFilter;
    reviewList.pageCount=[NSNumber numberWithInt:pageCount];
    [reviewList getUserReviewListingData:^(ReviewDataModel *userData)  {
        [myDelegate stopIndicator];
        [reviewListingDataAray addObjectsFromArray:userData.reviewListArray];
        totalCount=[userData.totalCount intValue];
        if (reviewListingDataAray.count==0) {
            _noRecordLabel.hidden=NO;
             [_reviewListingTableView reloadData];
        }
        else {
            _noRecordLabel.hidden=YES;
            [_reviewListingTableView reloadData];
        }
    } onfailure:^(NSError *error) {
        _noRecordLabel.hidden=NO;
        _reviewListingTableView.hidden=YES;
    }];
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)starFilterButtonAction:(id)sender {
    [_searchTextField resignFirstResponder];
    if (selectedPickerIndex==-1) {
        selectedPickerIndex=1;
    }
    [sortingPickerView showPickerView:starFilterDataArray selectedIndex:selectedPickerIndex option:1];
}

- (IBAction)sortByFilterAction:(id)sender {
    [_searchTextField resignFirstResponder];
    if (selectedPickerIndex==-1) {
        selectedPickerIndex=1;
    }
    [sortingPickerView showPickerView:sortByDataArray selectedIndex:selectedSortFilterIndex option:2];
}

- (IBAction)writeReviewButtonAction:(id)sender {
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ReviewViewController * reviewView=[sb instantiateViewControllerWithIdentifier:@"ReviewViewController"];
    reviewView.selectedProductId=productID;
    reviewView.isEditMode=@"0";
    [self.navigationController pushViewController:reviewView animated:YES];
}
#pragma mark - end

#pragma mark Text Field Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    reviewListingDataAray=[[NSMutableArray alloc]init];
    [myDelegate showIndicator];
    [self performSelector:@selector(getReviewListingData) withObject:nil afterDelay:.1];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    // add your method here
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [sortingPickerView hidePickerView];
}

#pragma mark - end

#pragma mark - Table view data source and delgate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return reviewListingDataAray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"reviewCell";
    ReviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.editReviewIcon.hidden=YES;
    [cell displayData:[reviewListingDataAray objectAtIndex:indexPath.row] reviewId:reviewId rectSize:_reviewListingTableView.frame.size];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ReviewViewController * reviewView=[sb instantiateViewControllerWithIdentifier:@"ReviewViewController"];
    reviewView.selectedProductId=productID;
    reviewView.isEditMode=@"1";
    reviewView.reviewData=[reviewListingDataAray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:reviewView animated:YES];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return UITableViewAutomaticDimension;
//}
#pragma mark - end

#pragma mark - Pagignation for table view
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *) cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (reviewListingDataAray.count ==totalCount) {
        [(UIActivityIndicatorView *)[footerView viewWithTag:10] stopAnimating];
        [(UILabel *)[footerView viewWithTag:11] setHidden:true];
    }
    else if(indexPath.row==[reviewListingDataAray count]-1) {
        if(reviewListingDataAray.count < totalCount) {
            tableView.tableFooterView = footerView;
            [(UIActivityIndicatorView *)[footerView viewWithTag:10] startAnimating];
            pageCount++;
            [self getReviewListingData];
        }
        else {
            _reviewListingTableView.tableFooterView = nil;
        }
    }
}

//Load footer view in table
- (void)initFooterView {
    footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 40.0)];
    UIActivityIndicatorView * actInd = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    actInd.color=[UIColor whiteColor];
    actInd.tag = 10;
    actInd.frame = CGRectMake(self.view.frame.size.width/2-10, 10.0, 20.0, 20.0);
    actInd.hidesWhenStopped = YES;
    [footerView addSubview:actInd];
    actInd = nil;
}
#pragma mark - end
@end
