//
//  NGODetailsViewController.m
//  SafeYou
//
//  Created by Garnik Simonyan on 9/11/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "NGODetailsViewController.h"
#import "EmergencyServiceDataModel.h"
#import "UserDataModel.h"
#import <GoogleMaps/GoogleMaps.h>
#import "NGODetailsContactCell.h"
#import "EmergencyServicesApi.h"
#import "NGOContactViewModel.h"
#import "SYProfileService.h"
#import <MessageUI/MessageUI.h>
#import "NGOAvatarCellViewModel.h"
#import "NGOAvatarTableViewCell.h"
#import "ImageDataModel.h"
#import "ChatUserDataModel.h"
#import "SocketIOAPIService.h"
#import "PrivateChatRoomViewController.h"

@interface NGODetailsViewController () <UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate, NGOAvatarTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UIView *serviceNameContainerView;
@property (weak, nonatomic) IBOutlet SYCorneredButton *addToHelpLineButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet GMSMapView *gMapView;

- (IBAction)addToHelpLineButtonPressed:(UIButton *)sender;

@property (nonatomic) EmergencyServicesApi *serviceDataApi;
@property (nonatomic) SYProfileService *profileService;
@property (nonatomic) NSArray *dataSource;

@property (nonatomic) SocketIOAPIService *socketAPIService;

@end

@implementation NGODetailsViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.serviceDataApi = [[EmergencyServicesApi alloc] init];
        self.profileService = [[SYProfileService alloc] init];
        self.socketAPIService = [[SocketIOAPIService alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.extendedLayoutIncludesOpaqueBars = YES;
    UINib *networkItemCellNib = [UINib nibWithNibName:@"NGOAvatarTableViewCell" bundle:nil];
    [self.tableView registerNib:networkItemCellNib forCellReuseIdentifier:@"NGOAvatarTableViewCell"];
    self.tableView.separatorColor = [UIColor mainTintColor1];
    [self showLoader];
    weakify(self);
    [self.serviceDataApi getEmergencyServicesById:self.serviceData.serviceId type:@"" complition:^(EmergencyServiceDataModel * _Nonnull serviceData) {
        strongify(self);
        [self hideLoader];
        self.serviceData = serviceData;
        [self configureDataSource];
        [self.tableView reloadData];
    } failure:^(NSError * _Nullable error) {
        strongify(self);
        [self hideLoader];
        [self configureDataSource];
        [self.tableView reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configureViewsWithData];
    [self configurePlacesOnMap];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)configurePlacesOnMap
{
    CGFloat latitude = [self.serviceData.latitude floatValue];
    CGFloat longitude = [self.serviceData.longitude floatValue];
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.snippet = self.serviceData.serviceType;
    marker.position = CLLocationCoordinate2DMake(latitude,longitude);
    marker.map = self.gMapView;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude
    longitude:longitude
         zoom:9];
    
    [self.gMapView setCamera:camera];
}

#pragma mark - ConfigureDataSource

- (void)configureDataSource
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    if (self.serviceData.name.length) {
        NGOAvatarCellViewModel *avatarViewModel = [[NGOAvatarCellViewModel alloc] init];
        avatarViewModel.title = self.serviceData.name;
        avatarViewModel.logoURL = [self.serviceData.image imageFullURL];
        [tempArray addObject:avatarViewModel];
    }
    
    if (self.serviceData.infoText.length) {
        NGOContactViewModel *infoViewModel = [[NGOContactViewModel alloc] init];
        infoViewModel.textValue = self.serviceData.infoText;
        infoViewModel.title = LOC(@"address");
        infoViewModel.iconURL = self.serviceData.serviceAddressImageURL;
        infoViewModel.icon = [UIImage imageNamed:@"info_icon"];
        infoViewModel.actionType = NGOActionTypeNone;
        [tempArray addObject:infoViewModel];
    }
    
    if (self.serviceData.serviceAddress) {
        NGOContactViewModel *addressViewModel = [[NGOContactViewModel alloc] init];
        addressViewModel.textValue = self.serviceData.serviceAddress;
        addressViewModel.title = LOC(@"address");
        addressViewModel.iconURL = self.serviceData.serviceAddressImageURL;
        addressViewModel.icon = [UIImage imageNamed:@"location_icon"];
        addressViewModel.actionType = NGOActionTypeNone;
        [tempArray addObject:addressViewModel];
    }
    
    if (self.serviceData.phoneNumber) {
        NGOContactViewModel *phoneViewModel = [[NGOContactViewModel alloc] init];
        phoneViewModel.textValue = self.serviceData.phoneNumber;
        phoneViewModel.title = LOC(@"mobile_text_key");
        phoneViewModel.iconURL = self.serviceData.phoneIconURL;
        phoneViewModel.icon = [UIImage imageNamed:@"phone_icon"];
        phoneViewModel.actionType = NGOActionTypeOpenPhoneURL;
        [tempArray addObject:phoneViewModel];
    }
    
    if (self.serviceData.email) {
        NGOContactViewModel *emailViewModel = [[NGOContactViewModel alloc] init];
        emailViewModel.textValue = self.serviceData.email;
        emailViewModel.title = LOC(@"email_text_key");
        emailViewModel.iconURL = self.serviceData.emailIconURL;
        emailViewModel.icon = [UIImage imageNamed:@"email_icon"];
        emailViewModel.actionType = NGOActionTypeSendEmail;
        [tempArray addObject:emailViewModel];
    }
    
    if (self.serviceData.webAddress) {
        NGOContactViewModel *webSiteViewModel = [[NGOContactViewModel alloc] init];
        webSiteViewModel.textValue = self.serviceData.webAddress;
        webSiteViewModel.title = LOC(@"web_address_text_key");
        webSiteViewModel.iconURL = self.serviceData.webAddressIconUrl;
        webSiteViewModel.icon = [UIImage imageNamed:@"website_globe_icon"];
        webSiteViewModel.actionType = NGOActionTypeOpenURL;
        [tempArray addObject:webSiteViewModel];
    }
    
    if (self.serviceData.serviceFacebookPageURL) {
        NGOContactViewModel *facebookPageViewModel = [[NGOContactViewModel alloc] init];
        facebookPageViewModel.textValue = self.serviceData.serviceFacebookPageURL;
        facebookPageViewModel.title = self.serviceData.serviceFacebookPageTitle;
        facebookPageViewModel.iconURL = self.serviceData.serviceFacebookIconURL;
        facebookPageViewModel.icon = [UIImage imageNamed:@"facebook_icon"];
        facebookPageViewModel.actionType = NGOActionTypeOpenURL;
        [tempArray addObject:facebookPageViewModel];
    }
    
    if (self.serviceData.serviceInstagramPageURL) {
        NGOContactViewModel *instaPageViewModel = [[NGOContactViewModel alloc] init];
        instaPageViewModel.textValue = self.serviceData.serviceInstagramPageURL;
        instaPageViewModel.title = self.serviceData.serviceInstagramPageTitle;
        instaPageViewModel.iconURL = self.serviceData.serviceInstagramIconURL;
        instaPageViewModel.icon = [UIImage imageNamed:@"instagram_icon"];
        instaPageViewModel.actionType = NGOActionTypeOpenURL;
        [tempArray addObject:instaPageViewModel];
    }
    
    self.dataSource = [tempArray copy];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        NGOAvatarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NGOAvatarTableViewCell"];
        NGOAvatarCellViewModel *currentViewData = self.dataSource[indexPath.row];
        cell.delegate = self;
        [cell configureCell:currentViewData hideChatButton:self.hideChatButton];
        return cell;
    }
    NGODetailsContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NGODetailsContactCell"];
    NGOContactViewModel *currentViewData = self.dataSource[indexPath.row];
    [cell configureWithViewModel:currentViewData];
    
    return cell;
}

- (void)showShareItems
{
    NSArray *activityItems = @[@""];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    
    activityViewController.excludedActivityTypes = @[UIActivityTypePostToFacebook,
        UIActivityTypePostToTwitter,
        UIActivityTypePostToWeibo,
        UIActivityTypeMessage,
        UIActivityTypePrint,
        UIActivityTypeCopyToPasteboard,
        UIActivityTypeAssignToContact,
        UIActivityTypeSaveToCameraRoll,
        UIActivityTypeAddToReadingList,
        UIActivityTypePostToFlickr,
        UIActivityTypePostToVimeo,
        UIActivityTypePostToTencentWeibo,
        UIActivityTypeAirDrop,
        UIActivityTypeOpenInIBooks,
        UIActivityTypeMarkupAsPDF,
    ];
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}

-(void)launchMailAppOnDevice
{
    NSString *recipients = [NSString stringWithFormat:@"mailto:%@?subject=From SafeYou App iOS", self.serviceData.email];

    NSString *email = [NSString stringWithFormat:@"%@", recipients];
//    email = [email stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email] options:@{}  completionHandler:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataSource[indexPath.row] isKindOfClass:[NGOContactViewModel class]]) {
        NGOContactViewModel *selectedField = self.dataSource[indexPath.row];
        if (selectedField.actionType == NGOActionTypeOpenPhoneURL) {
            NSString *phoneNumber = [NSString stringWithFormat:@"tel://%@", selectedField.textValue];
            NSURL *phoneNumberUrl = [NSURL URLWithString:phoneNumber];
            if ([[UIApplication sharedApplication] canOpenURL:phoneNumberUrl]) {
                [[UIApplication sharedApplication] openURL:phoneNumberUrl options:@{UIApplicationOpenURLOptionUniversalLinksOnly:@(NO)} completionHandler:^(BOOL success) {
                }];
            }
        }

        if (selectedField.actionType == NGOActionTypeShareItem) {
            [self showShareItems];
        }
        if (selectedField.actionType == NGOActionTypeSendEmail) {
            // email
            [self launchMailAppOnDevice];
        }

        if (selectedField.actionType == NGOActionTypeOpenURL) {
            // web address
            NSString *webAddress = selectedField.textValue;
            if (!([webAddress hasPrefix:@"http://"] || [webAddress hasPrefix:@"https://"])) {
                webAddress = [NSString stringWithFormat:@"http://%@",webAddress];
            }
            NSURL *webAddressURL = [NSURL URLWithString:webAddress];
            if ([[UIApplication sharedApplication] canOpenURL:webAddressURL]) {
                [[UIApplication sharedApplication] openURL:webAddressURL options:@{UIApplicationOpenURLOptionUniversalLinksOnly:@(NO)} completionHandler:^(BOOL success) {
                }];
            } else {
                [self showAlertViewWithTitle:LOC(@"error_text_key") withMessage:LOC(@"wrong_url_text_key") cancelButtonTitle:LOC(@"ok") okButtonTitle:nil cancelAction:nil okAction:nil];
            }
        }
    }
}

#pragma mark - Configure Views

- (void)configureViewsWithData
{
    [self configureAddButtonState];
}

- (void)configureAddButtonState
{
    if (self.serviceData.isAvailableForEmergency) {
        self.addToHelpLineButton.enabled = YES;
        self.addToHelpLineButton.hidden = NO;
        BOOL isAdded = [[Settings sharedInstance].onlineUser containsService:self.serviceData.serviceId];
        if (isAdded) {
            self.addToHelpLineButton.selected = YES;
            [self.addToHelpLineButton setTitle:LOC(@"remove_from_helpline_title_key") forState:UIControlStateNormal];
        } else {
            self.addToHelpLineButton.selected = NO;
            [self.addToHelpLineButton setTitle:LOC(@"add_to_helpline_title_key") forState:UIControlStateNormal];
        }
    } else {
        self.addToHelpLineButton.enabled = NO;
        self.addToHelpLineButton.hidden = YES;
    }
}

#pragma mark - Helper

- (IBAction)addToHelpLineButtonPressed:(UIButton *)sender {
    BOOL isAdded = [[Settings sharedInstance].onlineUser containsService:self.serviceData.serviceId];
    if (isAdded) {
        weakify(self)
        [self showLoader];
        EmergencyServiceDataModel *selectedService = [[Settings sharedInstance].onlineUser userServiceForServiceId:self.serviceData.serviceId];
        [self.profileService deleteEmergencyServiceContact:[NSString stringWithFormat:@"%@", selectedService.userEmergencyServiceId] withComplition:^(id response) {
            strongify(self)
            [self refreshUserData:YES];
        } failure:^(NSError *error) {
            [self hideLoader];
        }];
    } else {
        if (self.updatedingServiceId) {
            weakify(self);
            [self showLoader];
            [self.profileService updateEmergencyServiceContact:self.updatedingServiceId withServiceId:self.serviceData.serviceId withComplition:^(id response) {
                strongify(self)
                [self refreshUserData:YES];
            } failure:^(NSError *error) {
                strongify(self)
                [self hideLoader];
            }];
            self.updatedingServiceId = nil;
        } else {
            if ([Settings sharedInstance].onlineUser.emergencyServices.count < 3) {
                weakify(self);
                [self showLoader];
                [self.profileService addEmergencyService:self.serviceData.serviceId withComplition:^(id response) {
                    strongify(self)
                    [self refreshUserData:YES];
                } failure:^(NSError *error) {
                    strongify(self)
                    [self hideLoader];
                }];
            } else {
                [self showAlertViewWithTitle:LOC(@"info_text_key") withMessage:LOC(@"all_services_are_added_text_key") cancelButtonTitle:LOC(@"ok") okButtonTitle:nil cancelAction:nil okAction:nil];
            }
        }
    }
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


//@TODO: Dublicate code not time
- (void)refreshUserData:(BOOL)withLoader
{
    weakify(self);
    [self.profileService getUserDataWithComplition:^(UserDataModel *userData) {
        strongify(self);
        [self configureAddButtonState];
        if (withLoader) {
            [self hideLoader];
        }
        if (self.isFromMyProfil) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    } failure:^(NSError *error) {
        strongify(self);
        NSLog(@"Error");
        if (withLoader) {
            [self hideLoader];
        }
        if (self.isFromMyProfil) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

#pragma mark - NGOAvatarTableViewCellDelegate

- (void)ngoAvatarCellDidPressPrivateChat
{
    ChatUserDataModel *chatUser = [[ChatUserDataModel alloc] init];
    chatUser.userId = @([self.serviceData.serviceId integerValue]);
    [self startChatWithUser:chatUser];
}

#pragma mark - Start Chat

- (void)startChatWithUser:(ChatUserDataModel *)chatUserData
{
    [self showLoader];
    weakify(self);
    [self.socketAPIService joinToPrivateRoomWithUser:chatUserData success:^(RoomDataModel * roomData) {
        strongify(self);
        [self hideLoader];
        [self showPrivateChatView:roomData];
    } failure:^(NSError * _Nonnull error) {
        strongify(self);
        [self hideLoader];
    }];
}

- (void)showPrivateChatView:(RoomDataModel *)roomData
{
    [self performSegueWithIdentifier:@"showPrivateChatFromNetworkDetailsView" sender:roomData];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showPrivateChatFromNetworkDetailsView"]) {
        PrivateChatRoomViewController *destinationVC = segue.destinationViewController;
        destinationVC.roomData = sender;
    }
}

@end
