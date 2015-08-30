//
//  ViewController.m
//  HEDrawer
//
//  Created by Hackice on 15/8/29.
//  Copyright (c) 2015年 Hackice. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // test left
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:self.mainView.bounds];
    leftImageView.image = [UIImage imageNamed:@"left"];
    [self.leftView addSubview:leftImageView];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.mainView.bounds];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    [self.leftView addSubview:tableView];
    tableView.dataSource = self;
    
    // test right
    UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:self.mainView.bounds];
    rightImageView.image = [UIImage imageNamed:@"right"];
    UISwitch *sw = [[UISwitch alloc] init];
    sw.center = self.mainView.center;
    
    [self.rightView addSubview:rightImageView];
    [self.rightView addSubview:sw];
    
    // test main
    UIImageView *mainImageView = [[UIImageView alloc] initWithFrame:self.mainView.bounds];
    mainImageView.image = [UIImage imageNamed:@"main"];
    [self.mainView addSubview:mainImageView];
    self.mainView.clipsToBounds = YES;

}

- (UIStatusBarStyle)preferredStatusBarStyle {

    return UIStatusBarStyleLightContent;
}

#pragma mark - UITableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 99;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *ID = @"test";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"第%lu行", indexPath.row + 1];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}
@end