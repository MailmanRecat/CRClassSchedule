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

@end

@implementation MOREColorPickerView

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _colors = [CRSettings MORESettingColorPickerOptionsColor];
    _colorNames = [CRSettings MORESettingColorPickerOptionsName];
    self.curIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    
    [self doBear];
    [self doPark];
}

- (void)doPark{
    _park = [WindPark new];
    [self.view addAutolayoutSubviews:@[ _park ]];
    [self.view addConstraints:[NSLayoutConstraint SpactecledBearEdeg:_park to:self.view type:EdgeTopLeftRightZero]];
    
    _park.backgroundColor = [UIColor randomColor];
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
    static NSString *CELL_ID = @"CELL_ID";
    BCColorPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID];
    if( !cell ){
        cell = [[BCColorPickerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_ID];
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
    
    [self dismissSelf];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)dismissSelf{
    [self dismissViewControllerAnimated:YES completion:^{
        if( self.handler && [self.handler respondsToSelector:@selector(CRColorPickerDidDismissHandler:)] )
            [self.handler CRColorPickerDidDismissHandler:[UIColor randomColor]];
    }];
}

@end
