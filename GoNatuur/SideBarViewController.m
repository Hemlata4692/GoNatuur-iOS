//
//  SideBarViewController.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 09/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "SideBarViewController.h"
#import "SWRevealViewController.h"
#import "DynamicHeightWidth.h"

@interface SideBarViewController () {
    NSArray *menuItemsArray;
}
@property (weak, nonatomic) IBOutlet UITableView *sideBarTableView;
@property (weak, nonatomic) IBOutlet UILabel *userEmailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;
@end

@implementation SideBarViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    menuItemsArray = @[@"My Orders", @"Payment", @"Redeem Points", @"Events", @"News Centre",@"Notifications", @"Signout"];
    // Remove extra seperator from table view
    [self viewCustomisationAndData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.revealViewController.frontViewController.view setUserInteractionEnabled:NO];
    [_sideBarTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.revealViewController.frontViewController.view setUserInteractionEnabled:YES];
}

- (void)viewCustomisationAndData {
    [_userProfileImageView setCornerRadius:_userProfileImageView.frame.size.width/2];
    [_userProfileImageView setBorder:_userProfileImageView color:[UIColor whiteColor] borderWidth:3.0];
    _userEmailLabel.translatesAutoresizingMaskIntoConstraints=YES;
    _userEmailLabel.text=@"hemlata@ranosys.com";
    _userEmailLabel.numberOfLines=3;
    float newHeight =[DynamicHeightWidth getDynamicLabelHeight:_userEmailLabel.text font:[UIFont fontWithName:@"Montserrat-Regular" size:16.0] widthValue:[[UIScreen mainScreen] bounds].size.width-120];
    _userEmailLabel.frame=CGRectMake(30, _userEmailLabel.frame.origin.y,[[UIScreen mainScreen] bounds].size.width-120, newHeight+1);
    
    _sideBarTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}
#pragma mark - end

#pragma mark - Table view data source and delgate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return menuItemsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [menuItemsArray objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (indexPath.row==5) {
        UILabel *notificationBadgeLabel=(UILabel *) [cell viewWithTag:3];
        notificationBadgeLabel.translatesAutoresizingMaskIntoConstraints=YES;
        notificationBadgeLabel.text=@"5478";
        [notificationBadgeLabel sizeToFit];
        notificationBadgeLabel.frame=CGRectMake(185, notificationBadgeLabel.frame.origin.y,notificationBadgeLabel.frame.size.width+12, 15);
        [notificationBadgeLabel setCornerRadius:8.0];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==6) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert addButton:@"Ok" actionBlock:^(void) {
            //logou user
            [self logoutUser];
        }];
        [alert showWarning:nil title:@"Alert" subTitle:@"Are you sure you want to Signout?" closeButtonTitle:@"Cancel" duration:0.0f];
    }
}
#pragma mark - end

#pragma mark - Logout user
- (void)logoutUser {
    //Logout user
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    myDelegate.navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainNavController"];
    myDelegate.window.rootViewController = myDelegate.navigationController;
}
#pragma mark - end
@end
