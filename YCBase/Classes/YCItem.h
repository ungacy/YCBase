//
//  YCItem.h
//  YCBase
//
//  Created by Ye Tao on 05/23/2021.
//  Copyright (c) 2021 Ye Tao. All rights reserved.
//

#import "YCItemDefine.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCItem : NSObject <YCItemProtocol>

#pragma mark - YCItemProtocol

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, copy) NSString *identifier;

#pragma mark - Index

@property (nonatomic, assign) NSInteger section;

@property (nonatomic, assign) NSInteger row;

#pragma mark - UI

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, copy, nullable) NSString *title;

@property (nonatomic, copy, nullable) NSString *subTitle;

@property (nonatomic, copy, nullable) NSString *content;

@property (nonatomic, copy, nullable) NSString *avatar;

@property (nonatomic, copy, nullable) NSString *icon;

@property (nonatomic, strong, nullable) id data;

@end
NS_ASSUME_NONNULL_END
