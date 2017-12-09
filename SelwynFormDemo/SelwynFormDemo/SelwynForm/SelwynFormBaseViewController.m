//
//  SelwynFormBaseViewController.m
//  SelwynFormDemo
//
//  Created by BSW on 2017/6/24.
//  Copyright © 2017年 selwyn. All rights reserved.
//

#import "SelwynFormBaseViewController.h"

#import "SelwynFormItem.h"
#import "SelwynFormSectionItem.h"

#import "SelwynFormInputTableViewCell.h"
#import "SelwynFormTextViewInputTableViewCell.h"
#import "SelwynFormSelectTableViewCell.h"

@interface SelwynFormBaseViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, readonly) UITableViewStyle style;
@end

@implementation SelwynFormBaseViewController

#pragma mark -- form datasource
- (NSMutableArray *)mutableArray
{
    if (!_mutableArray) {
        _mutableArray = [NSMutableArray array];
    }
    return _mutableArray;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super init];
    if (self) {
        _style = style;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // navigationController
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    

    // formTableView
    UITableViewController *tableViewController = [[UITableViewController alloc] initWithStyle:_style];
    [self addChildViewController:tableViewController];
    [tableViewController.view setFrame:self.view.bounds];
    
    _formTableView = tableViewController.tableView;
    _formTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _formTableView.dataSource = self;
    _formTableView.delegate = self;
    _formTableView.showsVerticalScrollIndicator = NO;
    _formTableView.showsHorizontalScrollIndicator = NO;
    _formTableView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_formTableView];
}

#pragma mark -- tableView delegate && tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.mutableArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SelwynFormSectionItem *sectionItem = self.mutableArray[section];
    
    return sectionItem.cellItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    
    SelwynFormSectionItem *sectionItem = self.mutableArray[indexPath.section];
    SelwynFormItem *item = sectionItem.cellItems[indexPath.row];
    
    if (item.formCellType == SelwynFormCellTypeTextViewInput) {
        
        static NSString *cell_id = @"textViewInputCell_id";
        
        SelwynFormTextViewInputTableViewCell *cell = [tableView formTextViewInputCellWithId:cell_id];
        cell.formItem = item;
        cell.formTextViewInputCompletion = ^(NSString *text) {
          
            [weakSelf updateFormTextViewInputWithText:text indexPath:indexPath];
        };
        
        return cell;
        
    }else if (item.formCellType == SelwynFormCellTypeSelect){
        
        static NSString *cell_id = @"selectCell_id";
        
        SelwynFormSelectTableViewCell *cell = [tableView formSelectCellWithId:cell_id];
        cell.formItem = item;
        cell.backgroundColor = [UIColor redColor];
        return cell;
    }
    else
    {
        static NSString *cell_id = @"inputCell_id";
        
        SelwynFormInputTableViewCell *cell = [tableView formInputCellWithId:cell_id];
        cell.formItem = item;
        cell.formInputCompletion = ^(NSString *text) {
            
            [weakSelf updateFormInputWithText:text indexPath:indexPath];
        };
        
        return cell;
    }
}

- (void)updateFormInputWithText:(NSString *)text indexPath:(NSIndexPath *)indexPath{
    
    SelwynFormSectionItem *sectionItem = self.mutableArray[indexPath.section];
    SelwynFormItem *item = sectionItem.cellItems[indexPath.row];
    
    item.formDetail = text;
}

- (void)updateFormTextViewInputWithText:(NSString *)text indexPath:(NSIndexPath *)indexPath{
    
    SelwynFormSectionItem *sectionItem = self.mutableArray[indexPath.section];
    SelwynFormItem *item = sectionItem.cellItems[indexPath.row];
    
    item.formDetail = text;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelwynFormSectionItem *sectionItem = self.mutableArray[indexPath.section];
    SelwynFormItem *item = sectionItem.cellItems[indexPath.row];
    
    if (item.formCellType == SelwynFormCellTypeTextViewInput) {
        return [SelwynFormTextViewInputTableViewCell cellHeightWithItem:item];
    }else if (item.formCellType == SelwynFormCellTypeSelect){
        return [SelwynFormSelectTableViewCell cellHeightWithItem:item];
    }
    return [SelwynFormInputTableViewCell cellHeightWithItem:item];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    SelwynFormSectionItem *sectionItem = self.mutableArray[section];
    return sectionItem.sectionHeaderHeight > 0 ? sectionItem.sectionHeaderHeight:0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SelwynFormSectionItem *sectionItem = self.mutableArray[section];
    
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, sectionItem.sectionHeaderHeight)];
    header.backgroundColor = sectionItem.sectionHeaderColor;
    
    if (sectionItem.sectionHeaderTitle) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:header.bounds];
        titleLabel.font = Font(14);
        titleLabel.adjustsFontSizeToFitWidth = YES;
        titleLabel.text = sectionItem.sectionHeaderTitle;
        
        [header addSubview:titleLabel];
    }
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    SelwynFormSectionItem *sectionItem = self.mutableArray[section];
    return sectionItem.sectionFooterHeight > 0 ? sectionItem.sectionFooterHeight:0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    SelwynFormSectionItem *sectionItem = self.mutableArray[section];
    
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, sectionItem.sectionFooterHeight)];
    
    footer.backgroundColor = sectionItem.sectionFooterColor;
    
    if (sectionItem.sectionFooterTitle) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:footer.bounds];
        titleLabel.font = Font(14);
        titleLabel.adjustsFontSizeToFitWidth = YES;
        titleLabel.text = sectionItem.sectionFooterTitle;
        
        [footer addSubview:titleLabel];
    }
    
    return footer;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    SelwynFormSectionItem *sectionItem = self.mutableArray[section];
    return sectionItem.sectionHeaderTitle;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelwynFormSectionItem *sectionItem = self.mutableArray[indexPath.section];
    SelwynFormItem *item = sectionItem.cellItems[indexPath.row];
    
    if (item.selectHandle) {
        item.selectHandle(item);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
