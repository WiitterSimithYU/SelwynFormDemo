//
//  SelwynFormSectionItem.h
//  SelwynFormDemo
//
//  Created by Selwyn Bi on 2017/6/24.
//  Copyright © 2017年 selwyn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SelwynFormSectionItem;

@interface SelwynFormSectionItem : NSObject

/* sectionHeaderTitle */
@property (nonatomic, copy) NSString *sectionHeaderTitle;

/* 表单sectionFooterTitle */
@property (nonatomic, copy) NSString *sectionFooterTitle;

/* 表单sectionHeaderHeight */
@property (nonatomic, assign) CGFloat sectionHeaderHeight;

/* 表单sectionFooterHeight */
@property (nonatomic, assign) CGFloat sectionFooterHeight;

/* 表单sectionHeaderColor */
@property (nonatomic, strong) UIColor *sectionHeaderColor;

/* 表单sectionFooterColor */
@property (nonatomic, strong) UIColor *sectionFooterColor;

/* 表单section下cellItems */
@property (nonatomic, strong) NSArray *cellItems;

@end
