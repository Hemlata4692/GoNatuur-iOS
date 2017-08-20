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

@interface ReviewListingViewController ()
@property (weak, nonatomic) IBOutlet UITableView *reviewListingTableView;
@property (weak, nonatomic) IBOutlet UIView *filterView;
@property (weak, nonatomic) IBOutlet UIButton *writeReviewButton;
@property (weak, nonatomic) IBOutlet UIButton *starFilterButton;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *sortByFilterButton;
@end

@implementation ReviewListingViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
}

#pragma mark - end

#pragma mark - Webservice
//Get review list data
- (void)getReviewListingData {
    ReviewDataModel *reviewList = [ReviewDataModel sharedUser];
    reviewList.productId=@"4";
    reviewList.username=@"";
    reviewList.reviewDescription=@"";
    reviewList.reviewTitle=@"";
    reviewList.sortBy=@"0";
    reviewList.starFilter=@"0";
    [reviewList getUserReviewListingData:^(ReviewDataModel *userData)  {
        [myDelegate stopIndicator];
    } onfailure:^(NSError *error) {
    }];
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)starFilterButtonAction:(id)sender {
}

- (IBAction)sortByFilterAction:(id)sender {
}

- (IBAction)writeReviewButtonAction:(id)sender {
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ReviewViewController * reviewView=[sb instantiateViewControllerWithIdentifier:@"ReviewViewController"];
    [self.navigationController pushViewController:reviewView animated:YES];
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
