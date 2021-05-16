//
//  NetworkDetailsViewController.m
//  SafeYou
//
//  Created by Garnik Simonyan on 9/11/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "NetworkDetailsViewController.h"
#import "EmergencyServiceDataModel.h"
#import "UserDataModel.h"
#import <GoogleMaps/GoogleMaps.h>
#import "NetworkDetailsCell.h"
#import "EmergencyServicesApi.h"
#import "ServiceContactViewModel.h"
#import "SYProfileService.h"
#import <MessageUI/MessageUI.h>

@interface NetworkDetailsViewController () <UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *serviceNameContainerView;
@property (weak, nonatomic) IBOutlet HyRobotoLabelBold *serviceNameLabel;
@property (weak, nonatomic) IBOutlet HyRobotoLabelRegular *serviceLocationLabel;
@property (weak, nonatomic) IBOutlet SYCorneredButton *addToHelpLineButton;

- (IBAction)addToHelpLineButtonPressed:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet GMSMapView *gMapView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addButtonWidthConstraint;

@property (nonatomic) EmergencyServicesApi *serviceDataApi;
@property (nonatomic) SYProfileService *profileService;

@property (nonatomic) NSArray *dataSource;


@end

@implementation NetworkDetailsViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.serviceDataApi = [[EmergencyServicesApi alloc] init];
        self.profileService = [[SYProfileService alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.extendedLayoutIncludesOpaqueBars = YES;
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
    
    if (self.serviceData.serviceAddress) {
        ServiceContactViewModel *addressViewModel = [[ServiceContactViewModel alloc] init];
        addressViewModel.contactValue = self.serviceData.serviceAddress;
        addressViewModel.contactName = LOC(@"addres");
        addressViewModel.iconURL = self.serviceData.serviceAddressImageURL;
        addressViewModel.actionType = ServiceActionTypeNone;
        [tempArray addObject:addressViewModel];
    }
    
    if (self.serviceData.userDetails.phone) {
        ServiceContactViewModel *phoneViewModel = [[ServiceContactViewModel alloc] init];
        phoneViewModel.contactValue = self.serviceData.userDetails.phone;
        phoneViewModel.contactName = LOC(@"mobile_text_key");
        phoneViewModel.iconURL = self.serviceData.phoneIconURL;
        phoneViewModel.actionType = ServiceActionTypeOpenPhoneURL;
        [tempArray addObject:phoneViewModel];
    }
    
    if (self.serviceData.userDetails.email) {
        ServiceContactViewModel *emailViewModel = [[ServiceContactViewModel alloc] init];
        emailViewModel.contactValue = self.serviceData.userDetails.email;
        emailViewModel.contactName = LOC(@"email_text_key");
        emailViewModel.iconURL = self.serviceData.emailIconURL;
        emailViewModel.actionType = ServiceActionTypeShareItem;
        [tempArray addObject:emailViewModel];
    }
    
    if (self.serviceData.webAddress) {
        ServiceContactViewModel *webSiteViewModel = [[ServiceContactViewModel alloc] init];
        webSiteViewModel.contactValue = self.serviceData.webAddress;
        webSiteViewModel.contactName = LOC(@"web_address_text_key");
        webSiteViewModel.iconURL = self.serviceData.webAddressIconUrl;
        webSiteViewModel.actionType = ServiceActionTypeOpenURL;
        [tempArray addObject:webSiteViewModel];
    }
    
    if (self.serviceData.serviceFacebookPageURL) {
        ServiceContactViewModel *facebookPageViewModel = [[ServiceContactViewModel alloc] init];
        facebookPageViewModel.contactValue = self.serviceData.serviceFacebookPageURL;
        facebookPageViewModel.contactName = self.serviceData.serviceFacebookPageTitle;
        facebookPageViewModel.iconURL = self.serviceData.serviceFacebookIconURL;
        facebookPageViewModel.actionType = ServiceActionTypeOpenURL;
        [tempArray addObject:facebookPageViewModel];
    }
    
    if (self.serviceData.serviceInstagramPageURL) {
        ServiceContactViewModel *instaPageViewModel = [[ServiceContactViewModel alloc] init];
        instaPageViewModel.contactValue = self.serviceData.serviceInstagramPageURL;
        instaPageViewModel.contactName = self.serviceData.serviceInstagramPageTitle;
        instaPageViewModel.iconURL = self.serviceData.serviceInstagramIconURL;
        instaPageViewModel.actionType = ServiceActionTypeOpenURL;
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
    NetworkDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NetworkDetailsCell"];
    ServiceContactViewModel *currentViewData = self.dataSource[indexPath.row];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ServiceContactViewModel *selectedField = self.dataSource[indexPath.row];
    if (selectedField.actionType == ServiceActionTypeOpenPhoneURL) {
        NSString *phoneNumber = [NSString stringWithFormat:@"tel://%@", selectedField.contactValue];
        NSURL *phoneNumberUrl = [NSURL URLWithString:phoneNumber];
        if ([[UIApplication sharedApplication] canOpenURL:phoneNumberUrl]) {
            [[UIApplication sharedApplication] openURL:phoneNumberUrl options:@{UIApplicationOpenURLOptionUniversalLinksOnly:@(NO)} completionHandler:^(BOOL success) {
                
            }];
        }
    }
    
    if (selectedField.actionType == ServiceActionTypeShareItem) {
        // email
        [self showShareItems];
    }
    
    if (selectedField.actionType == ServiceActionTypeOpenURL) {
        // web address
        NSString *webAddress = selectedField.contactValue;
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

#pragma mark - Configure Views

- (void)configureViewsWithData
{
    self.serviceNameLabel.text = self.serviceData.userDetails.firstName;
    self.serviceLocationLabel.text = self.serviceData.userDetails.location;
    [self configureAddButtonState];
}

- (void)configureAddButtonState
{
    if (self.serviceData.isAvailableForEmergency) {
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
        self.addButtonWidthConstraint.constant = 0;
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
        [Settings sharedInstance].onlineUser = userData;
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

@end
