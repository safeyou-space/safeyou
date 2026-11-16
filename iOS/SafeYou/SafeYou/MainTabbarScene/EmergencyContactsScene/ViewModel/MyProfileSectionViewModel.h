//
//  MyProfileSectionViewModel.h
//  SafeYou
//
//  Created by Garnik Simonyan on 9/8/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EmergencyContactDataModel;

typedef NS_ENUM(NSUInteger, MyProfileRowType) {
    MyProfileRowTypeNone,
    MyProfileRowTypeNavigation,
    MyProfileRowTypeAction,
    MyProfileRowTypeSwitch
};

NS_ASSUME_NONNULL_BEGIN

@interface MyProfileRowViewModel : NSObject

- (instancetype)initWithTitle:(NSString *)title rowType:(MyProfileRowType)type;

@property (nonatomic, readonly) NSString *fieldTitle;
@property (nonatomic) NSString *fieldValue;
@property (nonatomic) BOOL isStateOn;
@property (nonatomic, readonly) MyProfileRowType rowType;
@property (nonatomic) NSString *actionString;
@property (nonatomic) BOOL isSegue;
@property (nonatomic) BOOL showClearButton;
@property (nonatomic) BOOL showEditButton;
@property (nonatomic) NSString *iconImageName;

@property (nonatomic) id dataModel;

@end

@interface MyProfileSectionViewModel : NSObject

- (instancetype)initWithRows:(NSArray *)rows;

@property (nonatomic) NSString *imageName;
@property (nonatomic) NSString *sectionTitle;
@property (nonatomic) NSString *footerTitle;
@property (nonatomic) NSString *footertext;
@property (nonatomic, readonly) NSArray *sectionDataSource;


@end

NS_ASSUME_NONNULL_END
