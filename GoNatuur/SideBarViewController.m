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
#import "UIView+Toast.h"
#import "NotificationViewController.h"

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
    if ([ConstantCode checkDeviceType]==Device5s) {
        _sideBarTableView.scrollEnabled=YES;
    }
    [_sideBarTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.revealViewController.frontViewController.view setUserInteractionEnabled:YES];
}

- (void)viewCustomisationAndData {
    [_userProfileImageView setCornerRadius:_userProfileImageView.frame.size.width/2];
    [_userProfileImageView setBorder:_userProfileImageView color:[UIColor whiteColor] borderWidth:3.0];
    [ImageCaching downloadImages:_userProfileImageView imageUrl:[UserDefaultManager getValue:@"profilePicture"] placeholderImage:@"profile_placeholder" isDashboardCell:true];
    
    _userEmailLabel.translatesAutoresizingMaskIntoConstraints=YES;
    if ((nil==[UserDefaultManager getValue:@"userId"])) {
        _userEmailLabel.text=NSLocalizedText(@"guestUser");
    }
    else {
        _userEmailLabel.text=[UserDefaultManager getValue:@"emailId"];
    }
    _userEmailLabel.numberOfLines=3;
    float newHeight =[DynamicHeightWidth getDynamicLabelHeight:_userEmailLabel.text font:[UIFont fontWithName:@"Montserrat-Regular" size:16.0] widthValue:[[UIScreen mainScreen] bounds].size.width-120];
    _userEmailLabel.frame=CGRectMake(30, _userEmailLabel.frame.origin.y,[[UIScreen mainScreen] bounds].size.width-120, newHeight+1);
    
    //remove extra lines from table view
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
        UILabel *notificationBadgeLabel=(UILabel *) [cell viewWithTag:10];
        notificationBadgeLabel.translatesAutoresizingMaskIntoConstraints=YES;
        if([[[UserDefaultManager getValue:@"notificationsCount"] stringValue] isEqualToString:@""] || [UserDefaultManager getValue:@"notificationsCount"]==nil || [[[UserDefaultManager getValue:@"notificationsCount"] stringValue] isEqualToString:@"0"]) {
            notificationBadgeLabel.hidden=YES;
        }
        else {
            notificationBadgeLabel.hidden=NO;
            notificationBadgeLabel.text=[[UserDefaultManager getValue:@"notificationsCount"] stringValue];
        }
        [notificationBadgeLabel sizeToFit];
        notificationBadgeLabel.frame=CGRectMake(185, notificationBadgeLabel.frame.origin.y,notificationBadgeLabel.frame.size.width+12, 15);
        [notificationBadgeLabel setCornerRadius:8.0];
    }
    
    UILabel *cellLabel=(UILabel *) [cell viewWithTag:1];
    UIImageView *cellImage=(UIImageView *) [cell viewWithTag:20];
    if (indexPath.row==6&&(nil==[UserDefaultManager getValue:@"userId"])) {
        cellLabel.text=NSLocalizedText(@"sideBarLogin");
        cellImage.image=[UIImage imageNamed:@"login"];
    }
    else {
        cellLabel.text=[CellIdentifier uppercaseString];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        [self.view makeToast:NSLocalizedText(@"featureNotAvailable")];
    }
    else if (indexPath.row==1) {
        [self.view makeToast:NSLocalizedText(@"featureNotAvailable")];
    }
    else if (indexPath.row==2) {
        [self.view makeToast:NSLocalizedText(@"featureNotAvailable")];
    }
    else if (indexPath.row==3) {
        myDelegate.selectedCategoryIndex=-1;
        myDelegate.isProductList=false;
    }
    else if (indexPath.row==4) {
        [self.view makeToast:NSLocalizedText(@"featureNotAvailable")];
    }
    else if (indexPath.row==5) {
        myDelegate.selectedCategoryIndex=-1;
        [myDelegate checkGuestAccess];
    }
    else if (indexPath.row==6) {
        if ((nil==[UserDefaultManager getValue:@"userId"])) {
            myDelegate.selectedCategoryIndex=-1;
            [myDelegate logoutUser];
        }
        else {
            myDelegate.selectedCategoryIndex=-1;
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert addButton:NSLocalizedText(@"alertOk") actionBlock:^(void) {
                //logou1 user
                [myDelegate logoutUser];
            }];
            [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"logoutUser") closeButtonTitle:NSLocalizedText(@"alertCancel") duration:0.0f];
        }
    }
}
#pragma mark - end
//@[@"My Orders", @"Payment", @"Redeem Points", @"Events", @"News Centre",@"Notifications", @"Signout"]
#pragma mark - Navigation segue identifier
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ((nil==[UserDefaultManager getValue:@"userId"])) {
        if([identifier isEqualToString:@"My Orders"])
        {
            return NO;
        }
        else if([identifier isEqualToString:@"Payment"])
        {
            return NO;
        }
        else if([identifier isEqualToString:@"Redeem Points"])
        {
            return NO;
        }
        else if([identifier isEqualToString:@"Notifications"])
        {
            return NO;
        }
        else {
            return YES;
        }
    }
    else {
        // by default perform the segue transition
        return YES;
    }
}
#pragma mark - end

//#pragma mark - Guest access
//- (void)checkGuestAccess {
//    if ((nil==[UserDefaultManager getValue:@"userId"])) {
//        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
//        [alert addButton:NSLocalizedText(@"alertOk") actionBlock:^(void) {
//            //logout user
//            [self logoutUser];
//        }];
//        [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"guestUserAccess") closeButtonTitle:NSLocalizedText(@"alertCancel") duration:0.0f];
//    }
//}
//#pragma mark - end
//
//#pragma mark - Logout user
//- (void)logoutUser {
//    //Logout user
//    [UserDefaultManager removeValue:@"userId"];
//    [UserDefaultManager removeValue:@"emailId"];
//    [UserDefaultManager removeValue:@"Authorization"];
//    [UserDefaultManager removeValue:@"profilePicture"];
//    [UserDefaultManager removeValue:@"enableNotification"];
//    [UserDefaultManager removeValue:@"quoteId"];
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    myDelegate.navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainNavController"];
//    myDelegate.window.rootViewController = myDelegate.navigationController;
//}
//#pragma mark - end
@end
