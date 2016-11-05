//
//  AddViewController.m
//  AccountBook
//
//  Created by 李恺林 on 2016/11/4.
//  Copyright © 2016年 李恺林. All rights reserved.
//

#import "AddViewController.h"
#import "MainViewController.h"
#import "Value.h"
#import "AppDelegate.h"

@interface AddViewController ()

@end

@implementation AddViewController {
    UILabel *noticeTitle;
    UILabel *noticeDate;
    UILabel *noticeCash;
    UILabel *noticeRemark;
    UITextView *inputTitle;
    UITextView *inputCash;
    UITextField *inputRemark;
    UIDatePicker *datePicker;
    UISegmentedControl *segments;
    
    NSString *tmpTitle;
    NSString *tmpDate;
    NSString *tmpChoose;
    NSString *tmpCash;
    NSString *tmpRemark;
    
    NSUserDefaults *defaults;
    
    AppDelegate *appdelegate;
    
}

@synthesize titleArray, dateArray, chooseArray, cashArray, remarkArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGSize size = self.view.bounds.size;
    noticeTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, size.width, 30)];
    [self.view addSubview:noticeTitle];
    noticeTitle.text = @"input the title";
    
    noticeDate = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, size.width, 30)];
    [self.view addSubview:noticeDate];
    noticeDate.text = @"input the Date";
    
    noticeCash = [[UILabel alloc] initWithFrame:CGRectMake(0, 300, size.width, 30)];
    [self.view addSubview:noticeCash];
    noticeCash.text = @"input the Cash";
    
    noticeRemark = [[UILabel alloc] initWithFrame:CGRectMake(0, 450, size.width, 30)];
    [self.view addSubview:noticeRemark];
    noticeRemark.text = @"input the remark";
    
    inputTitle = [[UITextView alloc]initWithFrame:CGRectMake(0, 130, size.width, 30)];
    [self.view addSubview:inputTitle];
    
    datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 180, size.width, size.width * 0.67)];
    [self.view addSubview:datePicker];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:365 * 24 * 3600];
    datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:-356 * 24 * 3600];
    
    segments = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0, 330, 50, 30)];
    [self.view addSubview:segments];
    NSArray *titles = @[@"收入", @"支出"];
    for (int i = 0 ; i < titles.count; i++) {
        [segments insertSegmentWithTitle:titles[i] atIndex:i animated:YES];
    }
    [segments addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    
    inputCash = [[UITextView alloc] initWithFrame:CGRectMake(50, 330, size.width - 50, 30)];
    [self.view addSubview:inputCash];
    
    inputRemark = [[UITextField alloc] initWithFrame:CGRectMake(0, 480, size.width, 30)];
    [self.view addSubview:inputRemark];
    
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"save" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) change:(UISegmentedControl*) sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            tmpChoose = @"收入";
            break;
        case 1:
            tmpChoose = @"支出";
            break;
        default:
            break;
    }
}

- (void) save{
    tmpTitle = inputTitle.text;
    
    NSDate *selected = datePicker.date;
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy年MM月dd日 HH:mm";
    tmpDate = [dateFormatter stringFromDate:selected];
    
    tmpCash = inputCash.text;
    
    tmpRemark = inputRemark.text;
    
    Value *tmpValue = [[Value alloc] init];
    tmpValue.tmpTitle = tmpTitle;
    tmpValue.tmpDate = tmpDate;
    tmpValue.tmpChoose = tmpChoose;
    tmpValue.tmpCash = tmpCash;
    tmpValue.tmpRemark = tmpRemark;
    
    
    
    //通过委托协议传值
    [self.delegate passValue:tmpValue];

    
    
//    titleArray = [defaults objectForKey:@"title"];
//    dateArray = [defaults objectForKey:@"date"];
//    chooseArray = [defaults objectForKey:@"choose"];
//    cashArray = [defaults objectForKey:@"cash"];
//    remarkArray = [defaults objectForKey:@"remark"];
//    
//    [titleArray addObject:tmpTitle];
//    [dateArray addObject:tmpDate];
//    [chooseArray addObject:tmpChoose];
//    [cashArray addObject:tmpCash];
//    [remarkArray addObject:tmpRemark];
    
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"title"]==nil) {
//        NSMutableArray *initTitleArray = [[NSMutableArray alloc]init];
//        [[NSUserDefaults standardUserDefaults] setObject:initTitleArray forKey:@"title"];
//    }
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"date"]==nil) {
//        NSMutableArray *initDateArray = [[NSMutableArray alloc]init];
//        [[NSUserDefaults standardUserDefaults] setObject:initDateArray forKey:@"date"];
//    }
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"choose"]==nil) {
//        NSMutableArray *initChooseArray = [[NSMutableArray alloc]init];
//        [[NSUserDefaults standardUserDefaults] setObject:initChooseArray forKey:@"choose"];
//    }
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"cash"]==nil) {
//        NSMutableArray *initCashArray = [[NSMutableArray alloc]init];
//        [[NSUserDefaults standardUserDefaults] setObject:initCashArray forKey:@"cash"];
//    }
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"remark"]==nil) {
//        NSMutableArray *initRemarkArray = [[NSMutableArray alloc]init];
//        [[NSUserDefaults standardUserDefaults] setObject:initRemarkArray forKey:@"remark"];
//    }
    
//    MainViewController *sendValue = [[MainViewController alloc] init];
//    sendValue.titleArray = titleArray;
//    sendValue.dateArray = dateArray;
//    sendValue.chooseArray = chooseArray;
//    sendValue.cashArray = cashArray;
//    sendValue.remarkArray = remarkArray;
    
//    [defaults setObject:titleArray forKey:@"title"];
//    [defaults setObject:dateArray forKey:@"date"];
//    [defaults setObject:chooseArray forKey:@"choose"];
//    [defaults setObject:cashArray forKey:@"cash"];
//    [defaults setObject:remarkArray forKey:@"remark"];
    
    [inputTitle resignFirstResponder];
    [inputCash resignFirstResponder];
    [inputRemark resignFirstResponder];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Notice" message:@"保存成功" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction: [UIAlertAction actionWithTitle:@"sure" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:true completion:nil];
    
    //退回到第一个窗口
    [self.navigationController popViewControllerAnimated:YES];
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
