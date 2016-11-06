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

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

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

@synthesize titleArray, dateArray, chooseArray, cashArray, remarkArray, Sum, paySum, getSum;

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
    
    
    if (titleArray == nil) {
        titleArray = [NSMutableArray arrayWithArray:[defaults objectForKey:@"title"]];
        dateArray = [NSMutableArray arrayWithArray:[defaults objectForKey:@"date"]];
        chooseArray = [NSMutableArray arrayWithArray:[defaults objectForKey:@"choose"]];
        cashArray = [NSMutableArray arrayWithArray:[defaults objectForKey:@"cash"]];
        remarkArray = [NSMutableArray arrayWithArray:[defaults objectForKey:@"remark"]];
        
    }
    
    Sum = 0;
    paySum = 0;
    getSum = 0;
    
    
    for (int i = 0; i < chooseArray.count; i ++) {
        if ([chooseArray[i]  isEqual: @"支出"]) {
            Sum -= [cashArray[i] floatValue];
        }
        else
            Sum += [cashArray[i] floatValue];
    }
    
    for (int i = 0; i < chooseArray.count; i ++) {
        if ([chooseArray[i]  isEqual: @"支出"]) {
            paySum += [cashArray[i] floatValue];
        }
        else
            getSum += [cashArray[i] floatValue];
    }
    
    sumLable.text = [[NSString stringWithFormat:@"%f", Sum] substringToIndex:5];
    payLable.text = [[NSString stringWithFormat:@"%f", paySum] substringToIndex:5];
    getLable.text = [[NSString stringWithFormat:@"%f", getSum] substringToIndex:5];
    
    [defaults setObject:titleArray forKey:@"title"];
    [defaults setObject:dateArray forKey:@"date"];
    [defaults setObject:chooseArray forKey:@"choose"];
    [defaults setObject:cashArray forKey:@"cash"];
    [defaults setObject:remarkArray forKey:@"remark"];
    
    [self.table reloadData];
    
    
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
    
    sumLable = [[UILabel alloc] initWithFrame:CGRectMake(size.width * 0.5 - size.width * 0.31, 44 + 20 + 10, size.width * 0.62, size.width * 0.62 * 0.31)];
    [self.view addSubview:sumLable];
    sumLable.font = [UIFont fontWithName:@"Arial" size:60];
    sumLable.textAlignment = NSTextAlignmentCenter;
    
    payLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 44 + 20 + 100, size.width* 0.5, size.width * 0.62 * 0.62 * 0.5)];
    [self.view addSubview:payLable];
    payLable.font = [UIFont fontWithName:@"Arial" size:25];
    payLable.textAlignment = NSTextAlignmentCenter;
    
    getLable = [[UILabel alloc] initWithFrame:CGRectMake(size.width * 0.5, 44 + 20 + 100, size.width* 0.5, size.width * 0.62 * 0.62 * 0.5)];
    [self.view addSubview:getLable];
    getLable.font = [UIFont fontWithName:@"Arial" size:25];
    getLable.textAlignment = NSTextAlignmentCenter;
    
    noticePay = [[UILabel alloc] initWithFrame:CGRectMake(0, 44 + 20 + size.width * 0.62 * 0.31 - 10, size.width * 0.5, size.width * 0.62 * 0.62 * 0.5)];
    [self.view addSubview:noticePay];
    noticePay.font = [UIFont fontWithName:@"Arial" size:15];
    noticePay.textAlignment = NSTextAlignmentCenter;
    noticePay.text = @"支出";
    
    noticeGet = [[UILabel alloc] initWithFrame:CGRectMake(size.width * 0.5, 44 + 20 + size.width * 0.31 * 0.62 - 10, size.width * 0.5, size.width * 0.62 * 0.62 * 0.5)];
    [self.view addSubview:noticeGet];
    noticeGet.font = [UIFont fontWithName:@"Arial" size:15];
    noticeGet.textAlignment = NSTextAlignmentCenter;
    noticeGet.text = @"收入";
    
    segments = [[UISegmentedControl alloc] initWithFrame:CGRectMake(size.width * 0.5 - 75, 240, 150, 30)];
    [self.view addSubview:segments];
    NSArray *titles = @[@"金额升序", @"金额降序"];
    for (int i = 0 ; i < titles.count; i++) {
        [segments insertSegmentWithTitle:titles[i] atIndex:i animated:YES];
    }
    [segments addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, size.height - (size.height - 44) * 0.62, size.width, (size.height - 44) * 0.62 - 10)];
    [self.view addSubview:self.table];
    self.table.delegate = self;
    self.table.dataSource = self;
    
    isSearch = NO;
    search = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, size.width, 40)];
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
        return titleArray.count;
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
        cell.detailTextLabel.text = [chooseArray[rowNo] stringByAppendingString:cashArray[rowNo]];
        cell.textLabel.text = titleArray[rowNo];
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
    searchData = [titleArray filteredArrayUsingPredicate:pred];
    [self.table reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailViewController *detailView = [[DetailViewController alloc]initWithNibName:nil bundle:nil];
    
    self.delegate = detailView;
    detailView.delegate = self;
    
    NSInteger row = [indexPath row];
    Value *tmpValue = [[Value alloc] init];
    tmpValue.tmpTitle = [titleArray objectAtIndex:row];
    tmpValue.tmpDate = [dateArray objectAtIndex:row];
    tmpValue.tmpChoose = [chooseArray objectAtIndex:row];
    tmpValue.tmpCash = [cashArray objectAtIndex:row];
    tmpValue.tmpRemark = [remarkArray objectAtIndex:row];
    
    [titleArray removeObjectAtIndex:row];
    [dateArray removeObjectAtIndex:row];
    [chooseArray removeObjectAtIndex:row];
    [cashArray removeObjectAtIndex:row];
    [remarkArray removeObjectAtIndex:row];
    

    
    
    [self.delegate passValue:tmpValue];
    
    [self.navigationController pushViewController:detailView animated:kCATransitionFromBottom];
    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [titleArray removeObjectAtIndex:indexPath.row];
        [dateArray removeObjectAtIndex:indexPath.row];
        [chooseArray removeObjectAtIndex:indexPath.row];
        [cashArray removeObjectAtIndex:indexPath.row];
        [remarkArray removeObjectAtIndex:indexPath.row];
        [self.table deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:titleArray forKey:@"title"];
        [defaults setObject:dateArray forKey:@"date"];
        [defaults setObject:chooseArray forKey:@"choose"];
        [defaults setObject:cashArray forKey:@"cash"];
        [defaults setObject:remarkArray forKey:@"remark"];
        
        Sum = 0;
        paySum = 0;
        getSum = 0;
        
        
        for (int i = 0; i < chooseArray.count; i ++) {
            if ([chooseArray[i]  isEqual: @"支出"]) {
                Sum -= [cashArray[i] floatValue];
            }
            else
                Sum += [cashArray[i] floatValue];
        }
        
        for (int i = 0; i < chooseArray.count; i ++) {
            if ([chooseArray[i]  isEqual: @"支出"]) {
                paySum += [cashArray[i] floatValue];
            }
            else
                getSum += [cashArray[i] floatValue];
        }
        
        sumLable.text = [[NSString stringWithFormat:@"%f", Sum] substringToIndex:5];
        payLable.text = [[NSString stringWithFormat:@"%f", paySum] substringToIndex:5];
        getLable.text = [[NSString stringWithFormat:@"%f", getSum] substringToIndex:5];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void) change:(UISegmentedControl*) sender {
    
    if (cashArray.count != 1 && cashArray.count != 0) {
        CGFloat x, y;
        int payCount = 0;
        for (int i = 0; i < chooseArray.count; i ++) {
            if ([chooseArray[i]  isEqual: @"支出"]) {
                [titleArray exchangeObjectAtIndex:payCount withObjectAtIndex:i];
                [dateArray exchangeObjectAtIndex:payCount withObjectAtIndex:i];
                [chooseArray exchangeObjectAtIndex:payCount withObjectAtIndex:i];
                [cashArray exchangeObjectAtIndex:payCount withObjectAtIndex:i];
                [remarkArray exchangeObjectAtIndex:payCount withObjectAtIndex:i];
                
                payCount++;
            }
        }
        switch (sender.selectedSegmentIndex) {
            case 0:
                for (int i = 0; i < payCount; i ++) {
                    for (int j = 0; j < payCount - i; j ++) {
                        x = [cashArray[j] floatValue];
                        y = [cashArray[j + 1] floatValue];
                        if (x > y) {
                            [titleArray exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
                            [dateArray exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
                            [chooseArray exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
                            [cashArray exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
                            [remarkArray exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
                        }
                    }
                }
                for (int i = payCount; i < cashArray.count - payCount - 1; i ++) {
                    for (int j = payCount; j < cashArray.count - payCount - 1 - i; j ++) {
                        x = [cashArray[j] floatValue];
                        y = [cashArray[j + 1] floatValue];
                        if (x > y) {
                            [titleArray exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
                            [dateArray exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
                            [chooseArray exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
                            [cashArray exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
                            [remarkArray exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
                        }
                    }
                }
                
                [self.table reloadData];
                break;
            case 1:
                
                for (int i = 0; i < payCount; i ++) {
                    for (int j = 0; j < payCount - i; j ++) {
                        x = [cashArray[j] floatValue];
                        y = [cashArray[j + 1] floatValue];
                        if (x < y) {
                            [titleArray exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
                            [dateArray exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
                            [chooseArray exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
                            [cashArray exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
                            [remarkArray exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
                        }
                    }
                }
                for (int i = payCount; i < cashArray.count - payCount - 1; i ++) {
                    for (int j = payCount; j < cashArray.count - payCount - 1 - i; j ++) {
                        x = [cashArray[j] floatValue];
                        y = [cashArray[j + 1] floatValue];
                        if (x < y) {
                            [titleArray exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
                            [dateArray exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
                            [chooseArray exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
                            [cashArray exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
                            [remarkArray exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
