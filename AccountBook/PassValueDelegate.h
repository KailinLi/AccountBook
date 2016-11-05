//
//  PassValueDelegate.h
//  AccountBook
//
//  Created by 李恺林 on 2016/11/5.
//  Copyright © 2016年 李恺林. All rights reserved.
//

#ifndef PassValueDelegate_h
#define PassValueDelegate_h


#endif /* PassValueDelegate_h */

#import <Foundation/Foundation.h>
@class Value;

@protocol PassValueDelegate <NSObject>

-(void)passValue:(Value *)value;

@end
