//
//  IntroductionContentManager.m
//  SafeYou
//
//  Created by Garnik Simonyan on 3/23/24.
//  Copyright © 2024 Garnik Simonyan. All rights reserved.
//

#import "IntroductionContentManager.h"
#import "IntroductionContentViewModel.h"


@implementation IntroductionContentManager

- (IntroductionContentViewModel *)viewModelForType:(IntroductionContentType)contentType
{
    switch (contentType) {
        case IntroductionContentTypeDualPin:
            return  [self dualPinContentViewModel];
            break;
        case IntroductionContentTypeEmergencyContacts:
            return [self emergencyContactsContentViewModel];
            break;
        case IntroductionContentTypePrivateMessages:
            return [self privateMessagesContentViewModel];
            break;
        case IntroductionContentTypeForums:
            return [self forumsContentViewModel];
            break;
        case IntroductionContentTypeHelpButton:
            return [self helpButtonContentViewModel];
            break;
        case IntroductionContentTypeNetwork:
            return [self networkContentViewModel];
            break;

        default:
            NSAssert(NO, @"Content Type Must be provided!!!");
            break;
    }
    return nil;
}

#pragma mark private

- (IntroductionContentViewModel *)dualPinContentViewModel
{
    IntroductionContentViewModel *viewModel = [[IntroductionContentViewModel alloc] initWithImageName:@"intro_icon_dual_pin" titleLocKey:@"dual_pin_code_title_key" headingLocKey:@"security_tutorial_title_description"];
    viewModel.descritpionContents = [self contentsForDualPin];
    return viewModel;
}

- (IntroductionContentViewModel *)emergencyContactsContentViewModel
{
    IntroductionContentViewModel *viewModel = [[IntroductionContentViewModel alloc] initWithImageName:@"intro_icon_emergency_contact" titleLocKey:@"emergency_contacts_title_key" headingLocKey:@"emergency_tutorial_title_description"];
    viewModel.descritpionContents = [self contentsForEmergencyContacts];
    return viewModel;
}

- (IntroductionContentViewModel *)privateMessagesContentViewModel
{
    IntroductionContentViewModel *viewModel = [[IntroductionContentViewModel alloc] initWithImageName:@"intro_icon_private_message" titleLocKey:@"messages_title_key" headingLocKey:@"private_message_tutorial_title_description"];
    viewModel.descritpionContents = [self contentsForPrivateMessages];
    return viewModel;
}

- (IntroductionContentViewModel *)forumsContentViewModel
{
    IntroductionContentViewModel *viewModel = [[IntroductionContentViewModel alloc] initWithImageName:@"intro_icon_forum" titleLocKey:@"forums_title_key" headingLocKey:@"forum_tutorial_title_description"];
    viewModel.descritpionContents = [self contentsForForums];
    return viewModel;
}

- (IntroductionContentViewModel *)helpButtonContentViewModel
{
    IntroductionContentViewModel *viewModel = [[IntroductionContentViewModel alloc] initWithImageName:@"intro_icon_help" titleLocKey:@"help_button_title_key" headingLocKey:@""];
    viewModel.descritpionContents = [self contentsForHelpButton];
    return viewModel;
}

- (IntroductionContentViewModel *)networkContentViewModel
{
    IntroductionContentViewModel *viewModel = [[IntroductionContentViewModel alloc] initWithImageName:@"intro_icon_network" titleLocKey:@"network_tutorial_title1" headingLocKey:@"network_tutorial_title_description"];
    viewModel.descritpionContents = [self contentsForNetwork];
    return viewModel;
}

#pragma mark - Detailed Contents

- (NSArray <IntrodutionDescriptionViewModel *> *)contentsForDualPin
{
    IntrodutionDescriptionViewModel *content1 = [[IntrodutionDescriptionViewModel alloc] initWithTitleLocalizationKey:@"security_tutorial_title1" mainTextLocalizationKey:@"security_tutorial_description1"];
    IntrodutionDescriptionViewModel *content2 = [[IntrodutionDescriptionViewModel alloc] initWithTitleLocalizationKey:@"security_tutorial_title2" mainTextLocalizationKey:@"security_tutorial_description2"];

    return @[content1];
}

- (NSArray <IntrodutionDescriptionViewModel *> *)contentsForEmergencyContacts
{
    IntrodutionDescriptionViewModel *content1 = [[IntrodutionDescriptionViewModel alloc] initWithTitleLocalizationKey:@"emergency_tutorial_title1" mainTextLocalizationKey:@"emergency_tutorial_description1"];

    return @[content1];
}

- (NSArray <IntrodutionDescriptionViewModel *> *)contentsForPrivateMessages
{
    IntrodutionDescriptionViewModel *content1 = [[IntrodutionDescriptionViewModel alloc] initWithTitleLocalizationKey:@"private_message_tutorial_title1" mainTextLocalizationKey:@"private_message_tutorial_description1"];


    return @[content1];
}

- (NSArray <IntrodutionDescriptionViewModel *> *)contentsForHelpButton
{
    IntrodutionDescriptionViewModel *content1 = [[IntrodutionDescriptionViewModel alloc] initWithTitleLocalizationKey:@"help_tutorial_title1" mainTextLocalizationKey:@"help_tutorial_description1"];

    return @[content1];
}

- (NSArray <IntrodutionDescriptionViewModel *> *)contentsForNetwork
{
    IntrodutionDescriptionViewModel *content1 = [[IntrodutionDescriptionViewModel alloc] initWithTitleLocalizationKey:@"network_tutorial_title1" mainTextLocalizationKey:@"network_tutorial_description1"];

    return @[content1];
}

- (NSArray <IntrodutionDescriptionViewModel *> *)contentsForForums
{
    IntrodutionDescriptionViewModel *content1 = [[IntrodutionDescriptionViewModel alloc] initWithTitleLocalizationKey:@"forum_tutorial_title1" mainTextLocalizationKey:@"forum_tutorial_description1"];
    IntrodutionDescriptionViewModel *content2 = [[IntrodutionDescriptionViewModel alloc] initWithTitleLocalizationKey:@"forum_tutorial_title2" mainTextLocalizationKey:@"forum_tutorial_description2"];

    return @[content1, content2];
}

@end
