//
//  MOREColorPickerView.m
//  MOREAmazing
//
//  Created by caine on 11/12/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "NSLayoutConstraint+SpectacledBearEdgeConstraint.h"
#import "UIView+MOREStackLayoutView.h"
#import "UIFont+MaterialDesignIcons.h"
#import "WindPark.h"
#import "CRSettings.h"

#import "MOREColorPickerView.h"
#import "BCColorPickerCell.h"

@interface MOREColorPickerView()<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property( nonatomic, strong ) WindPark *park;

@property( nonatomic, strong ) UITableView *bear;
@property( nonatomic, strong ) NSArray *colors;
@property( nonatomic, strong ) NSArray *colorNames;

@property( nonatomic, strong ) NSIndexPath *curIndexPath;
@property( nonatomic, strong ) UIColor *curColor;

@end

@implementation MOREColorPickerView

+ (NSDictionary *)CRColorTypes{
    return @{
             @"default": [UIColor colorWithRed:70 / 255.0 green:136 / 255.0 blue:241 / 255.0 alpha:1],
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

+ (instancetype)shareColorPicker{
    static MOREColorPickerView *picker = nil;
    
    static dispatch_once_t t_picker;
    dispatch_once(&t_picker, ^{
        picker = [MOREColorPickerView new];
    });
    return picker;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _colors = [CRSettings MORESettingColorPickerOptionsColor];
    _colorNames = [CRSettings MORESettingColorPickerOptionsName];
    
    [self doBear];
    [self doPark];
}

- (void)viewWillAppear:(BOOL)animated{
    NSIndexPath *cur;
    NSString *string = [self.curString lowercaseString];
    if( [string isEqualToString:@"default"] )
        cur = [NSIndexPath indexPathForRow:0 inSection:0];
    else if( [string isEqualToString:@"tomato"] )
        cur = [NSIndexPath indexPathForRow:1 inSection:0];
    else if( [string isEqualToString:@"tangerine"] )
        cur = [NSIndexPath indexPathForRow:2 inSection:0];
    else if( [string isEqualToString:@"banana"] )
        cur = [NSIndexPath indexPathForRow:3 inSection:0];
    else if( [string isEqualToString:@"basil"] )
        cur = [NSIndexPath indexPathForRow:4 inSection:0];
    else if( [string isEqualToString:@"sage"] )
        cur = [NSIndexPath indexPathForRow:5 inSection:0];
    else if( [string isEqualToString:@"peacock"] )
        cur = [NSIndexPath indexPathForRow:6 inSection:0];
    else if( [string isEqualToString:@"blueberry"] )
        cur = [NSIndexPath indexPathForRow:7 inSection:0];
    else if( [string isEqualToString:@"lavender"] )
        cur = [NSIndexPath indexPathForRow:8 inSection:0];
    else if( [string isEqualToString:@"grape"] )
        cur = [NSIndexPath indexPathForRow:9 inSection:0];
    else if( [string isEqualToString:@"flamingo"] )
        cur = [NSIndexPath indexPathForRow:10 inSection:0];
    else if( [string isEqualToString:@"graphite"] )
        cur = [NSIndexPath indexPathForRow:11 inSection:0];
    else if( [string isEqualToString:@"black"] )
        cur = [NSIndexPath indexPathForRow:12 inSection:0];
    else
        cur = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self.bear selectRowAtIndexPath:cur
                           animated:NO
                     scrollPosition:UITableViewScrollPositionMiddle];
    self.park.backgroundColor = self.curColor = [MOREColorPickerView CRColorTypes][string];
    self.curIndexPath = cur;
}

- (void)doPark{
    _park = [WindPark new];
    [self.view addAutolayoutSubviews:@[ _park ]];
    [self.view addConstraints:[NSLayoutConstraint SpactecledBearEdeg:_park to:self.view type:EdgeTopLeftRightZero]];
    
    _park.herb.titleLabel.font = [UIFont MaterialDesignIcons];
    [_park nameplate:@"Color"];
    [_park.herb setTitle:[UIFont mdiArrowLeft] forState:UIControlStateNormal];
    [_park.herb setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _park.nameplate.textColor = [UIColor whiteColor];
    
    [_park.herb addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
}

- (void)doBear{
    _bear = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    [self.view addAutolayoutSubviews:@[ _bear ]];
    [self.view addConstraints:[NSLayoutConstraint SpactecledBearEdeg:_bear to:self.view type:EdgeAroundZero]];
    
    _bear.delegate = self;
    _bear.dataSource = self;
    _bear.contentInset = UIEdgeInsetsMake(STATUS_BAR_HEIGHT + 56, 0, 0, 0);
    _bear.contentOffset = CGPointMake(0, - 56 - STATUS_BAR_HEIGHT);
    _bear.showsHorizontalScrollIndicator = NO;
    _bear.showsVerticalScrollIndicator = NO;
    _bear.backgroundColor = [UIColor whiteColor];
    _bear.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat pointY = scrollView.contentOffset.y;
    if( pointY > - ( STATUS_BAR_HEIGHT + 56 ) ){
        [_park sunset];
    }else{
        [_park sunrise];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_colors count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CLCELL_ID = @"COLORCELL_ID";
    BCColorPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:CLCELL_ID];
    if( !cell ){
        cell = [[BCColorPickerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CLCELL_ID];
    }
    
    if( indexPath == self.curIndexPath ) [cell statusON];
    cell.dot.textColor = (UIColor *)self.colors[indexPath.row];
    cell.dotname.text = (NSString *)self.colorNames[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BCColorPickerCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    BCColorPickerCell *last = [tableView cellForRowAtIndexPath:self.curIndexPath];
    [cell statusON];
    [last statusOFF];
    self.curIndexPath = indexPath;
    
    self.curColor = cell.dot.textColor;
    self.curString = cell.dotname.text;
    
    [self dismissSelf];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)dismissSelf{
    [self dismissViewControllerAnimated:YES completion:^{
        if( self.handler && [self.handler respondsToSelector:@selector(CRColorPickerDidDismissHandler:name:)] ){
            [self.handler CRColorPickerDidDismissHandler:self.curColor name:self.curString];
        }
    }];
}

@end
