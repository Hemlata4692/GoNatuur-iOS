//
//  ReviewListingViewController.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 19/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "ReviewListingViewController.h"
#import "ReviewDataModel.h"

@interface ReviewListingViewController ()
@property (weak, nonatomic) IBOutlet UITableView *reviewListingTableView;
@property (weak, nonatomic) IBOutlet UIView *filterView;

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

@end
