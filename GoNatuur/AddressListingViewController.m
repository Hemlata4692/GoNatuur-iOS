//
//  AddressListingViewController.m
//  GoNatuur
//
//  Created by Monika on 9/4/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "AddressListingViewController.h"
#import "AddressViewController.h"
#import "AddressListingCell.h"
#import "DynamicHeightWidth.h"
#import "UIImage+UIImage_fixOrientation.h"

@interface AddressListingViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
@private
    NSArray *addressArray;
    UIImage *userProfileImage;
    BOOL isImagePicker;
}
@property (weak, nonatomic) IBOutlet UIButton *addAddressButton;
@property (weak, nonatomic) IBOutlet UITableView *addressTableView;
@end

@implementation AddressListingViewController
@synthesize profileData;
@synthesize checkoutAddressViewObj;

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    isImagePicker=false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.title=NSLocalizedText(@"personalDetails");
    self.navigationController.navigationBarHidden=false;
    [self addLeftBarButtonWithImage:true];
    //customisation of change password button
    [_addAddressButton setCornerRadius:17.0];
    [_addAddressButton addShadow:_addAddressButton color:[UIColor blackColor]];
    [_addAddressButton setTitle:NSLocalizedText(@"addAddressButton") forState:UIControlStateNormal];
    if (!isImagePicker) {
        [_addressTableView reloadData];
    }
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)addAddressButtonAction:(id)sender {
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddressViewController * nextView=[sb instantiateViewControllerWithIdentifier:@"AddressViewController"];
    nextView.profileData = profileData;
    nextView.isEditScreen = NO;
    if (nil!=checkoutAddressViewObj) {
        nextView.checkoutAddressViewObj=checkoutAddressViewObj;
    }
    [self.navigationController pushViewController:nextView animated:YES];
}

- (IBAction)editProfileImageAction:(UIButton *)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedText(@"TakePhoto")                                                             delegate:self cancelButtonTitle:NSLocalizedText(@"alertCancel")destructiveButtonTitle:nil otherButtonTitles:NSLocalizedText(@"Camera"), NSLocalizedText(@"Gallery"), nil];
    [actionSheet showInView:self.view];
}

- (IBAction)editUserAddress:(UIButton *)sender {
    long index = [sender tag];
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddressViewController * nextView=[sb instantiateViewControllerWithIdentifier:@"AddressViewController"];
    nextView.profileData = profileData;
    nextView.isEditScreen = YES;
    nextView.addressIndex = [NSNumber numberWithLong:index];
    nextView.addressListView = self;
    [self.navigationController pushViewController:nextView animated:YES];
}

- (IBAction)deleteUserAddress:(UIButton *)sender {
    long index = [sender tag];
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    [alert addButton:NSLocalizedText(@"alertOk") actionBlock:^(void) {
        [myDelegate showIndicator];
        [self performSelector:@selector(deleteAddress:) withObject:[NSNumber numberWithLong:index] afterDelay:.1];
    }];
    [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"deleteAddressMessage") closeButtonTitle:NSLocalizedText(@"alertCancel") duration:0.0f];
}
#pragma mark - end

#pragma mark - Action sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if (buttonIndex==0) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedText(@"error") message:NSLocalizedText(@"noCamera")delegate:nil cancelButtonTitle:NSLocalizedText(@"alertOk")otherButtonTitles: nil];
            [myAlertView show];
        }
        else {
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
    AddressListingCell * cell = (AddressListingCell *)[_addressTableView cellForRowAtIndexPath:index];
    UIImage *correctOrientationImage = [image fixOrientation];
    cell.profileImageView.image=correctOrientationImage;
    isImagePicker=true;
    userProfileImage=cell.profileImageView.image;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [myDelegate showIndicator];
    [self performSelector:@selector(editProfileImage) withObject:nil afterDelay:.1];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark - end

#pragma mark - Table view data source and delgate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (nil!=checkoutAddressViewObj) {
        return checkoutAddressViewObj.cartModelData.customerSavedAddressArray.count+3;
    }
    return profileData.addressArray.count+3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier;
    if (indexPath.row == 0) {
        CellIdentifier = @"profileImageCell";
    } else  if (indexPath.row == 1) {
        CellIdentifier = @"userEmailCell";
    } else  if (indexPath.row == 2) {
        CellIdentifier = @"addressListLabelCell";
    } else  if (indexPath.row > 2) {
        CellIdentifier = @"addressListCell";
    }
    AddressListingCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [cell.editProfileImageButton addTarget:self action:@selector(editProfileImageAction:) forControlEvents:UIControlEventTouchUpInside];
    if (indexPath.row <= 2) {
        [cell displayData:_addressTableView.frame.size];
    } else if (indexPath.row > 2) {
        cell.editAddressButton.tag = indexPath.row-3;
        cell.deleteAddressButton.tag = indexPath.row-3;
        NSDictionary *addressDict = [NSDictionary new];
        if (nil!=checkoutAddressViewObj) {
            addressDict= [checkoutAddressViewObj.cartModelData.customerSavedAddressArray objectAtIndex:indexPath.row-3];
        }
        else {
            addressDict = [profileData.addressArray objectAtIndex:indexPath.row-3];
        }
        
        [cell displayAddressData:_addressTableView.frame.size addressData:addressDict];
        if (nil!=checkoutAddressViewObj) {
            cell.editAddressButton.hidden=true;
            cell.deleteAddressButton.hidden=true;
            //Hide cell separator
            if (indexPath.row == checkoutAddressViewObj.cartModelData.customerSavedAddressArray.count+2) {
                cell.listingSeparatorLabel.hidden = YES;
            } else {
                cell.listingSeparatorLabel.hidden = NO;
            }
        }
        else {
            cell.editAddressButton.hidden=false;
            cell.deleteAddressButton.hidden=false;
            //Hide cell separator
            if (indexPath.row == profileData.addressArray.count+2) {
                cell.listingSeparatorLabel.hidden = YES;
            } else {
                cell.listingSeparatorLabel.hidden = NO;
            }
        }
        [cell.editAddressButton addTarget:self action:@selector(editUserAddress:) forControlEvents:UIControlEventTouchUpInside];
        [cell.deleteAddressButton addTarget:self action:@selector(deleteUserAddress:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        return 140;
    }
    else if (indexPath.row==1) {
        return [DynamicHeightWidth getDynamicLabelHeight:[UserDefaultManager getValue:@"emailId"] font:[UIFont montserratLightWithSize:16] widthValue:[[UIScreen mainScreen] bounds].size.width-50 heightValue:60]+10;
    }
    else if (indexPath.row==2) {
        return 30;
    }
    else {
        NSDictionary *addressData;
        if (nil!=checkoutAddressViewObj) {
            addressData = [checkoutAddressViewObj.cartModelData.customerSavedAddressArray objectAtIndex:indexPath.row-3];
        }
        else {
            addressData = [profileData.addressArray objectAtIndex:indexPath.row-3];
        }
        float newHeight =[DynamicHeightWidth getDynamicLabelHeight:[NSString stringWithFormat:@"%@ %@",addressData[@"firstname"],addressData[@"lastname"]] font:[UIFont montserratRegularWithSize:12] widthValue:_addressTableView.frame.size.width-100 heightValue:500];
        NSString *streetString = [addressData[@"street"] componentsJoinedByString:@","];
        float addressHeight =[DynamicHeightWidth getDynamicLabelHeight:streetString font:[UIFont montserratRegularWithSize:12] widthValue:_addressTableView.frame.size.width-30 heightValue:500];
        
        float secondAddressHeight =[DynamicHeightWidth getDynamicLabelHeight:[NSString stringWithFormat:@"%@ - %@, %@",addressData[@"city"],addressData[@"postcode"],[[addressData objectForKey:@"region"]objectForKey:@"region"]] font:[UIFont montserratRegularWithSize:12] widthValue:_addressTableView.frame.size.width - 100 heightValue:500];
        
        float phoneNumberHeight =[DynamicHeightWidth getDynamicLabelHeight:[NSString stringWithFormat:@"Phone Number: %@",addressData[@"telephone"]] font:[UIFont montserratRegularWithSize:12] widthValue:_addressTableView.frame.size.width - 100 heightValue:500];
        
        NSString *addressType;
        if ([addressData[@"default_billing"]boolValue]==1 && [addressData[@"default_shipping"]boolValue]==1) {
            addressType = NSLocalizedText(@"bothAddressSelected");
        } else if ([addressData[@"default_shipping"]boolValue]==1) {
            addressType = NSLocalizedText(@"shippingAddress");
        } else if ([addressData[@"default_billing"]boolValue]==1) {
            addressType = NSLocalizedText(@"billingAddress");
        } else {
            addressType = @"";
        }
        if ([addressType isEqualToString:@""]) {
            return 35+newHeight+addressHeight+secondAddressHeight+phoneNumberHeight;
            
        } else {
            return 60+newHeight+addressHeight+secondAddressHeight+phoneNumberHeight;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (nil!=checkoutAddressViewObj) {
        NSDictionary *tempDict=[checkoutAddressViewObj.cartModelData.customerSavedAddressArray objectAtIndex:indexPath.row-3];
        NSMutableArray *streetTempArray=[NSMutableArray new];
        for (NSString *street in tempDict[@"street"]) {
            [streetTempArray addObject:street];
        }
        NSDictionary *parameters = @{@"id" : [UserDefaultManager getNumberValue:@"id" dictData:tempDict],
                                     @"region" : [tempDict[@"region"] objectForKey:@"region"],
                                     @"region_id" : [UserDefaultManager getNumberValue:[tempDict objectForKey:@"region_id"] dictData:tempDict],
                                     @"region_code" : [tempDict[@"region"] objectForKey:@"region_code"],
                                     @"country_id" : [UserDefaultManager checkStringNull:@"country_id" dictData:tempDict],
                                     @"company" : [UserDefaultManager checkStringNull:@"company" dictData:tempDict],
                                     @"telephone" : tempDict[@"telephone"],
                                     @"fax" : [UserDefaultManager checkStringNull:@"fax" dictData:tempDict],
                                     @"postcode" : tempDict[@"postcode"],
                                     @"city" : tempDict[@"city"],
                                     @"firstname" : tempDict[@"firstname"],
                                     @"lastname" : tempDict[@"lastname"],
                                     @"email" : [UserDefaultManager getValue:@"emailId"],
                                     @"customer_id": [UserDefaultManager getValue:@"userId"],
                                     @"street":[streetTempArray copy]
                                     };
        if (checkoutAddressViewObj.isBillingAddress) {
            checkoutAddressViewObj.cartModelData.billingAddressDict=[parameters mutableCopy];
        }
        else {
            checkoutAddressViewObj.cartModelData.shippingAddressDict=[parameters mutableCopy];
        }
        checkoutAddressViewObj.isEditService=true;
        [self.navigationController popViewControllerAnimated:true];
        DLog(@"%@",tempDict);
    }
}
#pragma mark - end

#pragma mark - Web services
//Delete address
- (void) deleteAddress:(NSNumber *)index {
    NSLog(@"%lu",[index longValue]);
    ProfileModel *dataModel = [ProfileModel sharedUser];
    [dataModel.addressArray removeObjectAtIndex:[index longValue]];
    dataModel.firstName = profileData.firstName;
    dataModel.lastName = profileData.lastName;
    dataModel.email = profileData.email;
    dataModel.websiteId = profileData.websiteId;
    dataModel.groupId = profileData.groupId;
    dataModel.customAttributeArray = profileData.customAttributeArray;
    [dataModel saveAndUpdateAddress:^(ProfileModel *userData) {
        [myDelegate stopIndicator];
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert addButton:NSLocalizedText(@"alertOk") actionBlock:^(void) {
            [_addressTableView reloadData];
        }];
        [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"deleteAddressSuccess") closeButtonTitle:nil duration:0.0f];
    } onfailure:^(NSError *error) {
        
    }];
}

//edit profile
- (void)editProfileImage {
    ProfileModel *userData = [ProfileModel sharedUser];
    userData.userImage=userProfileImage;
    [userData updateUserProfileImage:^(ProfileModel *userData) {
        [myDelegate stopIndicator];
        isImagePicker=false;
        //dispaly profile data
    } onfailure:^(NSError *error) {
        
    }];
}
#pragma mark - end
@end
