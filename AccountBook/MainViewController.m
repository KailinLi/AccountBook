//
//  MainViewController.m
//  AccountBook
//
//  Created by 李恺林 on 2016/11/4.
//  Copyright © 2016年 李恺林. All rights reserved.
//

#import "MainViewController.h"
#import "AddViewController.h"
#import "DetailViewController.h"
#import "Value.h"

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, PassValueDelegate>

@end

@implementation MainViewController {
    
    UILabel *sumLable;
    UILabel *payLable;
    UILabel *getLable;
    UILabel *noticePay;
    UILabel *noticeGet;
    
    UISegmentedControl *segments;
    
    UISearchBar *search;
    NSArray *tableData;
    NSArray *searchData;
    BOOL isSearch;
}


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
    
    
    if (self.titleArray == nil) {
        self.titleArray = [NSMutableArray arrayWithArray:[defaults objectForKey:@"title"]];
        self.dateArray = [NSMutableArray arrayWithArray:[defaults objectForKey:@"date"]];
        self.chooseArray = [NSMutableArray arrayWithArray:[defaults objectForKey:@"choose"]];
        self.cashArray = [NSMutableArray arrayWithArray:[defaults objectForKey:@"cash"]];
        self.remarkArray = [NSMutableArray arrayWithArray:[defaults objectForKey:@"remark"]];
        
    }
    
    self.Sum = 0;
    self.paySum = 0;
    self.getSum = 0;
    
    
    for (int i = 0; i < self.chooseArray.count; i ++) {
        if ([self.chooseArray[i]  isEqual: @"支出"]) {
            self.Sum -= [self.cashArray[i] floatValue];
        }
        else
            self.Sum += [self.cashArray[i] floatValue];
    }
    
    for (int i = 0; i < self.chooseArray.count; i ++) {
        if ([self.chooseArray[i]  isEqual: @"支出"]) {
            self.paySum += [self.cashArray[i] floatValue];
        }
        else
            self.getSum += [self.cashArray[i] floatValue];
    }
    
    sumLable.text = [[NSString stringWithFormat:@"%f", self.Sum] substringToIndex:5];
    payLable.text = [[NSString stringWithFormat:@"%f", self.paySum] substringToIndex:5];
    getLable.text = [[NSString stringWithFormat:@"%f", self.getSum] substringToIndex:5];
    
    [defaults setObject:self.titleArray forKey:@"title"];
    [defaults setObject:self.dateArray forKey:@"date"];
    [defaults setObject:self.chooseArray forKey:@"choose"];
    [defaults setObject:self.cashArray forKey:@"cash"];
    [defaults setObject:self.remarkArray forKey:@"remark"];
    
    [self.table reloadData];
    
    
}

-(void)passValue:(Value *)value
{
    [self.titleArray addObject:value.tmpTitle];
    [self.dateArray addObject:value.tmpDate];
    [self.chooseArray addObject:value.tmpChoose];
    [self.cashArray addObject:value.tmpCash];
    [self.remarkArray addObject:value.tmpRemark];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    CGSize size = [self.view bounds].size;
    
    sumLable = [[UILabel alloc] initWithFrame:
                CGRectMake(size.width * 0.5 - size.width * 0.31, 44 + 20 + 10, size.width * 0.62, size.width * 0.62 * 0.31)];
    [self.view addSubview:sumLable];
    sumLable.font = [UIFont fontWithName:@"Arial" size:60];
    sumLable.textAlignment = NSTextAlignmentCenter;
    
    payLable = [[UILabel alloc] initWithFrame:
                CGRectMake(0, 44 + 20 + 100, size.width* 0.5, size.width * 0.62 * 0.62 * 0.5)];
    [self.view addSubview:payLable];
    payLable.font = [UIFont fontWithName:@"Arial" size:25];
    payLable.textAlignment = NSTextAlignmentCenter;
    
    getLable = [[UILabel alloc] initWithFrame:
                CGRectMake(size.width * 0.5, 44 + 20 + 100, size.width* 0.5, size.width * 0.62 * 0.62 * 0.5)];
    [self.view addSubview:getLable];
    getLable.font = [UIFont fontWithName:@"Arial" size:25];
    getLable.textAlignment = NSTextAlignmentCenter;
    
    noticePay = [[UILabel alloc] initWithFrame:
                 CGRectMake(0, 44 + 20 + size.width * 0.62 * 0.31 - 10, size.width * 0.5, size.width * 0.62 * 0.62 * 0.5)];
    [self.view addSubview:noticePay];
    noticePay.font = [UIFont fontWithName:@"Arial" size:15];
    noticePay.textAlignment = NSTextAlignmentCenter;
    noticePay.text = @"支出";
    
    noticeGet = [[UILabel alloc] initWithFrame:
                 CGRectMake(size.width * 0.5, 44 + 20 + size.width * 0.31 * 0.62 - 10, size.width * 0.5, size.width * 0.62 * 0.62 * 0.5)];
    [self.view addSubview:noticeGet];
    noticeGet.font = [UIFont fontWithName:@"Arial" size:15];
    noticeGet.textAlignment = NSTextAlignmentCenter;
    noticeGet.text = @"收入";
    
    segments = [[UISegmentedControl alloc] initWithFrame:
                CGRectMake(size.width * 0.5 - 75, 240, 150, 30)];
    [self.view addSubview:segments];
    NSArray *titles = @[@"金额升序", @"金额降序"];
    for (int i = 0 ; i < titles.count; i++) {
        [segments insertSegmentWithTitle:titles[i] atIndex:i animated:YES];
    }
    [segments addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    
    self.table = [[UITableView alloc] initWithFrame:
                  CGRectMake(0, size.height - (size.height - 44) * 0.62, size.width, (size.height - 44) * 0.62 - 10)];
    [self.view addSubview:self.table];
    self.table.delegate = self;
    self.table.dataSource = self;
    
    isSearch = NO;
    search = [[UISearchBar alloc] initWithFrame:
              CGRectMake(0, 0, size.width, 40)];
    search.placeholder = @"输入关键字";
    search.showsCancelButton = YES;
    self.table.tableHeaderView = search;
    search.delegate = self;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"+" style:UIBarButtonItemStylePlain target:self action:@selector(addNote)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.navigationItem.title = @"记账本";
    
    
    
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
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isSearch) {
        return searchData.count;
    }
    else {
        return self.titleArray.count;
    }
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellID = @"cellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    NSInteger rowNo = indexPath.row;
    if (isSearch) {
        cell.textLabel.text = searchData[rowNo];
    }
    else {
        cell.detailTextLabel.text = [self.chooseArray[rowNo] stringByAppendingString:self.cashArray[rowNo]];
        cell.textLabel.text = self.titleArray[rowNo];
    }
    return cell;
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    isSearch = NO;
    [searchBar resignFirstResponder];
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
    searchData = [self.titleArray filteredArrayUsingPredicate:pred];
    [self.table reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailViewController *detailView = [[DetailViewController alloc]initWithNibName:nil bundle:nil];
    
    self.delegate = detailView;
    detailView.delegate = self;
    
    NSInteger row = [indexPath row];
    Value *tmpValue = [[Value alloc] init];
    tmpValue.tmpTitle = [self.titleArray objectAtIndex:row];
    tmpValue.tmpDate = [self.dateArray objectAtIndex:row];
    tmpValue.tmpChoose = [self.chooseArray objectAtIndex:row];
    tmpValue.tmpCash = [self.cashArray objectAtIndex:row];
    tmpValue.tmpRemark = [self.remarkArray objectAtIndex:row];
    
    [self.titleArray removeObjectAtIndex:row];
    [self.dateArray removeObjectAtIndex:row];
    [self.chooseArray removeObjectAtIndex:row];
    [self.cashArray removeObjectAtIndex:row];
    [self.remarkArray removeObjectAtIndex:row];
    

    
    
    [self.delegate passValue:tmpValue];
    
    [self.navigationController pushViewController:detailView animated:YES];
    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.titleArray removeObjectAtIndex:indexPath.row];
        [self.dateArray removeObjectAtIndex:indexPath.row];
        [self.chooseArray removeObjectAtIndex:indexPath.row];
        [self.cashArray removeObjectAtIndex:indexPath.row];
        [self.remarkArray removeObjectAtIndex:indexPath.row];
        [self.table deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.titleArray forKey:@"title"];
        [defaults setObject:self.dateArray forKey:@"date"];
        [defaults setObject:self.chooseArray forKey:@"choose"];
        [defaults setObject:self.cashArray forKey:@"cash"];
        [defaults setObject:self.remarkArray forKey:@"remark"];
        
        self.Sum = 0;
        self.paySum = 0;
        self.getSum = 0;
        
        
        for (int i = 0; i < self.chooseArray.count; i ++) {
            if ([self.chooseArray[i]  isEqual: @"支出"]) {
                self.Sum -= [self.cashArray[i] floatValue];
            }
            else
                self.Sum += [self.cashArray[i] floatValue];
        }
        
        for (int i = 0; i < self.chooseArray.count; i ++) {
            if ([self.chooseArray[i]  isEqual: @"支出"]) {
                self.paySum += [self.cashArray[i] floatValue];
            }
            else
                self.getSum += [self.cashArray[i] floatValue];
        }
        
        sumLable.text = [[NSString stringWithFormat:@"%f", self.Sum] substringToIndex:5];
        payLable.text = [[NSString stringWithFormat:@"%f", self.paySum] substringToIndex:5];
        getLable.text = [[NSString stringWithFormat:@"%f", self.getSum] substringToIndex:5];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void) change:(UISegmentedControl*) sender {
    
    if (self.cashArray.count != 1 && self.cashArray.count != 0) {
        CGFloat x, y;
        int payCount = 0;
        for (int i = 0; i < self.chooseArray.count; i ++) {
            if ([self.chooseArray[i]  isEqual: @"支出"]) {
                [self.titleArray exchangeObjectAtIndex:payCount withObjectAtIndex:i];
                [self.dateArray exchangeObjectAtIndex:payCount withObjectAtIndex:i];
                [self.chooseArray exchangeObjectAtIndex:payCount withObjectAtIndex:i];
                [self.cashArray exchangeObjectAtIndex:payCount withObjectAtIndex:i];
                [self.remarkArray exchangeObjectAtIndex:payCount withObjectAtIndex:i];
                
                payCount++;
            }
        }
        switch (sender.selectedSegmentIndex) {
            case 0:
                for (int i = 0; i < payCount; i ++) {
                    for (int j = 0; j < payCount - i; j ++) {
                        x = [self.cashArray[j] floatValue];
                        y = [self.cashArray[j + 1] floatValue];
                        if (x > y) {
                            [self.titleArray exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
                            [self.dateArray exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
                            [self.chooseArray exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
                            [self.cashArray exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
                            [self.remarkArray exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
                        }
                    }
                }
                for (int i = payCount; i < self.cashArray.count - payCount - 1; i ++) {
                    for (int j = payCount; j < self.cashArray.count - payCount - 1 - i; j ++) {
                        x = [self.cashArray[j] floatValue];
                        y = [self.cashArray[j + 1] floatValue];
                        if (x > y) {
                            [self.titleArray exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
                            [self.dateArray exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
                            [self.chooseArray exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
                            [self.cashArray exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
                            [self.remarkArray exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
                        }
                    }
                }
                
                [self.table reloadData];
                break;
            case 1:
                
                for (int i = 0; i < payCount; i ++) {
                    for (int j = 0; j < payCount - i; j ++) {
                        x = [self.cashArray[j] floatValue];
                        y = [self.cashArray[j + 1] floatValue];
                        if (x < y) {
                            [self.titleArray exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
                            [self.dateArray exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
                            [self.chooseArray exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
                            [self.cashArray exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
                            [self.remarkArray exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
                        }
                    }
                }
                for (int i = payCount; i < self.cashArray.count - payCount - 1; i ++) {
                    for (int j = payCount; j < self.cashArray.count - payCount - 1 - i; j ++) {
                        x = [self.cashArray[j] floatValue];
                        y = [self.cashArray[j + 1] floatValue];
                        if (x < y) {
                            [self.titleArray exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
                            [self.dateArray exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
                            [self.chooseArray exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
                            [self.cashArray exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
                            [self.remarkArray exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
                        }
                    }
                }
                
                [self.table reloadData];
                break;
            default:
                break;
        }
    }
}


@end
