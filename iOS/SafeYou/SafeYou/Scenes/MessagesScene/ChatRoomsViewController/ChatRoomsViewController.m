//
//  ChatRoomsViewController.m
//  SafeYou
//
//  Created by Garnik Simonyan on 11/23/21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import "ChatRoomsViewController.h"
#import "ChatRoomTableViewCell.h"
#import "SocketIOManager.h"
#import "SocketIOAPIService.h"
#import "ChatRoomTableViewCell.h"
#import "PrivateChatRoomViewController.h"
#import "MainTabbarController.h"
#import "RoomDataModel.h"

@interface ChatRoomsViewController () <UITableViewDelegate, UITableViewDataSource, SocketIOManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) SocketIOAPIService *socketAPIService;
@property (nonatomic) NSArray *roomsList;

@end

@implementation ChatRoomsViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.socketAPIService = [[SocketIOAPIService alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self getPrivateRooms];
}

#pragma mark - Get My Rooms

- (void)getPrivateRooms
{
    [self showLoader];
    weakify(self);
    [self.socketAPIService getRoomsForType:RoomTypePrivateOnToOne success:^(NSArray <RoomDataModel *> * _Nonnull roomsList) {
        strongify(self);
        [self hideLoader];
        self.roomsList = roomsList;
        [self.tableView reloadData];
        [self listenSocketIOManagerUpdates];
    } failure:^(NSError * _Nonnull error) {
        [self hideLoader];
    }];
}

#pragma mark - Translations

- (void)updateLocalizations
{
    self.title = LOC(@"messages");
}

#pragma mark - UItableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.roomsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RoomDataModel *roomData = self.roomsList[indexPath.row];
    ChatRoomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatRoomTableViewCell"];
    [cell configureWithData:roomData];
    return cell;
}

#pragma SocketIOManager Signals

- (void)listenSocketIOManagerUpdates
{
    weakify(self);
    [[SocketIOManager sharedInstance].socketClient on:@"signal" callback:^(NSArray* data, SocketAckEmitter* ack) {
        strongify(self);
        if ([data[0] integerValue] == SocketIOSignalRoomINSERT) { // SIGNAL_PROFILE = 0
            NSDictionary *receivedDataDict = data[1];
            NSDictionary *roomDataDict = receivedDataDict[@"data"];
            RoomDataModel *insertingRoomData = [RoomDataModel modelObjectWithDictionary:roomDataDict];
            NSMutableArray *tempDataSource = [self.roomsList mutableCopy];
            [tempDataSource insertObject:insertingRoomData atIndex:0];
            [self.tableView reloadData];
        }
    }];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // show chat room
    RoomDataModel *selectedRoomData = self.roomsList[indexPath.row];
    [self performSegueWithIdentifier:@"showChatView" sender:selectedRoomData];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showChatView"]) {
        PrivateChatRoomViewController *destinationVC = segue.destinationViewController;
        destinationVC.roomData = sender;
    }
}

@end
