//
//  PhotoGalleryViewController.m
//  SafeYou
//
//  Created by Garnik Simonyan on 10/28/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "PhotoGalleryViewController.h"
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>
#import "SectionHeaderReusableView.h"
#import "ThumbnailCollectionViewCell.h"
#import "MWPhotoBrowser.h"
#import "MWPhoto.h"

@interface PhotoGalleryViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MWPhotoBrowserDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;


@property (nonatomic) PHFetchResult *userAlbums;
@property (nonatomic) PHAssetCollection *collection;

@property (nonatomic) NSMutableArray *assetsArray;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;
//@property (nonatomic, strong) NSMutableArray *assets;

@end

@implementation PhotoGalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self fetchUserAlbums];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


#pragma mark - Localizations

- (void)updateLocalizations
{
    self.title = LOC(@"photo_library");
}


#pragma mark - Customization

- (void)configureNavibationBar
{
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setBarTintColor:[UIColor mainTintColor1]];
    
    UIImage *image = [self imageWithColor:[UIColor mainTintColor1] withPoint:CGSizeMake(1, 1)];
    
    [[UINavigationBar appearance] setShadowImage:image];
    
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];

    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [[UINavigationBar appearance] setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"HayRoboto-regular" size:18]}];
}

- (UIImage *)imageWithColor:(UIColor *)color withPoint:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (!context) {
        return nil;
    }
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - Fetch Photos

- (void)fetchUserAlbums {
    
    [self showLoader];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
        PHAssetCollection *collection = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                              subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary
                                                              options:fetchOptions].firstObject;

        PHFetchResult *collectionResult = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
        NSLog(@"Custom album images::%@",collectionResult);
        
        self.assetsArray = [[NSMutableArray alloc] init];

        weakify(self);
        [collectionResult enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL *stop)
        {
            strongify(self);
            [self.assetsArray addObject:asset];
            NSLog(@"Custom album::%@",asset);
            NSLog(@"Collection Result Count:%lu", (unsigned long)collectionResult.count);

            //add assets to an array for later use in the uicollectionviewcell
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoader];
            [self.collectionView reloadData];
        });
    });
}

#pragma mark - PhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return self.photos.count;
}
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    return self.photos[index];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    NSMutableArray *thumbs = [[NSMutableArray alloc] init];
    MWPhoto *photo, *thumb;
    BOOL displayActionButton = YES;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = YES;
    BOOL startOnGrid = NO;
    BOOL autoPlayOnAppear = NO;
    NSMutableArray *copy = [self.assetsArray copy];
    if (NSClassFromString(@"PHAsset")) {
        // Photos library
        UIScreen *screen = [UIScreen mainScreen];
        CGFloat scale = screen.scale;
        // Sizing is very rough... more thought required in a real implementation
        CGFloat imageSize = MAX(screen.bounds.size.width, screen.bounds.size.height) * 1.5;
        CGSize imageTargetSize = CGSizeMake(imageSize * scale, imageSize * scale);
        CGSize thumbTargetSize = CGSizeMake(imageSize / 3.0 * scale, imageSize / 3.0 * scale);
        for (PHAsset *asset in copy) {
            [photos addObject:[MWPhoto photoWithAsset:asset targetSize:imageTargetSize]];
            [thumbs addObject:[MWPhoto photoWithAsset:asset targetSize:thumbTargetSize]];
        }
        
        self.photos = photos;
        self.thumbs = thumbs;
        
        // Create browser
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        browser.displayActionButton = displayActionButton;
        browser.displayNavArrows = displayNavArrows;
        browser.displaySelectionButtons = displaySelectionButtons;
        browser.alwaysShowControls = displaySelectionButtons;
        browser.zoomPhotosToFill = YES;
        browser.enableGrid = enableGrid;
        browser.startOnGrid = startOnGrid;
        browser.enableSwipeToDismiss = NO;
        browser.autoPlayOnAppear = autoPlayOnAppear;
        [browser setCurrentPhotoIndex:indexPath.item];
        
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
        nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nc animated:YES completion:nil];
    }
        
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.collectionView invalidateIntrinsicContentSize];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger numberofColumns = 4;
    CGFloat spacing = 4.f;
    CGFloat multiplier = spacing*3;
    CGFloat width = collectionView.frame.size.width/numberofColumns - multiplier;
    
    return CGSizeMake(width, width);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.collectionView.frame.size.width, 40);
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    SectionHeaderReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"SectionHeader" forIndexPath:indexPath];
//
//    PHAssetCollection *album = [self.userAlbums objectAtIndex:indexPath.section];
//    headerView.title = album.localizedTitle;
//
//    return headerView;
//}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1; //self.userAlbums.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assetsArray.count;
    
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHAssetCollection *collection = [self.userAlbums objectAtIndex:section];
//    PHFetchResult *fetchResult = [PHAsset fetchKeyAssetsInAssetCollection:[self.userAlbums objectAtIndex:section] options:fetchOptions];
    return collection.estimatedAssetCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ThumbnailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ThumbnailCollectionViewCell" forIndexPath:indexPath];
    
    

    PHAsset *asset = [self.assetsArray objectAtIndex:indexPath.row];
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat dimension = 78.0f;
    CGSize size = CGSizeMake(dimension*scale, dimension*scale);
    
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage *result, NSDictionary *info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.imageView.image = result;
        });
        
    }];
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
