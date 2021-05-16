//
//  NetworkListViewController.m
//  SafeYou
//
//  Created by Garnik Simonyan on 9/11/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "NetworkListViewController.h"
#import "EmergencyServicesApi.h"
#import "EmergencyServiceDataModel.h"
#import "EmergencyServicesListDataModel.h"
#import "NetworkItemTableViewCell.h"
#import "NetworkDetailsViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <MapKit/MapKit.h>
#import "ServiceSearchResult.h"
#import <MessageUI/MessageUI.h>
#import "UserDataModels.h"
#import "ServiceCategoryDataModel.h"


typedef NS_ENUM(NSUInteger, FilterType) {
    FilterTypeAll,
    FilterTypeNGO,
    FilterTypeVolunteer,
    FilterTypeLegalService
};

@interface NetworkListViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, NetworkItemTableViewCellDelegae, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIStackView *categoriesStackView;
@property (weak, nonatomic) IBOutlet UIView *mapContainerView;
@property (weak, nonatomic) IBOutlet GMSMapView *gMapView;

@property (nonatomic) BOOL isSearchActive;
@property (nonatomic) UISearchBar *searchBar;


@property (nonatomic) FilterType currentFilterType;

@property (nonatomic) EmergencyServicesApi *emergnenscyServicesApi;

@property (nonatomic) NSArray *dataSource;
@property (nonatomic) NSArray *originalDataSource;
@property (nonatomic) NSArray *serviceCategoriesList;
@property (nonatomic) NSMutableArray *categoriesButtonsArray;

@property (nonatomic) EmergencyServicesListDataModel *allServicesListDataModel;

@end

@implementation NetworkListViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.originalDataSource = [[NSMutableArray alloc] init];
        self.dataSource = [[NSMutableArray alloc] init];
        self.categoriesButtonsArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.emergnenscyServicesApi = [[EmergencyServicesApi alloc] initWithEmergency:self.isFromMyProfil];
    // Do any additional setup after loading the view.
    
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.currentFilterType = FilterTypeAll;
    
    [self configureSearchBar];
    self.title = LOC(@"network_title");
    [self fetchServiceCategories];
    
    self.tableView.estimatedRowHeight = 100.5;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showNotificationsBarButtonitem:NO];
    if (self.isFromMyProfil) {
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close"] style:UIBarButtonItemStylePlain target:self action:@selector(close:)];
        leftBarButtonItem.tintColor = [UIColor whiteColor];
        self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    }
}


#pragma mark - Configure View Elements
- (void)configureSearchBar
{
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    self.searchBar.showsCancelButton = (self.navigationController.presentingViewController !=nil);
    self.searchBar.delegate = self;
    self.searchBar.layer.cornerRadius = 15.0;
    self.searchBar.clipsToBounds = YES;
    self.searchBar.tintColor = [UIColor whiteColor];
    if (@available(iOS 13, *)) {
        self.searchBar.searchTextField.backgroundColor = [UIColor mainTintColor3];
    }
    self.navigationItem.titleView = self.searchBar;
}

- (void)configureCategoriesView
{
    [self clearCategoryStackView];
    UIEdgeInsets buttonInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    SYCorneredButton *allCategoriesButton = [[SYCorneredButton alloc] init];
    allCategoriesButton.titleColorType = SYColorTypeMain1;
    allCategoriesButton.borderColorType = SYColorTypeMain1;
    allCategoriesButton.borderWidth = 1.0;
    allCategoriesButton.contentEdgeInsets = buttonInsets;
    [allCategoriesButton.heightAnchor constraintEqualToConstant:40].active = true;
    [allCategoriesButton.widthAnchor constraintGreaterThanOrEqualToConstant:40].active = true;
    [allCategoriesButton setTitle:LOC(@"title_all") forState:UIControlStateNormal];
    [allCategoriesButton addTarget:self action:@selector(categorybuttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.categoriesButtonsArray addObject:allCategoriesButton];
    [self.categoriesStackView addArrangedSubview:allCategoriesButton];
    
    for (ServiceCategoryDataModel *categoryData in self.serviceCategoriesList) {
        SYCorneredButton *categoryButton = [[SYCorneredButton alloc] init];
        categoryButton.contentEdgeInsets = buttonInsets;
        categoryButton.borderWidth = 1.0;
        [categoryButton setTitle:categoryData.categoryName forState:UIControlStateNormal];
        categoryButton.titleColorType = SYColorTypeMain1;
        categoryButton.borderColorType = SYColorTypeMain1;
        [categoryButton sizeToFit];
        [self.categoriesStackView addArrangedSubview:categoryButton];
        [categoryButton addTarget:self action:@selector(categorybuttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [categoryButton.heightAnchor constraintEqualToConstant:40].active = true;
        [categoryButton.widthAnchor constraintGreaterThanOrEqualToConstant:40].active = true;
        [self.categoriesButtonsArray addObject:categoryButton];
    }
    
    allCategoriesButton.selected = YES;
}

- (void)clearCategoryStackView
{
    if (self.categoriesStackView.arrangedSubviews.count) {
        for (UIView *subview in self.categoriesStackView.arrangedSubviews) {
            [subview removeFromSuperview];
        }
    }
}

#pragma mark - Setter/Getter

- (NSArray *)originalDataSource
{
    return self.allServicesListDataModel.emergnecyServices;
}

#pragma mark - Filter

- (void)setCurrentFilterType:(FilterType)currentFilterType
{
    NSString *filterKey;
    _currentFilterType = currentFilterType;
    switch (_currentFilterType) {
        case FilterTypeAll:
            filterKey = @"";
            break;
        case FilterTypeNGO:
            filterKey = [EmergencyServicesListDataModel serviceType].ngo;
            
            break;
        case FilterTypeVolunteer:
            filterKey = [EmergencyServicesListDataModel serviceType].volunteer;
            
            break;
            
        case FilterTypeLegalService:
            filterKey = [EmergencyServicesListDataModel serviceType].legalService;
            
            break;
            
        default:
            filterKey = @"";
            break;
    }
    
    if (filterKey.length > 0) {
        NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"serviceType=%@", filterKey];
        NSArray *filteredArray = [self.originalDataSource filteredArrayUsingPredicate:filterPredicate];
        self.dataSource = [filteredArray mutableCopy];
    } else {
        self.dataSource = self.originalDataSource;
    }
    [self.tableView reloadData];
}

- (void)configureServicePlaces
{
    NSMutableArray *markers = [[NSMutableArray alloc] init];
    for (EmergencyServiceDataModel *serviceData in self.dataSource) {
        CGFloat latitude = [serviceData.latitude floatValue];
        CGFloat longitude = [serviceData.longitude floatValue];
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.snippet = serviceData.serviceType;
        marker.position = CLLocationCoordinate2DMake(latitude,longitude);
        marker.map = self.gMapView;
        [markers addObject:marker];
    }
    
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] init];
    for (GMSMarker *marker in markers) {
        bounds = [bounds includingCoordinate:marker.position];
    }
    
    if (markers.count == 1) {
        EmergencyServiceDataModel *serviceData = self.dataSource.firstObject;
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[serviceData.latitude floatValue] longitude:[serviceData.longitude floatValue] zoom:9];
        [self.gMapView setCamera:camera];
    } else {
        [self.gMapView animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds withPadding:30.0f]];
    }
}

#pragma mark - Fetch Data From API

- (void)fetchData
{
    weakify(self);
    [self showLoader];
    [self.emergnenscyServicesApi getEmergencyServicesWithComplition:^(EmergencyServicesListDataModel *emergencySerivcesList) {
        strongify(self);
        self.allServicesListDataModel = emergencySerivcesList;
        self.dataSource = self.originalDataSource;
        [self.tableView reloadData];
        [self configureServicePlaces];
        [self hideLoader];
    } failure:^(NSError *error) {
        [self.tableView reloadData];
        [self hideLoader];
    }];
}

- (void)fetchServiceCategories
{
    [self showLoader];
    weakify(self);
    [self.emergnenscyServicesApi getEmergencyServicesCategoriesWithComplition:^(NSArray <ServiceCategoryDataModel*> *emergencySerivcesCategoryList) {
        strongify(self);
        self.serviceCategoriesList = emergencySerivcesCategoryList;
        [self hideLoader];
        [self fetchData];
        [self configureCategoriesView];
    } failure:^(NSError *error) {
        strongify(self);
        [self hideLoader];
    }];
}

- (void)fetchDataWithSearchString:(NSString *)searchString
{
    weakify(self);
    [self showLoader];
    [self.emergnenscyServicesApi getEmergencyServicesWithSearchString:searchString complition:^(NSArray <ServiceSearchResult *> *searchResult) {
        strongify(self);
        self.dataSource = [searchResult mutableCopy];
        
        [self.tableView reloadData];
        [self hideLoader];
    } failure:^(NSError *error) {
        [self.tableView reloadData];
        [self hideLoader];
    }];
}

#pragma mark - NetworkItemTableViewCellDelegae

- (void)networkItemCellDidPressPhoneButton:(NetworkItemTableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    EmergencyServiceDataModel *selectedData = self.dataSource[indexPath.row];
    NSString *phoneNumber = [NSString stringWithFormat:@"tel://%@",selectedData.userDetails.phone];
    
    NSURL *phoneNumberUrl = [NSURL URLWithString:phoneNumber];
    if ([[UIApplication sharedApplication] canOpenURL:phoneNumberUrl]) {
        [[UIApplication sharedApplication] openURL:phoneNumberUrl options:nil completionHandler:nil];
    }
}

- (void)networkItemCellDidPressMailButton:(NetworkItemTableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    EmergencyServiceDataModel *selectedData = self.dataSource[indexPath.row];
    NSString *email = selectedData.userDetails.email;
    [self showShareItems];
    return;
    
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;

        [mailCont setSubject:@"Help Me"];
        [mailCont setToRecipients:[NSArray arrayWithObject:email]];
        [mailCont setMessageBody:[Settings sharedInstance].onlineUser.emergencyMessage isHTML:NO];
        [self presentViewController:mailCont animated:YES completion:nil];
    } else {
        [self showAlertViewWithTitle:LOC(@"error_text_key") withMessage:LOC(@"no_mail_account_registered") cancelButtonTitle:LOC(@"ok") okButtonTitle:nil cancelAction:nil okAction:nil];
    }
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

// Then implement the delegate method
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:nil];

}

#pragma mark - Localizations

- (void)updateLocalizations
{
    self.title = LOC(@"network_title");
    self.tabBarItem.title = LOC(@"network_title");
}

- (void)appLanguageDidChange:(NSNotification *)notification
{
    [super appLanguageDidChange:notification];
    [self fetchServiceCategories];
}

#pragma mark - Actions

- (void)close:(id)sender
{
    if (self.isFromMyProfil && self.navigationController.presentingViewController) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)categorybuttonAction:(SYCorneredButton *)sender {
    NSLog(@"Button pressed");
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    self.isSearchActive = NO;
    
    for (SYCorneredButton *filterButton in self.categoriesButtonsArray) {
        [filterButton setSelected:NO];
    }
    [sender setSelected:YES];
    
    NSInteger selectedButtonIndex = [self.categoriesButtonsArray indexOfObject:sender];
    
    if (selectedButtonIndex == 0) {
        // handle all action
        NSLog(@"All categories selected");
        self.dataSource = self.originalDataSource;
    } else {
        --selectedButtonIndex;
        ServiceCategoryDataModel *selectedCategory = [self.serviceCategoriesList objectAtIndex:selectedButtonIndex];
        NSLog(@"SelectedCategory %@", selectedCategory);
        self.dataSource = [self.allServicesListDataModel servicesForcategoryId:selectedCategory.categoryId];
    }
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isSearchActive) {
        ServiceSearchResult *searchResult = self.dataSource[indexPath.row];
        [self showLoader];
        weakify(self);
        [self.emergnenscyServicesApi getEmergencyServicesById:searchResult.serviceId type:searchResult.serviceType complition:^(EmergencyServiceDataModel *serviceData) {
            strongify(self);
            [self hideLoader];
            [self performSegueWithIdentifier:@"showServiceDetails" sender:serviceData];
        } failure:^(NSError *error) {
            strongify(self)
            [self hideLoader];
        }];
        
    } else {
        EmergencyServiceDataModel *selectedService = self.dataSource[indexPath.row];
        [self performSegueWithIdentifier:@"showServiceDetails" sender:selectedService];
    }
}

#pragma mark - Select Service

- (void)selectService:(EmergencyServiceDataModel *)emergencyService
{
    if (self.navigationController.presentingViewController) {
        // callback selection
        if ([self.delegate respondsToSelector:@selector(networkList:didSelectService:)]) {
            [self.delegate networkList:self didSelectService:emergencyService];
        }
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        // show details
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length > 2) {
        [self fetchDataWithSearchString:searchText];
    } else if (searchText.length == 0) {
        self.dataSource = [@[] mutableCopy];
        [self.tableView reloadData];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    self.tableView.tableHeaderView.hidden = YES;
    CGRect frame = self.tableView.tableHeaderView.frame;
    frame.size.height = 0;
    self.tableView.tableHeaderView.frame = frame;
    self.tableView.tableHeaderView = self.tableView.tableHeaderView;
    self.dataSource = [@[] mutableCopy];
    [self.tableView reloadData];
    
    searchBar.showsCancelButton = YES;
    self.isSearchActive = YES;
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    self.isSearchActive = NO;
    
    self.tableView.tableHeaderView.hidden = NO;
    CGRect frame = self.tableView.tableHeaderView.frame;
    frame.size.height = 203;
    self.tableView.tableHeaderView.frame = frame;
    self.tableView.tableHeaderView = self.tableView.tableHeaderView;
    self.dataSource = self.originalDataSource;
    [self.tableView reloadData];
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    searchBar.showsCancelButton = NO;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isSearchActive) {
        NetworkItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchResultCell"];
        ServiceSearchResult *searchResulInstance = self.dataSource[indexPath.row];
        [cell configureWithSearchSuggestion:searchResulInstance.name];
        return cell;
    } else {
        NetworkItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NetworkItemTableViewCell"];
        EmergencyServiceDataModel *serviceItem = self.dataSource[indexPath.row];
        cell.delegate = self;
        [cell configureWithEmergencyServiceData:serviceItem];
        return cell;
    }
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showServiceDetails"]) {
        NetworkDetailsViewController *destinationVC = segue.destinationViewController;
        destinationVC.isFromMyProfil = self.isFromMyProfil;
        destinationVC.serviceData = (EmergencyServiceDataModel *)sender;
        if (self.updatedingServiceId) {
            destinationVC.updatedingServiceId = self.updatedingServiceId;
        }
    }
}

@end
