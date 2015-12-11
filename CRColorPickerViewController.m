//
//  CRColorPickerViewController.m
//  CRClassSchedule
//
//  Created by caine on 12/11/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#define STATUS_BAR_HEIGHT [UIApplication sharedApplication].statusBarFrame.size.height

#import "CRColorPickerViewController.h"
#import "CRSettings.h"
#import "UIView+MOREStackLayoutView.h"

#import "BCColorPickerCell.h"

@interface CRColorPickerViewController()<UITableViewDataSource, UITableViewDelegate>

@property( nonatomic, strong ) UIView *park;

@property( nonatomic, strong ) UITableView *bear;
@property( nonatomic, strong ) NSDictionary *colors;
@property( nonatomic, strong ) NSArray *colorsArray;
@property( nonatomic, strong ) NSArray *colorNames;

@property( nonatomic, strong ) NSIndexPath *curIndexPath;

@end

@implementation CRColorPickerViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.colorsArray = [CRSettings MORESettingColorPickerOptionsColor];
    self.colorNames = [CRSettings MORESettingColorPickerOptionsName];
    
    self.colors = @{
                    @"default": [UIColor colorWithRed:124 / 255.0 green:177 / 255.0 blue:72 / 255.0 alpha:1],
                    @"tomato": [UIColor colorWithRed:210 / 255.0 green:9 / 255.0 blue:21 / 255.0 alpha:1],
                    @"tangerine": [UIColor colorWithRed:240 / 255.0 green:81 / 255.0 blue:43 / 255.0 alpha:1],
                    @"banana": [UIColor colorWithRed:244 / 255.0 green:189 / 255.0 blue:58 / 255.0 alpha:1],
                    @"basil": [UIColor colorWithRed:22 / 255.0 green:126 / 255.0 blue:68 / 255.0 alpha:1],
                    @"sage": [UIColor colorWithRed:59 / 255.0 green:181 / 255.0 blue:123 / 255.0 alpha:1],
                    @"peacock": [UIColor colorWithRed:26 / 255.0 green:155 / 255.0 blue:225 / 255.0 alpha:1],
                    @"blueberry": [UIColor colorWithRed:65 / 255.0 green:94 / 255.0 blue:167 / 255.0 alpha:1],
                    @"lavender": [UIColor colorWithRed:121 / 255.0 green:135 / 255.0 blue:200 / 255.0 alpha:1],
                    @"grape": [UIColor colorWithRed:140 / 255.0 green:43 / 255.0 blue:167 / 255.0 alpha:1],
                    @"flamingo": [UIColor colorWithRed:227 / 255.0 green:124 / 255.0 blue:116 / 255.0 alpha:1],
                    @"graphite": [UIColor colorWithRed:99 / 255.0 green:99 / 255.0 blue:99 / 255.0 alpha:1],
                    @"black": [UIColor colorWithWhite:0 alpha:1]
                    };
}

- (void)viewWillAppear:(BOOL)animated{
}

- (void)makeBear{
    self.bear = ({
        UITableView *bear = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        bear.translatesAutoresizingMaskIntoConstraints = NO;
        bear.delegate = self;
        bear.dataSource = self;
        bear.contentInset = UIEdgeInsetsMake(STATUS_BAR_HEIGHT + 56, 0, 0, 0);
        bear.contentOffset = CGPointMake(0, - 56 - STATUS_BAR_HEIGHT);
        bear.showsHorizontalScrollIndicator = NO;
        bear.showsVerticalScrollIndicator = NO;
        bear.backgroundColor = [UIColor whiteColor];
        bear.separatorStyle = UITableViewCellSeparatorStyleNone;
        bear;
    });
    [self.view addSubview:self.bear];
    [CRLayout view:@[ self.bear, self.view ] type:CREdgeAround];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.colors allKeys] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CLCELL_ID = @"COLORCELL_ID";
    BCColorPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:CLCELL_ID];
    if( !cell ){
        cell = [[BCColorPickerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CLCELL_ID];
    }
    
    if( indexPath == self.curIndexPath ) [cell statusON];
    cell.dot.textColor = (UIColor *)self.colorsArray[indexPath.row];
    cell.dotname.text = (NSString *)self.colorNames[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BCColorPickerCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    BCColorPickerCell *last = [tableView cellForRowAtIndexPath:self.curIndexPath];
    [cell statusON];
    [last statusOFF];
    self.curIndexPath = indexPath;
    
//    NSLog(@"indexpath %@ %@", cell, last);
    
//    self.curColor = cell.dot.textColor;
//    self.curString = cell.dotname.text;
    
    [self dismissSelf];
}

- (void)dismissSelf{
}

@end
