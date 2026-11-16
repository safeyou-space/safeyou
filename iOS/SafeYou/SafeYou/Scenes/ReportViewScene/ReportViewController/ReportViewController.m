//
//  ReportViewController.m
//  SafeYou
//
//  Created by Edgar on 23.07.22.
//  Copyright © 2022 Garnik Simonyan. All rights reserved.
//

#import "ReportViewController.h"
#import "ReportCategoriesViewController.h"
#import "SYForumService.h"
#import "ReportCategoryDataModel.h"
#import <SDWebImage.h>

@interface ReportViewController () <ReportCategoriesViewControllerDelegate>

@property (weak, nonatomic) IBOutlet SYDesignableImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet SYDesignableLabel *userNameLabel;
@property (weak, nonatomic) IBOutlet SYDesignableLabel *userRoleLabel;
@property (weak, nonatomic) IBOutlet SYDesignableLabel *commentDateLabel;

@property (weak, nonatomic) IBOutlet SYDesignableLabel *categoryNameLabel;

@property (weak, nonatomic) IBOutlet SYDesignableLabel *commentTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;


@property (weak, nonatomic) IBOutlet SYDesignableLabel *descriptionTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@property (weak, nonatomic) IBOutlet SYDesignableView *commentTextViewContainer;
@property (weak, nonatomic) IBOutlet SYDesignableButton *reportButton;
@property (weak, nonatomic) IBOutlet SYDesignableButton *cancelButton;


@property (nonatomic) SYForumService *forumService;
@property (nonatomic) NSNumber *reportCategoryId;

@end

@implementation ReportViewController

#pragma mark - Override Methods

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.forumService = [[SYForumService alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureTextViews];
    [self configureView];
    [self updateLocalizations];
}

//- (void)viewWillDisappear:(BOOL)animated
//{
//    self.navigationItem.backButtonTitle = @" ";
//    [super viewWillDisappear:animated];
//}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self configureTableHeaderView];
    [self configureHeaderShadow];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self performSegueWithIdentifier:@"reportCategories" sender:nil];
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        [self.descriptionTextView becomeFirstResponder];
    }
}

#pragma mark - Private Methods

- (void)configureView
{
    [self.avatarImageView sd_setImageWithURL:self.comment.sender.avatarUrl];
    self.userNameLabel.text = self.comment.sender.userName;
    if (self.comment.sender.role != ChatUserRoleUser) {
        self.userRoleLabel.text = self.comment.sender.roleLabel.uppercaseString;
    } else {
        self.userRoleLabel.text = @"";
    }
    self.commentTextView.text = self.comment.messageContent;
    self.commentDateLabel.text = self.comment.formattedCreatedDate;
}

- (void)configureTableHeaderView
{
    UIView *headerView = self.tableView.tableHeaderView;
    if(headerView != nil) {
        CGFloat height = [headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        CGRect headerFrame = self.tableView.tableHeaderView.frame;
        if(height != headerFrame.size.height) {
            headerFrame.size.height = height;
            headerView.frame = headerFrame;
            self.tableView.tableHeaderView = headerView;
        }
    }
}

- (void)configureHeaderShadow
{
    self.commentTextViewContainer.shadowColorType = 8;
    self.commentTextViewContainer.shadowRadius = 5;
    self.commentTextViewContainer.shadowOpacity = 0.5;
    self.commentTextViewContainer.shadowOffset = CGSizeMake(0, 5);
}

- (void)configureTextViews
{
    [self.commentTextView setTextContainerInset:UIEdgeInsetsMake(10, -5, 0, 0)];
    [self.descriptionTextView setTextContainerInset:UIEdgeInsetsMake(10, -5, 0, 0)];
}

- (void)configureReportButton
{
    if (self.reportCategoryId != 0) {
        self.reportButton.alpha = 1.0;
        self.reportButton.userInteractionEnabled = YES;
    } else {
        self.reportButton.alpha = 0.5;
        self.reportButton.userInteractionEnabled = NO;
    }
}

- (void)handleReportResult:(NSString *)message
{
    if (message.length == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self showAlertViewWithTitle:@"Report"
                         withMessage:message
                   cancelButtonTitle:nil okButtonTitle:@"Ok" cancelAction:^{
        } okAction:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

- (void)handleError:(NSDictionary *)errorInfo
{
    NSString *message = @"";
    if (errorInfo[@"message"]) {
        if ([errorInfo[@"message"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *errorMessageDict = errorInfo[@"message"];
            if ([errorMessageDict[@"message"] isKindOfClass:[NSArray class]]) {
                message = errorMessageDict[@"message"][0];
            } else if (errorMessageDict[@"comment"]) {
                if ([errorMessageDict[@"comment"] isKindOfClass:[NSArray class]]) {
                    message = errorMessageDict[@"comment"][0];
                } else {
                    message = errorMessageDict[@"comment"];
                }
            } else {
                message = errorMessageDict[@"message"];
            }
        } else {
            message = errorInfo[@"message"];
        }
    }

    [self showAlertViewWithTitle:LOC(@"error_text_key") withMessage:message cancelButtonTitle:nil okButtonTitle:LOC(@"ok") cancelAction:nil okAction:nil];
}

#pragma mark - Action Methods

- (IBAction)reportButtonAction:(id)sender
{
    NSMutableDictionary *params = [@{@"category_id" : self.reportCategoryId,
                             @"comment_id" : self.comment.messageId,
                             @"user_id" : self.comment.sender.userId,
                             @"message" : self.descriptionTextView.text,
                             @"room_key" : self.roomKey} mutableCopy];
    
    if (self.comment.messageContent) {
        [params setObject:self.comment.messageContent forKey:@"comment"];
    }
    
    if (self.isForumReport) {
        [params setObject:self.forumId forKey:@"forum_id"];
    }
    
    weakify(self);
    [self.forumService reportUser:params success:^(NSString *message) {
        strongify(self);
        [self handleReportResult:message];
    } failure:^(NSError * _Nonnull error) {
        [self handleError:error.userInfo];
    }];
}

- (IBAction)cancelButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"reportCategories"]) {
        ReportCategoriesViewController *destinationVC = segue.destinationViewController;
        destinationVC.delegate = self;
    }
}

#pragma mark - ReportCategoriesViewControllerDelegate Methods

- (void)reportCategory:(ReportCategoryDataModel *)categoryDataModel {
    self.reportCategoryId = [NSNumber numberWithInteger:[categoryDataModel.categoryId integerValue]];
    self.categoryNameLabel.text = categoryDataModel.name;
    [self configureReportButton];
}

#pragma mark - Translations

- (void)updateLocalizations
{
    self.title = LOC(@"report");
    self.categoryNameLabel.text = LOC(@"report_spinner_title");
    [self.reportButton setTitle:LOC(@"report") forState:UIControlStateNormal];
    [self.cancelButton setTitle:LOC(@"cancel") forState:UIControlStateNormal];
    if (self.isForumReport) {
        self.commentTitleLabel.text = LOC(@"forum_comment");
        self.descriptionTitleLabel.text = LOC(@"forum_comment");
    } else {
        self.commentTitleLabel.text = LOC(@"message_comment");
        self.descriptionTitleLabel.text = LOC(@"message_comment");
    }
}

@end
