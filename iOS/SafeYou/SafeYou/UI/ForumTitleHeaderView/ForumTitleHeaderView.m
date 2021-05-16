//
//  ForumTitleHeaderView.m
//  SafeYou
//
//  Created by Garnik Simonyan on 10/6/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "ForumTitleHeaderView.h"
#import "ForumItemDataModel.h"
#import "ForumCommentedUserDataModel.h"
#import <SDWebImage.h>

@interface ForumTitleHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *firstAvatarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondAvatarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdAvatarImageView;
@property (weak, nonatomic) IBOutlet HyRobotoLabelBold *titleLabel;

// constraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conmmentsCountLabelLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstAvatarWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondAvatarWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdAvatarWidthConstraint;



@end


@implementation ForumTitleHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.firstAvatarImageView.hidden = YES;
    self.secondAvatarImageView.hidden = YES;
    self.thirdAvatarImageView.hidden = YES;
}

- (void)configureWithFourmData:(ForumItemDataModel *)forumItem
{
    self.titleLabel.text = [NSString stringWithFormat:LOC(@"{param}_people_commented_text_key"), @(forumItem.commentsCount)];
    
    [self configureCommentedUsersSection:forumItem];
}

- (void)configureCommentedUsersSection:(ForumItemDataModel *)forumitem
{
    for (int i = 0; i < forumitem.topCommentedUsers.count; ++i) {
        if (i == 0) {
            self.firstAvatarImageView.hidden = NO;
            self.thirdAvatarWidthConstraint.constant = 40;
            ForumCommentedUserDataModel *userData = forumitem.topCommentedUsers[i];
            NSString *imagePath = userData.imagePath;
            NSURL *imageUrl = [self imageUrlForPath:imagePath];
            [self.firstAvatarImageView sd_setImageWithURL:imageUrl];
        }
        
        if (i == 1) {
            self.secondAvatarImageView.hidden = NO;
            self.secondAvatarWidthConstraint.constant = 40;
            ForumCommentedUserDataModel *userData = forumitem.topCommentedUsers[i];
            NSString *imagePath = userData.imagePath;
            NSURL *imageUrl = [self imageUrlForPath:imagePath];
            [self.secondAvatarImageView sd_setImageWithURL:imageUrl];
        }
        
        if (i == 2) {
            self.thirdAvatarImageView.hidden = NO;
            self.firstAvatarWidthConstraint.constant = 40;
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
