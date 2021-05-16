//
//  ForumDescriptionCell.m
//  SafeYou
//
//  Created by Garnik Simonyan on 10/6/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "ForumDescriptionCell.h"
#import "ForumItemDataModel.h"
#import <SDWebImage.h>

@interface ForumDescriptionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *forumContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *forumTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *forumShorDescriptionLabel;


@end

@implementation ForumDescriptionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleImageView.clipsToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureWithForumData:(ForumItemDataModel *)forumItemData
{
    NSString *imageUrlString = [NSString stringWithFormat:@"%@%@", BASE_RESOURCE_URL, forumItemData.imagePath];
    [self.titleImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString]];
    NSAttributedString *descriptionAttributedString = [[NSAttributedString alloc] initWithData:[forumItemData.forumItemDescription dataUsingEncoding:NSUTF8StringEncoding]
                                     options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                               NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                          documentAttributes:nil error:nil];
    self.forumContentLabel.attributedText = descriptionAttributedString;
    self.forumTitleLabel.text = forumItemData.title;
    self.forumShorDescriptionLabel.text = forumItemData.shortDescription;
    
    //@TODO: need clean for testing dynamic height
//    self.forumContentLabel.text = @"It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).";
}

@end
