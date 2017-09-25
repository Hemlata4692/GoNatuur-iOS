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
#import "DynamicHeightWidth.h"

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
@property (weak, nonatomic) IBOutlet UILabel *starFilterLabel;
@property (weak, nonatomic) IBOutlet UILabel *sortByLabel;
@property (weak, nonatomic) IBOutlet UILabel *searchLabel;
@end

@implementation ReviewListingViewController
@synthesize productID;
@synthesize reviewId;
@synthesize reviewAdded;
@synthesize productDetailObj;
@synthesize eventDetailObj;
@synthesize navigationHeading;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    starFilterDataArray=[[NSMutableArray alloc]initWithObjects:NSLocalizedText(@"All"),NSLocalizedText(@"5 Stars"),NSLocalizedText(@"4 Stars"),NSLocalizedText(@"3 Stars"),NSLocalizedText(@"2 Stars"),NSLocalizedText(@"1 Star"), nil];
    sortByDataArray=[[NSMutableArray alloc]initWithObjects:NSLocalizedText(@"mostRecent"),NSLocalizedText(@"ratingLowHigh"),NSLocalizedText(@"ratingHighLow"), nil];
    sortByFilter=@"created_at";
    sortByValue=DESC;
    starFilter=@"5";
    pageCount=1;
    applyStarFilter=@"1";
    _noRecordLabel.hidden=YES;
    [self addCustomPickerView];
    [self initFooterView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.title=navigationHeading;
    self.navigationController.navigationBarHidden=false;
    [self addLeftBarButtonWithImage:true];
    [self viewCustomisation];
    reviewListingDataAray=[[NSMutableArray alloc]init];
    [myDelegate showIndicator];
    [self performSelector:@selector(getReviewListingData) withObject:nil afterDelay:.1];
}

- (void)viewCustomisation {
    //customisation of objects
    [_writeReviewButton setCornerRadius:20.0];
    [_writeReviewButton addShadow:_writeReviewButton color:[UIColor blackColor]];
    [_searchTextField addTextFieldLeftRightPadding:_searchTextField];
    //Bring front view picker view
    [self.view bringSubviewToFront:sortingPickerView.goNatuurPickerViewObj];
    if ([reviewAdded isEqualToString:@"1"] || (nil==[UserDefaultManager getValue:@"userId"])) {
        _writeReviewButton.enabled=false;
        _writeReviewButton.alpha = 0.8;
    }
    [self localizedText];
}

- (void)localizedText {
    _noRecordLabel.text=NSLocalizedText(@"norecord");
    _searchTextField.placeholder=NSLocalizedText(@"search");
    _sortByLabel.text=NSLocalizedText(@"Sortby");
    _starFilterLabel.text=NSLocalizedText(@"stars");
    [_writeReviewButton setTitle:NSLocalizedText(@"writereview") forState:UIControlStateNormal];

}
#pragma mark - end


#pragma mark - Custom picker delegate method
- (void)addCustomPickerView {
    //Set initial index of picker view and initialized picker view
    selectedPickerIndex=-1;
    selectedSortFilterIndex=-1;
    selectedSortByFilterIndex=0;
    sortingPickerView=[[GoNatuurPickerView alloc] initWithFrame:self.view.frame delegate:self pickerHeight:230];
    [self.view addSubview:sortingPickerView.goNatuurPickerViewObj];
}

- (void)goNatuurPickerViewDelegateActionIndex:(int)tempSelectedIndex option:(int)option {
    if (option==1) {
        if (selectedPickerIndex!=tempSelectedIndex) {
            selectedPickerIndex=tempSelectedIndex;
            [_starFilterButton setTitle:[starFilterDataArray objectAtIndex:tempSelectedIndex] forState:UIControlStateNormal];
            if (tempSelectedIndex==0) {
                starFilter=[NSString stringWithFormat:@"5"];
                applyStarFilter=@"0";
            }
            else {
                starFilter=[NSString stringWithFormat:@"%d",(int)([starFilterDataArray count]-(tempSelectedIndex+1))+1];
                applyStarFilter=@"1";
            }
        }
    }
    else if (option==2) {
        if (selectedSortFilterIndex!=tempSelectedIndex) {
            selectedSortFilterIndex=tempSelectedIndex;
            [_sortByFilterButton setTitle:[sortByDataArray objectAtIndex:tempSelectedIndex] forState:UIControlStateNormal];
            if (selectedSortFilterIndex==0) {
                sortByFilter=@"created_at";
                sortByValue=DESC;
            }
            else if (selectedSortFilterIndex==1) {
                sortByFilter=@"reviewvote.value";
                sortByValue=ASC;
            }
            else {
                sortByFilter=@"reviewvote.value";
                sortByValue=DESC;
            }
        }
    }
    reviewListingDataAray=[[NSMutableArray alloc]init];
    pageCount=1;
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
            _reviewListingTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//remove extra cell from table view
        }
    } onfailure:^(NSError *error) {
        _noRecordLabel.hidden=NO;
        _reviewListingTableView.hidden=YES;
    }];
}
#pragma mark - end

#pragma mark - IBActions
- (void)backButtonAction :(id)sender {
    productDetailObj.reviewAdded=reviewAdded;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)starFilterButtonAction:(id)sender {
    [_searchTextField resignFirstResponder];
    [sortingPickerView showPickerView:starFilterDataArray selectedIndex:(selectedPickerIndex==-1?1:selectedPickerIndex) option:1 isCancelDelegate:false];
}

- (IBAction)sortByFilterAction:(id)sender {
    [_searchTextField resignFirstResponder];
    [sortingPickerView showPickerView:sortByDataArray selectedIndex:(selectedSortFilterIndex==-1?0:selectedSortFilterIndex) option:2 isCancelDelegate:false];
}

- (IBAction)writeReviewButtonAction:(id)sender {
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ReviewViewController * reviewView=[sb instantiateViewControllerWithIdentifier:@"ReviewViewController"];
    reviewView.selectedProductId=productID;
    reviewView.isEditMode=@"0";
    reviewView.reviewListObj=self;
    [self.navigationController pushViewController:reviewView animated:YES];
}
#pragma mark - end

#pragma mark Text Field Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    reviewListingDataAray=[[NSMutableArray alloc]init];
    pageCount=1;
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
    if ([[[reviewListingDataAray objectAtIndex:indexPath.row]reviewId] intValue]==[reviewId intValue]) {
         [cell displayData:[reviewListingDataAray objectAtIndex:indexPath.row] reviewId:reviewId rectSize:_reviewListingTableView.frame.size];
    }
    else {
         [cell displayData:[reviewListingDataAray objectAtIndex:indexPath.row] reviewId:@"0" rectSize:_reviewListingTableView.frame.size];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[[reviewListingDataAray objectAtIndex:indexPath.row]reviewId] intValue]==[reviewId intValue]) {
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ReviewViewController * reviewView=[sb instantiateViewControllerWithIdentifier:@"ReviewViewController"];
    reviewView.selectedProductId=productID;
    reviewView.isEditMode=@"1";
    reviewView.reviewListObj=self;
    reviewView.reviewData=[reviewListingDataAray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:reviewView animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //float titleHeight =[DynamicHeightWidth getDynamicLabelHeight:[[reviewListingDataAray objectAtIndex:indexPath.row] reviewTitle] font:[UIFont montserratBoldWithSize:13] widthValue:tableView.frame.size.width-93];
    float descriptionHeight =[DynamicHeightWidth getDynamicLabelHeight:[[reviewListingDataAray objectAtIndex:indexPath.row] reviewDescription] font:[UIFont montserratRegularWithSize:12] widthValue:tableView.frame.size.width-93];
    
    if (descriptionHeight<=16) {
        return 120;
    }
    else if (descriptionHeight<=31) {
        return 120;
        
    }
    else {
        return 120+descriptionHeight-28;
    }
}
#pragma mark - end

#pragma mark - Pagignation for table view
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *) cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (reviewListingDataAray.count ==totalCount) {
        [(UIActivityIndicatorView *)[footerView viewWithTag:10] stopAnimating];
        [(UILabel *)[footerView viewWithTag:11] setHidden:true];
        [(UIActivityIndicatorView *)[footerView viewWithTag:10] setHidden:true];
        _reviewListingTableView.tableFooterView = nil;
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
    UIActivityIndicatorView * actInd = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    actInd.color=[UIColor colorWithRed:143.0/255.0 green:29.0/255.0 blue:55.0/255.0 alpha:1.0];
    actInd.tag = 10;
    actInd.frame = CGRectMake(self.view.frame.size.width/2-10, 0.0, 20.0, 20.0);
    actInd.hidesWhenStopped = YES;
    [footerView addSubview:actInd];
}
#pragma mark - end
@end
