//
//  MainViewController.m
//  AccountBook
//
//  Created by 李恺林 on 2016/11/4.
//  Copyright © 2016年 李恺林. All rights reserved.
//

#import "MainViewController.h"
#import "AddViewController.h"
#import "Value.h"

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@end

@implementation MainViewController {
    UISearchBar *search;
    NSArray *tableData;
    NSArray *searchData;
    BOOL isSearch;
}

@synthesize titleArray, dateArray, chooseArray, cashArray, remarkArray;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"title"]==nil) {
        NSMutableArray *initTitleArray = [[NSMutableArray alloc]init];
        [[NSUserDefaults standardUserDefaults] setObject:initTitleArray forKey:@"title"];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"date"]==nil) {
        NSMutableArray *initDateArray = [[NSMutableArray alloc]init];
        [[NSUserDefaults standardUserDefaults] setObject:initDateArray forKey:@"date"];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"choose"]==nil) {
        NSMutableArray *initChooseArray = [[NSMutableArray alloc]init];
        [[NSUserDefaults standardUserDefaults] setObject:initChooseArray forKey:@"choose"];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"cash"]==nil) {
        NSMutableArray *initCashArray = [[NSMutableArray alloc]init];
        [[NSUserDefaults standardUserDefaults] setObject:initCashArray forKey:@"cash"];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"remark"]==nil) {
        NSMutableArray *initRemarkArray = [[NSMutableArray alloc]init];
        [[NSUserDefaults standardUserDefaults] setObject:initRemarkArray forKey:@"remark"];
    }
    
    titleArray = [NSMutableArray arrayWithArray:[defaults objectForKey:@"title"]];
    dateArray = [NSMutableArray arrayWithArray:[defaults objectForKey:@"date"]];
    chooseArray = [NSMutableArray arrayWithArray:[defaults objectForKey:@"choose"]];
    cashArray = [NSMutableArray arrayWithArray:[defaults objectForKey:@"cash"]];
    remarkArray = [NSMutableArray arrayWithArray:[defaults objectForKey:@"remark"]];
}

-(void)passValue:(Value *)value
{
    [titleArray addObject:value.tmpTitle];
    [dateArray addObject:value.tmpDate];
    [chooseArray addObject:value.tmpChoose];
    [cashArray addObject:value.tmpCash];
    [remarkArray addObject:value.tmpRemark];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGSize size = [self.view bounds].size;
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 300, size.width, 200)];
    [self.view addSubview:self.table];
    self.table.delegate = self;
    self.table.dataSource = self;
    
    isSearch = NO;
    search = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, size.width, 40)];
    search.placeholder = @"please input";
    search.showsCancelButton = YES;
    self.table.tableHeaderView = search;
    search.delegate = self;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"+" style:UIBarButtonItemStylePlain target:self action:@selector(addNote)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.navigationItem.title = @"Write Notes";
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addNote{
    AddViewController *addView = [[AddViewController alloc]initWithNibName:nil bundle:[NSBundle mainBundle]];
    addView.delegate = self;
    [self.navigationController pushViewController:addView animated:YES];
    [self.table reloadData];
    

}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isSearch) {
        return searchData.count;
    }
    else {
        return titleArray.count;
    }
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellID = @"cellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    NSInteger rowNo = indexPath.row;
    if (isSearch) {
        cell.textLabel.text = searchData[rowNo];
    }
    else {
        cell.textLabel.text = titleArray[rowNo];
    }
    return cell;
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    isSearch = NO;
    [self.table reloadData];
}

-(void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self filterBySubstring: searchText];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self filterBySubstring: searchBar.text];
    [searchBar resignFirstResponder];
}

- (void) filterBySubstring: (NSString*) subStr {
    isSearch = YES;
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", subStr];
    searchData = [titleArray filteredArrayUsingPredicate:pred];
    [self.table reloadData];
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
