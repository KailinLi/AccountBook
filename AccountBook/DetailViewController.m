//
//  DetailViewController.m
//  AccountBook
//
//  Created by 李恺林 on 2016/11/5.
//  Copyright © 2016年 李恺林. All rights reserved.
//

#import "DetailViewController.h"
#import "Value.h"



@interface DetailViewController () <UITextFieldDelegate, UITextViewDelegate, PassValueDelegate>

@end

@implementation DetailViewController {
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
    
    BOOL isChange;
}

-(void)passValue:(Value *)value
{
    tmpTitle = value.tmpTitle;
    tmpDate = value.tmpDate;
    tmpChoose = value.tmpChoose;
    tmpCash = value.tmpCash;
    tmpRemark = value.tmpRemark;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    isChange = NO;
    CGSize size = self.view.bounds.size;
    noticeTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, size.width, 30)];
    [self.view addSubview:noticeTitle];
    inputTitle.textAlignment = NSTextAlignmentCenter;
    noticeTitle.text = @"input the title";

    
    inputTitle = [[UITextView alloc]initWithFrame:CGRectMake(0, 100, size.width, 50)];
    inputTitle.text = tmpTitle;
    inputTitle.font = [UIFont fontWithName:@"Arial" size:30];
    inputTitle.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:inputTitle];
    
    datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, size.height - (size.height - 44) * 0.62 - 100, size.width, size.width * 0.28)];
    [self.view addSubview:datePicker];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    
    NSString *dateString = tmpDate;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    NSDate *date=[formatter dateFromString:dateString];
    [datePicker setDate:date];
    
    datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:365 * 24 * 3600];
    datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:-356 * 24 * 3600];
    
    segments = [[UISegmentedControl alloc] initWithFrame:CGRectMake(50, 330, 100, 30)];
    [self.view addSubview:segments];
    NSArray *titles = @[@"收入", @"支出"];
    for (int i = 0 ; i < titles.count; i++) {
        [segments insertSegmentWithTitle:titles[i] atIndex:i animated:YES];
    }
    if ([tmpChoose  isEqual: @"支出"]) {
        segments.selectedSegmentIndex = 1;
    }
    else {
        segments.selectedSegmentIndex = 0;
    }
    [segments addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    
    inputCash = [[UITextView alloc] initWithFrame:CGRectMake(150, 328, size.width - 150, 50)];
    inputCash.text = tmpCash;
    inputCash.font = [UIFont fontWithName:@"Arial" size:20];
    inputCash.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:inputCash];
    
    inputRemark = [[UITextField alloc] initWithFrame:CGRectMake(0, size.height - (size.height - 44) * 0.62 + size.width * 0.28 + 30, size.width, 30)];
    inputRemark.text = tmpRemark;
    inputRemark.font = [UIFont fontWithName:@"Arial" size:20];
    inputRemark.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:inputRemark];

    inputTitle.delegate = self;
    inputCash.delegate = self;
    inputRemark.delegate = self;
    
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"保存修改" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = saveButton;
    self.navigationItem.title = @"详情";
    
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
    
    isChange = YES;
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
    
    
    
    [self.delegate passValue:tmpValue];
    
    
    
    [inputTitle resignFirstResponder];
    [inputCash resignFirstResponder];
    [inputRemark resignFirstResponder];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"修改成功" message:@"\n学会理财，适度消费哦^o^" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction: [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];
}

- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (![self.view isExclusiveTouch]) {
        [inputTitle resignFirstResponder];
        [inputCash resignFirstResponder];
        [inputRemark resignFirstResponder];
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    CGRect rect=CGRectMake(0.0f,-30,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
    return YES;
}


- (void) viewWillDisappear:(BOOL)animated {
    
    if (isChange == NO) {
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
        
        
        
        [self.delegate passValue:tmpValue];
        
        
        
        [inputTitle resignFirstResponder];
        [inputCash resignFirstResponder];
        [inputRemark resignFirstResponder];
    }

}


@end
