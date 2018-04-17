//
//  CCCustomActionSheet.m
//  CCActionSheet
//
//  Created by may on 2017/7/18.
//  Copyright © 2017年 caomeili. All rights reserved.
//

#import "CCCustomActionSheet.h"
#define actionSheet_WIDTH [UIScreen mainScreen].bounds.size.width - 20
#define actionSheet_ALIGIN 10
#define actionSheet_MIN_HEIGHT 44
#define button_HEIGHT 57
@interface CCCustomActionSheet ()
@property (nonatomic, strong) UIView *actionSheetBackView;
@property (nonatomic, strong) UIView *actionSheetView;
@property (nonatomic, strong) UIView *animationView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic,copy) NSString *title;
@property (nonatomic, strong) NSMutableDictionary *buttonsDictionary;
@property (nonatomic, strong) NSMutableArray *buttonsArray;

@end

@implementation CCCustomActionSheet
- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.buttonsDictionary = [NSMutableDictionary dictionary];
        self.buttonsArray = [NSMutableArray array];
        [self setupUI];
        
    }
    return self;
}
- (UIView *)setupUI {
    [self.actionSheetBackView addSubview:self.animationView];
    [self.animationView addSubview:self.actionSheetView];
    [self.actionSheetView addSubview:self.titleLabel];
    return self.actionSheetBackView;
}
- (void)layoutSubviews {
    
    CGFloat originY = actionSheet_ALIGIN;
    if ([self.buttonsDictionary objectForKey:@(0)]) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:[UIColor whiteColor]];
        button.layer.cornerRadius = 15.0;
        button.clipsToBounds = YES;
        [button setTitle:[self.buttonsDictionary objectForKey:@(0)] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:47.0/255.0 green:124.0/255.0 blue:247.0/255.0 alpha:1] forState:UIControlStateNormal];
        button.tag = 1000 + [self.buttonsDictionary.allKeys[0] integerValue];
        button.frame = CGRectMake(actionSheet_ALIGIN, CGRectGetMaxY(self.actionSheetBackView.frame) - actionSheet_ALIGIN - button_HEIGHT, actionSheet_WIDTH, button_HEIGHT);
        button.titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        [self.animationView addSubview:button];
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonsDictionary removeObjectForKey:@(0)];
        originY += (button_HEIGHT+actionSheet_ALIGIN);
    }
    
    CGFloat actionSheetHeight = 0;
    self.titleLabel.text = self.title;
    CGRect titleLabelFrame = [self.titleLabel.text boundingRectWithSize:CGSizeMake(actionSheet_WIDTH - 20, 20000.f) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : self.titleLabel.font} context:nil];
    if (titleLabelFrame.size.height > 0) {
        self.titleLabel.frame = CGRectMake(15, 0, actionSheet_WIDTH - 30, CGRectGetHeight(titleLabelFrame) + 30);
        actionSheetHeight += CGRectGetHeight(self.titleLabel.frame);
    }
    for (int i = 0; i < self.buttonsDictionary.allKeys.count; i++) {
        NSNumber *number = self.buttonsDictionary.allKeys[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:[self.buttonsDictionary objectForKey:number] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:47.0/255.0 green:124.0/255.0 blue:247.0/255.0 alpha:1] forState:UIControlStateNormal];
        button.titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        button.tag = 1000 + [self.buttonsDictionary.allKeys[i] integerValue];
        button.frame = CGRectMake(0,actionSheetHeight, actionSheet_WIDTH, button_HEIGHT);
        CALayer * horizonLayer = [CALayer layer];
        horizonLayer.frame = CGRectMake(0, CGRectGetMinY(button.frame), CGRectGetWidth(self.actionSheetView.frame), 0.5);
        horizonLayer.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5].CGColor;
        [self.actionSheetView.layer addSublayer:horizonLayer];
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.actionSheetView addSubview:button];
        actionSheetHeight += button_HEIGHT;
    }
    self.actionSheetView.frame = CGRectMake(actionSheet_ALIGIN, CGRectGetMaxY(self.actionSheetBackView.frame) - originY - actionSheetHeight, actionSheet_WIDTH, actionSheetHeight);
    
}
- (void)clickButton:(UIButton *)button {
    [self clickedTitle:(button.tag - 1000)];
//    [self dismiss];
}
- (UIView *)actionSheetBackView {
    if (!_actionSheetBackView) {
        _actionSheetBackView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _actionSheetBackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_actionSheetBackView addGestureRecognizer:tap];
    }
    return _actionSheetBackView;
}
- (UIView *)actionSheetView {
    if (!_actionSheetView) {
        _actionSheetView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, actionSheet_WIDTH, actionSheet_MIN_HEIGHT)];
        _actionSheetView.backgroundColor =  [UIColor whiteColor];
        _actionSheetView.layer.cornerRadius =  15;
        _actionSheetView.clipsToBounds = YES;
    }
    return _actionSheetView;
}
- (UIView *)animationView {
    if (!_animationView) {
        _animationView = [[UIView alloc] initWithFrame:self.actionSheetBackView.frame];
        _animationView.backgroundColor = [UIColor clearColor];
    }
    return _animationView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleLabel.textColor =  [UIColor blackColor];//
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (void)animation {
    CGFloat originY = CGRectGetMinY(self.animationView.frame);
    CGRect frame = self.animationView.frame;
    frame.origin.y = CGRectGetMaxY(self.actionSheetBackView.frame);
    self.animationView.frame = frame;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.animationView.frame;
        f.origin.y = originY;
        self.animationView.frame = f;
    }completion:^(BOOL finished) {
        
    }];
}

// 重写父类方法
- (void)show {
    [super show];
    [self layoutSubviews];
    [self animation];
}
- (UIView *)customBtnWithTitle:(NSString *)title index:(NSInteger)index{
    NSLog(@"customBtn ： %@,%ld",title,index);
    
    [self.buttonsDictionary setObject:title forKey:@(index)];
    return self.actionSheetBackView;
}
- (UIView *)actionSheetTitle:(NSString *)title {
    NSLog(@"actionTitle： %@",title);
    self.title = title;
    return self.actionSheetBackView;
}
- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
    
}
@end
