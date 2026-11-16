//
//  FiltersView.m
//  SafeYou
//
//  Created by MacBook Pro on 06.11.21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import "FiltersView.h"
#import "UIView+AutoLayout.h"
#import "FiltersCollectionViewFlowLayout.h"
#import "FilterCollectionViewCell.h"
#import "FilterViewModel.h"

#define ITEMS_MAX_SPACE 8.0
static NSString *const FilterCollectionViewCellReuseIdentifier = @"FilterCollectionViewCell";

@interface FiltersView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) NSIndexPath *selectedIndexPath;
 
@end

@implementation FiltersView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupView];
//        [self.collectionView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"OBSERVE_CONTENT_SIZE = %@", NSStringFromCGSize(self.collectionView.contentSize));
    
    if (74 == self.collectionView.contentSize.height) {
        [self.heightAnchor constraintEqualToConstant:self.collectionView.contentSize.height].active = YES;
    }
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FilterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FilterCollectionViewCellReuseIdentifier forIndexPath:indexPath];
    FilterViewModel *model = self.dataSource[indexPath.item];
        
    if ((self.isMultiSelection && !model.modelId) || (!self.isMultiSelection && model.isSelected)) {
        self.selectedIndexPath = indexPath;
    }
    
    [cell configureWithViewModel:model];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FilterCollectionViewCell *cell = (FilterCollectionViewCell*) [collectionView cellForItemAtIndexPath:indexPath];
    
    if (self.isMultiSelection) {
        if (self.haveAllSelection && indexPath.item == 0) {
            for (FilterViewModel *viewModel in self.dataSource) {
                viewModel.isSelected = [self.dataSource indexOfObject:viewModel] == 0;
            }
            self.selectedIndexPath = indexPath;
            [collectionView reloadData];
            
        } else {
            if (self.selectedIndexPath) {
                FilterCollectionViewCell *currentSelectedCell = (FilterCollectionViewCell*) [collectionView cellForItemAtIndexPath:self.selectedIndexPath];
                [currentSelectedCell selectCell:NO];
                self.selectedIndexPath = nil;
            }
            
            [cell selectCell:!cell.viewModel.isSelected];
        }
    } else {
        if (self.selectedIndexPath) {
            FilterCollectionViewCell *currentSelectedCell = (FilterCollectionViewCell*) [collectionView cellForItemAtIndexPath:self.selectedIndexPath];
            [currentSelectedCell selectCell:NO];
        }
        [cell selectCell:YES];
        self.selectedIndexPath = indexPath;
    }

    if ([self.delegate respondsToSelector:@selector(filterView:didSelectItemAtIndexPath:)]) {
        [self.delegate filterView:self didSelectItemAtIndexPath:indexPath];
    }
}

#pragma mark - Custom getters

- (CGSize)contentSize
{
    return self.collectionView.contentSize;
}

#pragma mark - Public methods

- (void)reloadData
{
    [self.collectionView reloadData];
    [self.collectionView layoutIfNeeded];
    NSLog(@"CONTENT_SIZE = %@", NSStringFromCGSize(self.collectionView.contentSize));
    [self.heightAnchor constraintEqualToConstant:self.collectionView.collectionViewLayout.collectionViewContentSize.height].active = YES;
}

- (void)clearAllSelections
{
    for (FilterViewModel *viewModel in self.dataSource) {
        viewModel.isSelected = NO;
    }
    [self.collectionView reloadData];
    if (self.selectedIndexPath) {
        self.selectedIndexPath = nil;
    }
}

- (NSArray<NSString *> *)getSelectedItems
{
    NSMutableArray <NSString *>*selectedItems = [[NSMutableArray alloc] init];
    for (FilterViewModel *viewModel in self.dataSource) {
        if (viewModel.isSelected && viewModel.modelId) {
            [selectedItems addObject:viewModel.modelId];
        }
    }
    return selectedItems;
}

#pragma mark - Private methods

- (void)setupView
{
    self.backgroundColor = [UIColor clearColor];
    
    FiltersCollectionViewFlowLayout *flowLayout = [[FiltersCollectionViewFlowLayout alloc] initWithItemMaxSpace:ITEMS_MAX_SPACE];
    flowLayout.minimumLineSpacing = ITEMS_MAX_SPACE;
    flowLayout.minimumInteritemSpacing = ITEMS_MAX_SPACE;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    [self.collectionView registerNib:[UINib nibWithNibName:@"FilterCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:FilterCollectionViewCellReuseIdentifier];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self addSubviewWithZeroMargin:self.collectionView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
