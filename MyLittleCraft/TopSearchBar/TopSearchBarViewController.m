//
//  TopSearchBarViewController.m
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/13.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "TopSearchBarViewController.h"
#import "MYSearchContainer.h"
#import "MYSearchHeader.h"
#import "UIView+Pin.h"
#import "MYSearchViewController.h"
#import "MYSearchTransitionAnimator.h"
#import "MYSearchTableViewComponents.h"
#import "MYTableCellMapper.h"
#import "MYNavigationController.h"

static NSString * const kSearchBarDemoItemCellReuseId = @"kSearchBarDemoItemCellReuseId";
static NSString * const kSearchBarDemoSectionCellReuseId = @"kSearchBarDemoSectionCellReuseId";

@interface TopSearchBarViewController () <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate, UIViewControllerTransitioningDelegate, MYSearchTableSectionCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MYSearchHeader *searchHeader;
@property (nonatomic, strong) MYSearchTransitionAnimator *transitionAnimator;

@property (nonatomic, strong) NSArray <NSString *> *recentSearchItems;
@property (nonatomic, strong) NSArray <NSString *> *hotSearchItems;

// This is for creating UITableViewCell with fake section effect.
@property (nonatomic, strong) NSMutableArray <MYTableCellMapper *> *mappers;

@end

@implementation TopSearchBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate = self;
    
    [self setupModel];
    [self setupInterface];
}

#pragma mark - initialize

- (void)setupModel {
    // Load prepared content
    NSString *filePath = [NSBundle.mainBundle pathForResource:@"search_results" ofType:@"txt"];
    NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSArray *list = [content componentsSeparatedByString:@"\n"];
    
    _hotSearchItems = [list subarrayWithRange:NSMakeRange(0, list.count / 2)];
    _recentSearchItems = [list subarrayWithRange:NSMakeRange(list.count / 2, list.count / 2)];

    // Make table cell mapper
    _mappers = [NSMutableArray new];
    [_mappers addObjectsFromArray:[self mappersForNumberOfItems:_recentSearchItems.count inSection:0]];
    [_mappers addObjectsFromArray:[self mappersForNumberOfItems:_hotSearchItems.count inSection:1]];

    // Add transitioning
    _transitionAnimator = [MYSearchTransitionAnimator new];
}

- (void)setupInterface {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_tableView registerClass:[MYSearchTableSectionCell class]
       forCellReuseIdentifier:kSearchBarDemoSectionCellReuseId];
    [_tableView registerClass:[MYSearchTableItemCell class]
       forCellReuseIdentifier:kSearchBarDemoItemCellReuseId];
    
    [self.view addSubview:_tableView];
    
    // I will adjust the contentInset manually
    if (@available(iOS 11, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    // Add constraints
    [_tableView pinEdgesToSuperview];
    
    // Add search header directly as self.view's subview
    CGRect searchHeaderFrame;
    searchHeaderFrame.origin.x = 0;
    searchHeaderFrame.origin.y = 0;
    searchHeaderFrame.size.width = UIScreen.mainScreen.bounds.size.width;
    searchHeaderFrame.size.height = kMYSearchHeaderHeight;
    
    _searchHeader = [[MYSearchHeader alloc] initWithFrame:searchHeaderFrame];
    _searchHeader.searchBar.placeholder = @"Think how to exit";
    _searchHeader.searchBar.delegate = self;
    [self.view addSubview:_searchHeader];
    
    // The real table header is just a placeholder view which has nothing to do with self.searchHeader
    // When calling `tableView.tableHeaderView = someView` and someView's frame or constraint is not set yet, the table header shows nothing.
    UIView *realHeader = [[UIView alloc] initWithFrame:(CGRect){ CGPointZero, searchHeaderFrame.size }];
    _tableView.tableHeaderView = realHeader;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _mappers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    MYTableCellMapper *mapper = _mappers[indexPath.row];
    
    // Section
    if (mapper.elementType == MYTableElementTypeSection) {
        cell = [tableView dequeueReusableCellWithIdentifier:kSearchBarDemoSectionCellReuseId forIndexPath:indexPath];
        MYSearchTableSectionCell *sectionCell = (MYSearchTableSectionCell *)cell;
        sectionCell.currentIndexPath = indexPath;
        sectionCell.delegate = self;
        
        // Recent
        if (mapper.section == 0) {
            sectionCell.titleLabel.text = @"Recent";
            sectionCell.cleanButton.hidden = NO;
        }
        // Hot
        else if (mapper.section == 1) {
            sectionCell.titleLabel.text = @"Hot";
            sectionCell.cleanButton.hidden = YES;
        }
    }
    // Cell
    else if (mapper.elementType == MYTableElementTypeCell) {
        cell = [tableView dequeueReusableCellWithIdentifier:kSearchBarDemoItemCellReuseId forIndexPath:indexPath];
        MYSearchTableItemCell *itemCell = (MYSearchTableItemCell *)cell;
        itemCell.currentIndexPath = indexPath;
        itemCell.bottomSeparator.hidden = NO;
        
        // Recent
        if (mapper.section == 0) {
            itemCell.titleLabel.text = _recentSearchItems[mapper.itemIndex];
            // Last recent item
            if (mapper.itemIndex == _recentSearchItems.count - 1) {
                itemCell.bottomSeparator.hidden = YES;
            }
        }
        // Hot
        else if (mapper.section == 1) {
            itemCell.titleLabel.text = _hotSearchItems[mapper.itemIndex];
            // Last hot item
            if (mapper.itemIndex == _hotSearchItems.count - 1) {
                itemCell.bottomSeparator.hidden = YES;
            }
        }
    }
    
    NSAssert(cell != nil, @"[%@] Can not return nil at row (%@) in %@", self.class, @(indexPath.row), NSStringFromSelector(_cmd));
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MYTableCellMapper *mapper = _mappers[indexPath.row];
    switch (mapper.elementType) {
        case MYTableElementTypeSection:
            return kMYSearchTableSectionCellHeight;
        case MYTableElementTypeCell:
            return kMYSearchTableItemCellHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MYTableCellMapper *mapper = _mappers[indexPath.row];
    if (mapper.elementType == MYTableElementTypeCell) {
        NSArray <NSString *> *items = (mapper.section == 0 ? _recentSearchItems : _hotSearchItems);
        NSString *item = items[mapper.itemIndex];
        NSLog(@"Select item: %@", item);
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Dismiss keyboard if possible
    if (_searchHeader.searchBar.isFirstResponder) {
        [_searchHeader.searchBar resignFirstResponder];
    }
    // Make search bar stick at top
    [_searchHeader adjustPositionByContentOffset:scrollView.contentOffset];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(MYNavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    // Hide navigation bar in self
    BOOL showSelf = [viewController isKindOfClass:self.class];
    [navigationController setNavigationBarHidden:showSelf animated:animated];
}

- (void)navigationController:(MYNavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    NSAssert([navigationController isKindOfClass:MYNavigationController.class], @"Must initialize %@ class inside of MYNavigationController.", self.class);
    
    // Change default edge distance from pop gesture
    MYFullScreenPanGestureRecognizer *popGesture = navigationController.my_interactivePopGestureRecognizer;
    popGesture.interactiveDistanceFromEdge = UIScreen.mainScreen.bounds.size.width / 2;
    
    BOOL showSelf = [viewController isKindOfClass:self.class];
    if (!showSelf) {
        popGesture.interactiveDistanceFromEdge = MYFullScreenInteractiveDistanceDefault;
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self showSearchContents];
    return NO;
}

- (void)showSearchContents {
    MYSearchViewController *searchVC = [MYSearchViewController new];
    searchVC.searchContainer.searchBar.placeholder = _searchHeader.searchBar.placeholder;
    
    searchVC.modalPresentationStyle = UIModalPresentationCustom;
    searchVC.transitioningDelegate = self;
    
    [searchVC.view layoutIfNeeded];
    [self presentViewController:searchVC animated:YES completion:nil];
}

#pragma mark - UIViewControllerTransitioningDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(id <MYSearchBarOwnerable>)presented presentingController:(UIViewController *)presenting sourceController:(id <MYSearchBarOwnerable>)source {
    
    NSAssert([presented conformsToProtocol:@protocol(MYSearchBarOwnerable)], @"%@ must conforms to MYSearchBarOwnerable.", presented);
    NSAssert(source == self, @"%@ must identical to %@.", source, self);
    
    _transitionAnimator.presenting = YES;
    _transitionAnimator.sourceOwner = source;
    _transitionAnimator.presentedOwner = presented;

    return _transitionAnimator;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(id <MYSearchBarOwnerable>)dismissed {
    
    NSAssert([dismissed conformsToProtocol:@protocol(MYSearchBarOwnerable)], @"%@ must conforms to MYSearchBarOwnerable.", dismissed);
    
    _transitionAnimator.presenting = NO;
    _transitionAnimator.sourceOwner = self;
    _transitionAnimator.presentedOwner = dismissed;

    return _transitionAnimator;
}

#pragma mark - MYSearchTableSectionCellDelegate

- (void)searchTableSectionCell:(MYSearchTableSectionCell *)searchTableSectionCell didTapCleanButton:(UIButton *)cleanButton {
    MYTableCellMapper *mapper = _mappers[searchTableSectionCell.currentIndexPath.row];
    if (mapper.elementType == MYTableElementTypeSection && mapper.section == 0) {
        // Pop sheet
        UIAlertController *sheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *clean = [UIAlertAction actionWithTitle:@"Clean Recents" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self deleteRecentSearchResults];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        [sheet addAction:clean];
        [sheet addAction:cancel];
        [self presentViewController:sheet animated:YES completion:nil];
    }
}

#pragma mark - MYSearchBarOwnerable

- (MYSearchBar *)searchBar {
    return _searchHeader.searchBar;
}

#pragma mark -

- (void)deleteRecentSearchResults {
    NSRange recentRange;
    recentRange.location = 0;
    
    MYTableCellMapper *hotSectionMapper = [MYTableCellMapper new];
    hotSectionMapper.elementType = MYTableElementTypeSection;
    hotSectionMapper.section = 1;
    
    NSInteger index = [_mappers indexOfObject:hotSectionMapper];
    recentRange.length = index;
    
    [_mappers removeObjectsInRange:recentRange];
    
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (NSInteger i = 0; i < index; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [indexPaths addObject:indexPath];
    }
    [_tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}

- (NSArray <MYTableCellMapper *> *)mappersForNumberOfItems:(NSInteger)numberOfItems inSection:(NSInteger)section {
    NSMutableArray <MYTableCellMapper *> *mappers = [NSMutableArray arrayWithCapacity:numberOfItems + 1];
    
    // Add section
    MYTableCellMapper *mapperForSection = [MYTableCellMapper new];
    mapperForSection.elementType = MYTableElementTypeSection;
    mapperForSection.section = section;
    [mappers addObject:mapperForSection];
    
    // Add cell
    for (NSInteger i = 0; i < numberOfItems; i++) {
        MYTableCellMapper *mapperForCell = [MYTableCellMapper new];
        mapperForCell.elementType = MYTableElementTypeCell;
        mapperForCell.section = section;
        mapperForCell.itemIndex = i;
        [mappers addObject:mapperForCell];
    }
    
    return mappers;
}

@end
