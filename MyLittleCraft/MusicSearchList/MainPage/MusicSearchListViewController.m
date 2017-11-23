//
//  MusicSearchListViewController.m
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/13.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "MusicSearchListViewController.h"
#import "MYMusicCardViewController.h"
#import "MYSearchViewController.h"
#import "MYMusicSearchDetailViewController.h"

#import "MYMusicSearchTransitioner.h"
#import "MYSearchBarTransitionAnimator.h"
#import "MYMusicCardTransitionAnimator.h"

#import "MYSearchContainer.h"
#import "MYSearchHeader.h"
#import "MYSearchBar.h"

#import "MYMusicBar.h"
#import "MYArtworkCardView.h"
#import "MYTitleLabelOwnerable.h"

#import "UIView+Pin.h"

#import "MYSearchTableViewComponents.h"
#import "MYTableCellMapper.h"
#import "MYMusicSearchConsts.h"

static NSString * const kSearchBarDemoItemCellReuseId = @"kSearchBarDemoItemCellReuseId";
static NSString * const kSearchBarDemoSectionCellReuseId = @"kSearchBarDemoSectionCellReuseId";

@interface MusicSearchListViewController () <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate, UIViewControllerTransitioningDelegate, MYSearchTableSectionCellDelegate, MYMusicBarDelegate, MYSearchBarOwnerable, MYArtworkCardOwnerable, MYMusicBarOwnerable, MYTitleLabelOwnerable>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MYSearchHeader *searchHeader;
@property (nonatomic, strong) MYMusicBar *musicBar;

@property (nonatomic, strong) MYMusicSearchTransitioner *transitioner;
@property (nonatomic, strong) NSArray <NSString *> *recentSearchItems;
@property (nonatomic, strong) NSArray <NSString *> *hotSearchItems;

// This is for creating UITableViewCell with fake section effect.
@property (nonatomic, strong) NSMutableArray <MYTableCellMapper *> *mappers;

@end

@implementation MusicSearchListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupModel];
    [self setupInterface];
}

#pragma mark - status bar

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.transitioner.musicCardTransitionAnimator.isPresentation) {
        return UIStatusBarStyleLightContent;
    } else {
        return UIStatusBarStyleDefault;
    }
}

#pragma mark - initialize

- (void)setupModel {
    // Load prepared content
    NSString *filePath = [NSBundle.mainBundle pathForResource:@"search_results" ofType:@"txt"];
    NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSArray *list = [content componentsSeparatedByString:@"\n"];
    
    _hotSearchItems = [list subarrayWithRange:NSMakeRange(0, list.count / 2)];
    _recentSearchItems = [list subarrayWithRange:NSMakeRange(list.count / 2, list.count / 2)];

    // Create table view cell mapper
    _mappers = [NSMutableArray new];
    // Add recent search results as 1st table section
    [_mappers addObjectsFromArray:[self mappersForNumberOfItems:_recentSearchItems.count inSection:0]];
    // Add hot search results as 2nd table section
    [_mappers addObjectsFromArray:[self mappersForNumberOfItems:_hotSearchItems.count inSection:1]];
    
    // Create transition delegate
    _transitioner = [MYMusicSearchTransitioner new];
    [_transitioner.musicCardTransitionAnimator.backgroundTapGestureRecognizer addTarget:self action:@selector(dismiss)];
    
    // Set navigation delegate
    self.navigationController.delegate = _transitioner;
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
    [_tableView pinAllEdges];
    
    // Add search header directly as self.view's subview
    CGRect searchHeaderFrame = CGRectZero;
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
    
    // Setup music bar
    _musicBar = [MYMusicBar new];
    _musicBar.delegate = self;
    [self.view addSubview:_musicBar];
    
    // iPhone X adapting
    if (iPhoneX) {
        [_musicBar extendBarHeight];
    }
    
    [_musicBar pinEdges:UIRectEdgeLeft | UIRectEdgeBottom | UIRectEdgeRight];
    [_musicBar layoutIfNeeded];
    
    [_musicBar.artworkCardView setRandomImage];
    _musicBar.titleLabel.text = _hotSearchItems.firstObject;
    
    // Adjust table contentInset for music bar
    UIEdgeInsets contentInset = _tableView.contentInset;
    contentInset.bottom = _musicBar.frame.size.height;
    _tableView.contentInset = contentInset;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _mappers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    MYTableCellMapper *mapper = _mappers[indexPath.row];
    
    // Section
    if (mapper.elementType == MYTableElementTypeSectionHeader) {
        cell = [tableView dequeueReusableCellWithIdentifier:kSearchBarDemoSectionCellReuseId forIndexPath:indexPath];
        MYSearchTableSectionCell *sectionHeaderCell = (MYSearchTableSectionCell *)cell;
        sectionHeaderCell.currentIndexPath = indexPath;
        sectionHeaderCell.delegate = self;
        
        // Recent
        if (mapper.section == 0) {
            sectionHeaderCell.titleLabel.text = @"Recent";
            sectionHeaderCell.cleanButton.hidden = NO;
        }
        // Hot
        else if (mapper.section == 1) {
            sectionHeaderCell.titleLabel.text = @"Hot";
            sectionHeaderCell.cleanButton.hidden = YES;
        }
    }
    // Cell
    else if (mapper.elementType == MYTableElementTypeCell) {
        NSArray <NSString *> *items = nil;
        switch (mapper.section) {
            case 0: items = _recentSearchItems; break;
            case 1: items = _hotSearchItems; break;
        }
        
        cell = [tableView dequeueReusableCellWithIdentifier:kSearchBarDemoItemCellReuseId forIndexPath:indexPath];
        MYSearchTableItemCell *itemCell = (MYSearchTableItemCell *)cell;
        itemCell.currentIndexPath = indexPath;
        itemCell.bottomSeparator.hidden = NO;
        itemCell.titleLabel.text = items[mapper.row];
        // Last item in section
        if (mapper.row == items.count - 1) {
            itemCell.bottomSeparator.hidden = YES;
        }
    }
    
    NSAssert(cell != nil, @"[%@] Can not return nil for mapper %@ from %@", self.class, mapper, NSStringFromSelector(_cmd));
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MYTableCellMapper *mapper = _mappers[indexPath.row];
    switch (mapper.elementType) {
        case MYTableElementTypeSectionHeader:
            return kMYSearchTableSectionCellHeight;
        case MYTableElementTypeCell:
            return kMYSearchTableItemCellHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MYTableCellMapper *mapper = _mappers[indexPath.row];
    if (mapper.elementType == MYTableElementTypeCell) {
        NSArray <NSString *> *items = (mapper.section == 0 ? _recentSearchItems : _hotSearchItems);
        NSString *item = items[mapper.row];
        
        MYMusicSearchDetailViewController *dvc = [MYMusicSearchDetailViewController new];
        [self.navigationController pushViewController:dvc animated:YES];
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

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self showSearchContents];
    return NO;
}

- (void)showSearchContents {
    MYSearchViewController *searchVC = [MYSearchViewController new];
    searchVC.searchContainer.searchBar.placeholder = _searchHeader.searchBar.placeholder;
    
    searchVC.modalPresentationStyle = UIModalPresentationCustom;
    searchVC.transitioningDelegate = self.transitioner;
    
    [self presentViewController:searchVC animated:YES completion:nil];
}

#pragma mark - MYMusicBarDelegate

- (void)musicBarDidTap:(MYMusicBar *)musicBar {
    MYMusicCardViewController *dvc = [MYMusicCardViewController new];
    dvc.artworkImage = musicBar.artworkCardView.image;
    
    dvc.modalPresentationStyle = UIModalPresentationCustom;
    dvc.transitioningDelegate = self.transitioner;
    
    [self presentViewController:dvc animated:YES completion:nil];
}

#pragma mark - MYSearchTableSectionCellDelegate

- (void)searchTableSectionCell:(MYSearchTableSectionCell *)searchTableSectionCell didTapCleanButton:(UIButton *)cleanButton {
    MYTableCellMapper *mapper = _mappers[searchTableSectionCell.currentIndexPath.row];
    if (mapper.elementType == MYTableElementTypeSectionHeader && mapper.section == 0) {
        // Present sheet
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

#pragma mark - MYArtworkCardOwnerable

- (MYArtworkCardView *)artworkCardView {
    return _musicBar.artworkCardView;
}

#pragma mark - MYTitleLabelOwnerable

- (UILabel *)titleLabel {
    return _searchHeader.titleLabel;
}

#pragma mark - Helper

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)deleteRecentSearchResults {
    // delete items from array
    NSRange recentRange;
    recentRange.location = 0;
    
    // MYTableCellMapper has implemented -isEqual: method.
    // So the convenience way is to create a target item for locating target index in array.
    MYTableCellMapper *hotSectionMapper = [MYTableCellMapper mapViewForHeaderInSection:1];
    
    NSInteger targetIndex = [_mappers indexOfObject:hotSectionMapper];
    recentRange.length = targetIndex;
    
    [_mappers removeObjectsInRange:recentRange];
    
    // delete cells from table view
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (NSInteger i = 0; i < targetIndex; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [indexPaths addObject:indexPath];
    }
    [_tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}

- (NSArray <MYTableCellMapper *> *)mappersForNumberOfItems:(NSInteger)numberOfItems inSection:(NSInteger)section {
    NSMutableArray <MYTableCellMapper *> *mappers = [NSMutableArray arrayWithCapacity:numberOfItems + 1];
    
    // Add section header mapper
    MYTableCellMapper *sectionHeaderMapper = [MYTableCellMapper mapViewForHeaderInSection:section];
    [mappers addObject:sectionHeaderMapper];
    
    // Add cell mapper
    for (NSInteger i = 0; i < numberOfItems; i++) {
        MYTableCellMapper *cellMapper = [MYTableCellMapper mapCellForRow:i inSection:section];
        [mappers addObject:cellMapper];
    }
    
    return mappers;
}

- (BOOL)isSearchTitleOnScreen {
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    CGRect screenBounds = UIScreen.mainScreen.bounds;
    CGRect searchTitleFrame = [window convertRect:_searchHeader.titleLabel.frame fromView:_searchHeader];
    return (CGRectContainsRect(screenBounds, searchTitleFrame));
}

@end
