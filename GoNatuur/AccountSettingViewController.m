//
//  AccountSettingViewController.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 22/11/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "AccountSettingViewController.h"
#import "SearchListingViewController.h"

@interface AccountSettingViewController ()
{
@private
    NSMutableArray *settingsDataArray, *settingsImagesArray;
}
@property (weak, nonatomic) IBOutlet UITableView *accountSettingsTableView;
@end

@implementation AccountSettingViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _accountSettingsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//remove extra cell from table view
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=false;
    self.title=NSLocalizedText(@"accountSetting");
    [self addLeftBarButtonWithImage:false];
    settingsDataArray=[[NSMutableArray alloc]initWithObjects:NSLocalizedText(@"returnOrderAccount"), NSLocalizedText(@"recentlyViewd"), nil];
    settingsImagesArray=[[NSMutableArray alloc]initWithObjects:@"return-order",@"recentely-view-product", nil];
}
#pragma mark - end

#pragma mark - Table view datasource delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return settingsDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *simpleTableIdentifier=@"settingsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    UILabel *settingsDataLabel=(UILabel *) [cell viewWithTag:1];
    UIImageView *imageIcon=(UIImageView *) [cell viewWithTag:2];
    settingsDataLabel.text=[settingsDataArray objectAtIndex:indexPath.row];
    imageIcon.image=[UIImage imageNamed:[settingsImagesArray objectAtIndex:indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%s",BaseUrl,[UserDefaultManager getValue:@"Language"],"/amasty_rma/guest/login/"]]];
    }
    if (indexPath.row==1) {
        SearchListingViewController *obj = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchListingViewController"];
        obj.searchKeyword=NSLocalizedText(@"recentlyViewd");
        obj.screenType=@"guestRecentViewed";
        obj.searchListIds=[[UserDefaultManager getValue:@"recentlyViewedGuest"] mutableCopy];
        [self.navigationController pushViewController:obj animated:true];
    }
}
#pragma mark - end
@end
