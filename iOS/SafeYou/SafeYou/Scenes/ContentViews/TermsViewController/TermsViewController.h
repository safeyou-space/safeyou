//
//  TermsViewController.h
//  SafeYou
//
//  Created by Garnik Simonyan on 9/22/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "SYViewController.h"

@class TermsViewController;

@protocol TermsViewDelegate  <NSObject>

- (void)termsViewDidAcceptTerms:(TermsViewController *)termsViewController;

@end

NS_ASSUME_NONNULL_BEGIN

@interface TermsViewController : SYViewController

@property (nonatomic) SYRemotContentType contentType;

@property (nonatomic, weak) id <TermsViewDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
