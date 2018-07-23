//
//  SecondViewController.m
//  test
//
//  Created by gcl on 2018/6/29.
//  Copyright © 2018年 gcl. All rights reserved.
//

#import "SecondViewController.h"
#import "SearchResultVC.h"

static NSString *const kUITableViewCellIdentifier = @"cellIdentifier";
@interface SecondViewController ()<UISearchResultsUpdating>
{
    
    NSMutableArray *_dataSource; /**< 数据源 */
    NSMutableArray *_searchResults; /**< 搜索结果 */
}

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SearchResultVC *resultVC;

@end

@implementation SecondViewController

//initWithSearchResultsController:vc
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
}

#pragma mark - Init methods
- (void)initializeDataSource {
    
    // 初始化数据源
    _dataSource = [NSMutableArray arrayWithArray:[UIFont familyNames]];
    
}

- (void)initializeUserInterface {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
}

//解决搜索结果tableView向上偏移20px问题
//-(void)viewDidLayoutSubviews {
//    if(self.searchController.active) {
//        [self.brandListTableView setFrame:CGRectMake(0, 20, TLScreenWidth, self.view.height -20)];
//    }else {
//        self.brandListTableView.frame =self.view.bounds;
//    }
//}

#pragma mark - <UISearchResultsUpdating>
// 每次更新搜索框里的文字，就会调用这个方法
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    // 获取搜索框里地字符串
    NSString *searchString = searchController.searchBar.text;
    
    // 谓词
    /**
     1.BEGINSWITH ： 搜索结果的字符串是以搜索框里的字符开头的
     2.ENDSWITH   ： 搜索结果的字符串是以搜索框里的字符结尾的
     3.CONTAINS   ： 搜索结果的字符串包含搜索框里的字符
     
     [c]不区分大小写[d]不区分发音符号即没有重音符号[cd]既不区分大小写，也不区分发音符号。
     
     */
    
    // 创建谓词
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH [CD] %@", searchString];
    // 如果搜索框里有文字，就按谓词的匹配结果初始化结果数组，否则，就用字体列表数组初始化结果数组。
    if (_searchResults != nil && searchString.length > 0) {
        [_searchResults removeAllObjects];
        _searchResults = [NSMutableArray arrayWithArray:[_dataSource filteredArrayUsingPredicate:predicate]];
    } else if (searchString.length == 0) {
        _searchResults = [NSMutableArray arrayWithArray:_dataSource];
    }
    
    // 刷新表格视图
    _resultVC.dataSource = _searchResults;
    [_resultVC.tableView reloadData];
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUITableViewCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kUITableViewCellIdentifier];
    }
    cell.textLabel.text = _dataSource[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    NSLog(@"%@", _dataSource[indexPath.row]);
}

#pragma mark - Getter methods

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 64) style:UITableViewStylePlain];
        // 设置代理
        _tableView.delegate = self;
        // 设置数据源
        _tableView.dataSource = self;
        // 设置单元格高度
        _tableView.rowHeight = 50;
    }
    return _tableView;
}

- (UISearchController *)searchController {
    if (!_searchController) {
        // 初始化搜索控制器
        _resultVC = [SearchResultVC new];
        _searchController = [[UISearchController alloc] initWithSearchResultsController:_resultVC];
        // 设置代理
        _searchController.searchResultsUpdater = self;
        // 设置半透明背景，当设置当前视图控制器作为搜索结果的视图控制器时，要设为NO；
        _searchController.dimsBackgroundDuringPresentation = NO;
        // 因此导航栏
        _searchController.hidesNavigationBarDuringPresentation = YES;
        // 关掉自动大写锁定
        _searchController.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
        // 设置searchBar的frame
        _searchController.searchBar.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 44);
    }
    return _searchController;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
