//
//  ForumItemTableViewCell.m
//  SafeYou
//
//  Created by Garnik Simonyan on 10/3/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "ForumItemTableViewCell.h"
#import "ForumItemDataModel.h"
#import "ForumCommentedUserDataModel.h"
#import <SDWebImage.h>
#import "ImageDataModel.h"
#import "NSString+HTML.h"


@interface ForumItemTableViewCell ()

@property (weak, nonatomic) IBOutlet SYDesignableView *shadowedContentView;
@property (weak, nonatomic) IBOutlet SYDesignableView *recentActivityView;
@property (weak, nonatomic) IBOutlet HyRobotoLabelRegular *recentActivityLabel;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet HyRobotoLabelBold *titleLabel;
@property (weak, nonatomic) IBOutlet HyRobotoLabelRegular *dateLabel;
@property (weak, nonatomic) IBOutlet HyRobotoLabelRegular *contentLabel;
@property (weak, nonatomic) IBOutlet HyRobotoLabelBold *moreInfoLabel;
@property (weak, nonatomic) IBOutlet HyRobotoLabelRegular *activityLabel;

@property (strong, nonatomic) IBOutletCollection(SYDesignableImageView) NSArray *avatarsCollection;
@property (weak, nonatomic) IBOutlet UIView *avatarsContainerView;
@property (weak, nonatomic) IBOutlet SYDesignableImageView *firstAvatarImageView;
@property (weak, nonatomic) IBOutlet SYDesignableView *secondAvatarView;
@property (weak, nonatomic) IBOutlet SYDesignableImageView *secondAvatarImageView;
@property (weak, nonatomic) IBOutlet SYDesignableView *thirdAvatarView;
@property (weak, nonatomic) IBOutlet SYDesignableImageView *thirdAvatarImageView;

@end


@implementation ForumItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.firstAvatarImageView.hidden = YES;
    self.secondAvatarView.hidden = YES;
    self.thirdAvatarView.hidden = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.firstAvatarImageView.layer.cornerRadius = self.firstAvatarImageView.frame.size.width/2;
    
    self.secondAvatarView.layer.cornerRadius = self.secondAvatarView.frame.size.width/2;
    
    self.secondAvatarImageView.layer.cornerRadius = self.secondAvatarImageView.frame.size.width/2;
    
    self.thirdAvatarView.layer.cornerRadius = self.thirdAvatarView.frame.size.width/2;
    self.thirdAvatarImageView.layer.cornerRadius = self.thirdAvatarImageView.frame.size.width/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureWithForumItem:(ForumItemDataModel *)forumItem
{
    if (forumItem.newMessagesCount > 0) {
        self.shadowedContentView.borderColorType = SYColorTypeMain1;
        self.shadowedContentView.borderWidth = 3.0;
        self.recentActivityView.hidden = NO;
        self.recentActivityLabel.text = [NSString stringWithFormat:LOC(@"people_commented_text_key"), @(forumItem.newMessagesCount)];
    } else {
        self.shadowedContentView.borderColorType = SYColorTypeMain1;
        self.shadowedContentView.borderWidth = 0.0;
        self.recentActivityView.hidden = YES;
    }
    self.titleLabel.text = forumItem.title;
    self.dateLabel.text = [NSString stringWithFormat:@"%@ | %@", forumItem.author, forumItem.formattedCreatedAt];
    [self configureContent:forumItem.shortDescription];
    self.moreInfoLabel.text = LOC(@"more_info_text_key");
    
    [self.titleImageView sd_setImageWithURL:forumItem.imageData.imageFullURL];
    
    [self updateComments:forumItem.commentsCount andViewsCount:forumItem.viewsCount];
    // Hide views count bug from backend
//    self.activityLabel.text = [NSString stringWithFormat:@"%@" , commentsCountText];
    
    [self configureCommentedUsersSection:forumItem];
}

- (void)updateComments:(NSInteger)commentsCount andViewsCount:(NSInteger)viewsCount
{
    NSString *commentsCountText = [NSString stringWithFormat:LOC(@"count_comments"), @(commentsCount)];
    NSString *viewsCountText = [NSString stringWithFormat:LOC(@"count_views"), @(viewsCount)];
    self.activityLabel.text = [NSString stringWithFormat:@"%@ | %@", viewsCountText, commentsCountText];
}

- (void)configureContent:(NSString *)htmlString
{
    NSMutableAttributedString *mAttrString = [[NSString attributedStringFromHTML:htmlString] mutableCopy];
    [mAttrString addAttribute:NSFontAttributeName value:[UIFont hyRobotoFontRegularOfSize:18] range:NSMakeRange(0, mAttrString.length)];
    self.contentLabel.attributedText = mAttrString;
}

- (void)configureCommentedUsersSection:(ForumItemDataModel *)forumitem
{
    for (int i = 0; i < forumitem.topCommentedUsers.count; ++i) {
        if (i == 0) {
            self.firstAvatarImageView.hidden = NO;
            ForumCommentedUserDataModel *userData = forumitem.topCommentedUsers[i];
            NSString *imagePath = userData.imagePath;
            NSURL *imageUrl = [self imageUrlForPath:imagePath];
            [self.firstAvatarImageView sd_setImageWithURL:imageUrl];
        }
        
        if (i == 1) {
            self.secondAvatarView.hidden = NO;
            ForumCommentedUserDataModel *userData = forumitem.topCommentedUsers[i];
            NSString *imagePath = userData.imagePath;
            NSURL *imageUrl = [self imageUrlForPath:imagePath];
            [self.secondAvatarImageView sd_setImageWithURL:imageUrl];
        }
        
        if (i == 2) {
            self.thirdAvatarView.hidden = NO;
            ForumCommentedUserDataModel *userData = forumitem.topCommentedUsers[i];
            NSString *imagePath = userData.imagePath;
            NSURL *imageUrl = [self imageUrlForPath:imagePath];
            [self.thirdAvatarImageView sd_setImageWithURL:imageUrl];
        }
        
    }
}

- (NSURL *)imageUrlForPath:(NSString *)imagePath
{
    NSString *imageURLString = [NSString stringWithFormat:@"%@%@", BASE_RESOURCE_URL, imagePath];
    
    return [NSURL URLWithString:imageURLString];
}

@end
