//
//  ImpactPointsHistoryViewController.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 21/11/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "ImpactPointsHistoryViewController.h"
#import "DynamicHeightWidth.h"
#import "ImapctPointHistoryTableViewCell.h"
#import "ProfileModel.h"
#import "UIImage+UIImage_fixOrientation.h"

@interface ImpactPointsHistoryViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
@private
    NSMutableArray *impactsPointDataArray;
    UIImage *userProfileImage;
    BOOL isImagePicker;
    int totalProductCount, currentpage;
    UIView *footerView;
}
@property (weak, nonatomic) IBOutlet UITableView *impactsPointTableView;
@property (weak, nonatomic) IBOutlet UILabel *noRecordLabel;

@end

@implementation ImpactPointsHistoryViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    impactsPointDataArray = [NSMutableArray new];
    isImagePicker = false;
    [myDelegate showIndicator];
    [self performSelector:@selector(getUserImapctPoints) withObject:nil afterDelay:.1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.title=NSLocalizedText(@"impactPointHistory");
    _noRecordLabel.text=NSLocalizedText(@"norecord");
    self.navigationController.navigationBarHidden=false;
    [self addLeftBarButtonWithImage:true];
    totalProductCount=0;
    currentpage=1;
    _impactsPointTableView.tableFooterView=nil;
    //Allocate footer view
    [self initializeFooterView];
    if (!isImagePicker) {
        [_impactsPointTableView reloadData];
    }
}

- (void)initializeFooterView {
    footerView=[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, [[UIScreen mainScreen] bounds].size.width, 40.0)];
    UIActivityIndicatorView *activityIndicatorObject = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicatorObject.color=[UIColor colorWithRed:143.0/255.0 green:29.0/255.0 blue:55.0/255.0 alpha:1.0];
    activityIndicatorObject.tag = 10;
    activityIndicatorObject.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width/2-10, 10.0, 20.0, 20.0);
    activityIndicatorObject.hidesWhenStopped = YES;
    [footerView addSubview:activityIndicatorObject];
}
#pragma mark - end

#pragma mark - TableView DataSource and Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
        return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    }
    else {
        return impactsPointDataArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==0) {
      return 0.0;
    }
    else {
        return 0.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row==0) {
            return 150;
        } else if (indexPath.row==1) {
            return [DynamicHeightWidth getDynamicLabelHeight:[UserDefaultManager getValue:@"emailId"] font:[UIFont montserratLightWithSize:16] widthValue:[[UIScreen mainScreen] bounds].size.width-50 heightValue:60]+10;
        } else if (indexPath.row==2) {
            return 80;
        }  else if (indexPath.row==3) {
            return 12;
        }
    }
    else  {
        NSDictionary *tempDict=[impactsPointDataArray objectAtIndex:indexPath.row];
         float commentsHeight=[DynamicHeightWidth getDynamicLabelHeight:[tempDict objectForKey:@"comments"] font:[UIFont montserratLightWithSize:14] widthValue:[[UIScreen mainScreen] bounds].size.width-20 heightValue:200]+5;
        return 120+commentsHeight;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *simpleTableIdentifier;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            simpleTableIdentifier=@"profileImageCell";
        } else if (indexPath.row == 1) {
            simpleTableIdentifier=@"userEmailCell";
        } else if (indexPath.row == 2) {
            simpleTableIdentifier=@"impactPointCell";
        }  else if (indexPath.row == 3) {
            simpleTableIdentifier=@"bottomArrowCell";
        }
    }
    else {
        simpleTableIdentifier=@"impactsPointDataCell";
    }
    ImapctPointHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[ImapctPointHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 4) {
        } else {
            [cell displayData:_impactsPointTableView.frame.size];
            [cell.editUserProfileImageButton addTarget:self action:@selector(editUserImageAction:) forControlEvents:UIControlEventTouchUpInside];
        }
    } else {
        [cell displayImpactsPointData:_impactsPointTableView.frame.size impactsPointData:[impactsPointDataArray objectAtIndex:indexPath.row]];
    }
    return cell;
}
#pragma mark - end

#pragma mark - IBAction
- (IBAction)editUserImageAction:(UIButton *)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedText(@"TakePhoto") preferredStyle:UIAlertControllerStyleActionSheet];
    [actionSheet addAction:[UIAlertAction actionWithTitle:NSLocalizedText(@"alertCancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        // Cancel button tappped.
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:NSLocalizedText(@"Camera") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // Camera button tapped.
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert showWarning:nil title:NSLocalizedText(@"error") subTitle:NSLocalizedText(@"noCamera") closeButtonTitle:NSLocalizedText(@"alertOk") duration:0.0f];
        }
        else {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:NULL];
        }
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:NSLocalizedText(@"Gallery") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // Gallery button tapped.
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.navigationBar.translucent = NO;
        picker.navigationBar.barTintColor = [UIColor colorWithRed:242.0/255.0 green:233.0/255.0 blue:237.0/255.0 alpha:1];
        picker.navigationBar.tintColor = [UIColor blackColor];
        picker.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor]};
        [self presentViewController:picker animated:YES completion:NULL];
    }]];
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
    
}
#pragma mark - end

#pragma mark - Image picker controller delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)info {
    NSIndexPath *index=[NSIndexPath indexPathForRow:0 inSection:0];
    ImapctPointHistoryTableViewCell * cell = (ImapctPointHistoryTableViewCell *)[_impactsPointTableView cellForRowAtIndexPath:index];
    UIImage *correctOrientationImage = [image fixOrientation];
    cell.userProfileImage.image=correctOrientationImage;
    isImagePicker=true;
    userProfileImage=cell.userProfileImage.image;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    [myDelegate showIndicator];
    [self performSelector:@selector(editUserProfileImage) withObject:nil afterDelay:.1];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark - end

#pragma mark - Web services
- (void)getUserImapctPoints {
    ProfileModel *userData = [ProfileModel sharedUser];
    userData.pageCount=[UserDefaultManager getValue:@"paginationSize"];
    userData.currentPage=[NSString stringWithFormat:@"%d",currentpage];
    [userData getImpactPoints:^(ProfileModel *userData) {
        [myDelegate stopIndicator];
        [impactsPointDataArray addObjectsFromArray:userData.impactsPointDataArray];
        totalProductCount=[userData.impactPointTotalRecord intValue];
        [_impactsPointTableView reloadData];
    } onfailure:^(NSError *error) {
        
    }];
}

- (void)editUserProfileImage {
    ProfileModel *userData = [ProfileModel sharedUser];
    userData.userImage=userProfileImage;
    [userData updateUserProfileImage:^(ProfileModel *userData) {
        isImagePicker=false;
        [myDelegate stopIndicator];
        //dispaly profile data
    } onfailure:^(NSError *error) {
        
    }];
}
#pragma mark - end

#pragma mark - Pagignation for table view
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ((int)_impactsPointTableView.contentOffset.y == (int)_impactsPointTableView.contentSize.height - (int)scrollView.frame.size.height) {
        if (impactsPointDataArray.count == totalProductCount) {
            [(UIActivityIndicatorView *)[footerView viewWithTag:10] stopAnimating];
            [(UILabel *)[footerView viewWithTag:11] setHidden:true];
            _impactsPointTableView.tableFooterView = nil;
        }
        else {
            if(impactsPointDataArray.count < totalProductCount) {
                _impactsPointTableView.tableFooterView = footerView;
                [(UIActivityIndicatorView *)[footerView viewWithTag:10] startAnimating];
                currentpage+=1;
                [self getUserImapctPoints];
            }
            else {
                _impactsPointTableView.tableFooterView = nil;
            }
        }
    }
    else {
        [(UIActivityIndicatorView *)[footerView viewWithTag:10] stopAnimating];
        [(UILabel *)[footerView viewWithTag:11] setHidden:true];
        _impactsPointTableView.tableFooterView = nil;
    }
}
#pragma mark - end
@end
