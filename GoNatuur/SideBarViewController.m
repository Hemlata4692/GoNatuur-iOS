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
@end

@implementation SideBarViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    menuItemsArray = @[@"User Profile",@"My Orders", @"Payment", @"Redeem Points", @"Events", @"News Centre",@"Notifications", @"Signout"];
    // Remove extra seperator from table view
    _sideBarTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
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

#pragma mark - end

#pragma mark - Table view data source and delgate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return menuItemsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [menuItemsArray objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (indexPath.row==0) {
        UIImageView *userImageView=(UIImageView *) [cell viewWithTag:1];
        UILabel *userEmailLabel=(UILabel *) [cell viewWithTag:2];
        [userImageView setCornerRadius:userImageView.frame.size.width/2];
        [userImageView setBorder:userImageView color:[UIColor whiteColor] borderWidth:3.0];
        userEmailLabel.translatesAutoresizingMaskIntoConstraints=YES;
        userEmailLabel.backgroundColor=[UIColor blueColor];
        userEmailLabel.text=@"hemlatakhajanchi@ranosys.com";
        userEmailLabel.numberOfLines=3;
        float newHeight =[DynamicHeightWidth getDynamicLabelHeight:userEmailLabel.text font:[UIFont fontWithName:@"Montserrat-Regular" size:16.0] widthValue:_sideBarTableView.frame.size.width-40];
        userEmailLabel.frame=CGRectMake(20, userEmailLabel.frame.origin.y,_sideBarTableView.frame.size.width-40, newHeight+1);
    }
    else if (indexPath.row==6) {
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
    if (indexPath.row==0) {
        return 265.0;
    }
    else {
        return 50.0;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==7) {
        //Logout user
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        myDelegate.navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainNavController"];
        myDelegate.window.rootViewController = myDelegate.navigationController;
    }
}


@end
