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
#import "PayPalPaymentOption.h"
#import "RedeemViewController.h"

@interface ProfileViewController ()<GoNatuurPickerViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,PayPalPaymentDelegate>{
    NSArray *menuItemsArray, *customerSupportArray;
    GoNatuurPickerView *customerSupportPicker;
    int selectedPickerIndex;
    UIImage *userProfileImage;
    PayPalPaymentOption *payment;
    BOOL isImagePicker;
}
@property (weak, nonatomic) IBOutlet UITableView *profileTableView;
@end

@implementation ProfileViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    menuItemsArray = @[@"profileImageCell", @"userEmailCell", @"impactPointCell", @"redeemPointCell", @"detailCell",@"customerSupportCell", @"changePasswordCell", @"notificationCell"];
    customerSupportArray=@[NSLocalizedText(@"chat"), NSLocalizedText(@"raiseTicket")];
    [self addCustomPickerView];
    isImagePicker=false;
    payment=[[PayPalPaymentOption alloc]init];
    [payment configPaypalPayment:PayPalEnvironmentSandbox];
    
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
    if (!isImagePicker) {
        [_profileTableView reloadData];
    }
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
//Get user impact points
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
        isImagePicker=false;
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
    [cell.notificationSwitch addTarget:self action:@selector(enableDisableNotification:) forControlEvents:UIControlEventValueChanged];
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
    else if (indexPath.row==3) {
        return 60;
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

- (IBAction)redeemPointsButtonAction:(id)sender {
 
    RedeemViewController *obj = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RedeemViewController"];
    obj.visitedFromScreen=@"profile";
    [self.navigationController pushViewController:obj animated:YES];
}

- (IBAction)enableDisableNotification:(id)sender {
    UISwitch *switchStatus = (UISwitch *) sender;
    if (switchStatus.on) {
        [myDelegate registerForRemoteNotification];
    }
    else {
        [myDelegate unregisterForRemoteNotifications];
    }
}
#pragma mark - end

//PayPalPaymentDelegate
#pragma mark - PayPalPaymentDelegate methods
- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
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
    isImagePicker=true;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [myDelegate showIndicator];
    [self performSelector:@selector(editUserProfileImage) withObject:nil afterDelay:.1];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark - end
@end
