//
//  ProfileViewController.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 29/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "ProfileViewController.h"
#import "DynamicHeightWidth.h"
#import "GoNatuurPickerView.h"
#import "ProfileTableViewCell.h"
#import "UIImage+UIImage_fixOrientation.h"
#import "ProfileModel.h"

@interface ProfileViewController ()<GoNatuurPickerViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    NSArray *menuItemsArray, *customerSupportArray;
    GoNatuurPickerView *customerSupportPicker;
    int selectedPickerIndex;
    UIImage *userProfileImage;
}
@property (weak, nonatomic) IBOutlet UITableView *profileTableView;
@end

@implementation ProfileViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    menuItemsArray = @[@"profileImageCell", @"userEmailCell", @"impactPointCell", @"redeemPointCell", @"detailCell",@"customerSupportCell", @"changePasswordCell"];
    customerSupportArray=@[NSLocalizedText(@"chat"), NSLocalizedText(@"raiseTicket")];
    [self addCustomPickerView];
    [myDelegate showIndicator];
    [self performSelector:@selector(getUserImapctPoints) withObject:nil afterDelay:.1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.title=NSLocalizedText(@"profileTitle");
    self.navigationController.navigationBarHidden=false;
    [self addLeftBarButtonWithImage:false];
    [self.view bringSubviewToFront:customerSupportPicker.goNatuurPickerViewObj];
    [self showSelectedTab:4];
   
}

//add picker view
- (void)addCustomPickerView {
    selectedPickerIndex=-1;
    //Set initial index of picker view and initialized picker view
    customerSupportPicker=[[GoNatuurPickerView alloc] initWithFrame:self.view.frame delegate:self pickerHeight:230];
    [self.view addSubview:customerSupportPicker.goNatuurPickerViewObj];
}
#pragma mark - end

#pragma mark - Web services
//Get user profile
- (void)getUserImapctPoints {
    ProfileModel *userData = [ProfileModel sharedUser];
    userData.pageCount=@"1";
    userData.currentPage=@"1";
    [userData getImpactPoints:^(ProfileModel *userData) {
        [myDelegate stopIndicator];
        [_profileTableView reloadData];
        //dispaly profile data
    } onfailure:^(NSError *error) {
        
    }];
}

- (void)editUserProfileImage {
    ProfileModel *userData = [ProfileModel sharedUser];
    userData.userImage=userProfileImage;
    [userData updateUserProfileImage:^(ProfileModel *userData) {
        [myDelegate stopIndicator];
        //dispaly profile data
    } onfailure:^(NSError *error) {
        
    }];
}
#pragma mark - end

#pragma mark - Custom picker delegate method
- (void)goNatuurPickerViewDelegateActionIndex:(int)tempSelectedIndex option:(int)option {
    if (option==1) {
        //navigate to screen needed
        if (tempSelectedIndex==0) {
            //chat screen
        }
        else {
            //raise ticket screen
        }
        selectedPickerIndex=tempSelectedIndex;
    }
}
#pragma mark - end

#pragma mark - Table view data source and delgate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return menuItemsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [menuItemsArray objectAtIndex:indexPath.row];
    ProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell displayData:_profileTableView.frame.size];
    [cell.editProfileImage addTarget:self action:@selector(editUserImageAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        return 150;
    }
    else if (indexPath.row==1) {
        return [DynamicHeightWidth getDynamicLabelHeight:[UserDefaultManager getValue:@"emailId"] font:[UIFont montserratLightWithSize:16] widthValue:[[UIScreen mainScreen] bounds].size.width-50 heightValue:60]+10;
    }
    else if (indexPath.row==2) {
        return 80;
    }
    else
    {
        return 50;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==5) {
        [customerSupportPicker showPickerView:customerSupportArray selectedIndex:selectedPickerIndex option:1 isCancelDelegate:false];
    }
}
#pragma mark - end

#pragma mark - IBAction
- (IBAction)editUserImageAction:(UIButton *)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedText(@"TakePhoto")
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedText(@"alertCancel")
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedText(@"Camera"), NSLocalizedText(@"Gallery"), nil];
    [actionSheet showInView:self.view];
}
#pragma mark - end

#pragma mark - Action sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if (buttonIndex==0)
    {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedText(@"error")
                                                                  message:NSLocalizedText(@"noCamera")
                                                                 delegate:nil
                                                        cancelButtonTitle:NSLocalizedText(@"alertOk")
                                                        otherButtonTitles: nil];
            [myAlertView show];
        }
        else
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:NULL];
        }
    }
    if ([buttonTitle isEqualToString:NSLocalizedText(@"Gallery")]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.navigationBar.translucent = NO;
        picker.navigationBar.barTintColor = [UIColor colorWithRed:242.0/255.0 green:233.0/255.0 blue:237.0/255.0 alpha:1];
        picker.navigationBar.tintColor = [UIColor blackColor];
        picker.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor]};
        [self presentViewController:picker animated:YES completion:NULL];
    }
}
#pragma mark - end

#pragma mark - Image picker controller delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)info {
    NSIndexPath *index=[NSIndexPath indexPathForRow:0 inSection:0];
    ProfileTableViewCell * cell = (ProfileTableViewCell *)[_profileTableView cellForRowAtIndexPath:index];
    UIImage *correctOrientationImage = [image fixOrientation];
    cell.userProfileImage.image=correctOrientationImage;
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

@end
