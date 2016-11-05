//
//  AddViewController.h
//  AccountBook
//
//  Created by 李恺林 on 2016/11/4.
//  Copyright © 2016年 李恺林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassValueDelegate.h"

@interface AddViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *dateArray;
@property (nonatomic, strong) NSMutableArray *chooseArray;
@property (nonatomic, strong) NSMutableArray *cashArray;
@property (nonatomic, strong) NSMutableArray *remarkArray;

@property(nonatomic,assign) NSObject<PassValueDelegate> *delegate;

@end
