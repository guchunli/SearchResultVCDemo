//
//  SearchResultVC.h
//  test
//
//  Created by gcl on 2018/7/18.
//  Copyright © 2018年 gcl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultVC : UIViewController

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) UITableView *tableView; /**< 表格视图 */

@end
