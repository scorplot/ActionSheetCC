//
//  CCActionSheet.m
//  Pods
//
//  Created by may on 2017/7/18.
//
//

#import "CCActionSheet.h"

@interface CCActionSheetAction ()

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) void (^handler)(CCActionSheetAction *);

@end

@implementation CCActionSheetAction

+ (instancetype _Nullable )actionSheetWithTitle:(NSString *_Nullable)title handler:(void (^_Nullable)(CCActionSheetAction * _Nullable action))handler {
    return [[self alloc] initWithTitle:title handler:handler];
}
- (instancetype)initWithTitle:(NSString *)title handler:(void (^)(CCActionSheetAction *))handler {
    if (self = [super init]) {
        _title = title;
        _handler = handler;
    }
    return self;
}

@end

typedef void(^customHandler)(UIView * _Nullable view);
@interface CCActionSheet ()
@property (nonatomic, strong) NSMutableDictionary *actionDictionary; // 存储CCActionSheetAction key为index
@property (nonatomic, strong) UIView* view;
@property (nonatomic, copy) void(^showHandler)(UIView *view); // 显示actionSheet回调
@property (nonatomic, copy) void(^dismissHandler)(); // 隐藏actionSheet回调
@property (nonatomic, copy) void(^addActionHandler)(CCActionSheetAction *action); // 添加action回调
//@property (nonatomic, copy) void(^addViewHandler)(UIView *view,customHandler handler); // 添加自定义view回调
@end

static  __strong CCActionSheet *_pointer;

@implementation CCActionSheet

- (instancetype)init {
    self = [super init];
    if (self) {
        self.superView = [[UIApplication sharedApplication].delegate window];
        self.actionDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}
- (void)show {
    _pointer = self;
    [self.superView addSubview:_view];
    if (self.showHandler) {
        self.showHandler(self.superView);
    }
}
- (void)dismiss {
    _pointer = nil;
    [_view removeFromSuperview];
    _view = nil;
    if (self.dismissHandler) {
        self.dismissHandler();
    }
}
- (void)addAction:(CCActionSheetAction *_Nullable)action {
    self.addActionHandler(action);
}
-(void)addAction:(CCActionSheetAction*_Nullable)action index:(NSInteger)index {
    [self.actionDictionary setObject:action forKey:@(index)];
}
-(void)clickedTitle:(NSInteger)index {
    CCActionSheetAction* action = [self.actionDictionary objectForKey:@(index)];
    if (action.handler) {
        action.handler(action);
    }
    [self dismiss];
}
// 为了不报警告重写的，子类需重写这些方法
- (UIView *)actionSheetTitle:(NSString *)title {
    return nil;
}
- (UIView *)customBtnWithTitle:(NSString *)title index:(NSInteger)index {
    return nil;
}
- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}
@end

@interface CCActionSheetFactory ()<UIActionSheetDelegate>

@property (nonatomic, strong) CCActionSheet *action;
@property (nonatomic, strong) id custom;

@end

@implementation CCActionSheetFactory

static Class _Nullable customViewClass = nil;

+ (instancetype)shareInstance {
    static CCActionSheetFactory *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CCActionSheetFactory alloc] init];
    });
    return instance;
}
- (CCActionSheet *_Nullable)createActionSheet {
    return [self createActionSheetWithTitle:nil style:UIActionSheetStyleDefault cancelAction:nil otherActions:nil, nil];
}
- (CCActionSheet *_Nullable)createActionSheetWithTitle:(NSString *_Nullable)title style:(UIActionSheetStyle)actionSheetStyle cancelAction:(CCActionSheetAction *_Nullable)cancelAction otherActions:(CCActionSheetAction *_Nullable)otherAction, ... {
//    __block NSInteger viewCount = 0;
    __block NSInteger btnCount = 1;
    // 自定义ActionSheet
    if (customViewClass) {
        self.custom = [[customViewClass alloc] init];
        // 判断自定义类是否继承与ActionSheet
        NSAssert([self.custom isKindOfClass:[CCActionSheet class]]||[customViewClass isSubclassOfClass:[CCActionSheet class]],@"customView must inherit from CCActionSheet");
        if ([self.custom isKindOfClass:[CCActionSheet class]] || [customViewClass isSubclassOfClass:[CCActionSheet class]]) {
            __block CCActionSheet *customView = self.custom;
            __weak CCActionSheet *cc = customView;
            __block  UIView *v;
            // 添加title
            if ([customView respondsToSelector:@selector(actionSheetTitle:)]) {
                v = [customView actionSheetTitle:title];
            }
            // 取消操作按钮 index为0
            if (cancelAction) {
                if ([customView respondsToSelector:@selector(customBtnWithTitle:index:)]) {
                    [customView addAction:cancelAction index:0];
                    v = [customView customBtnWithTitle:cancelAction.title index:0];
                }
            }
            va_list list;
            va_start(list, otherAction);
            // 其他操作按钮 index从1开始逐个递增
            for (CCActionSheetAction *action = otherAction; action != nil; action = va_arg(list, CCActionSheetAction*)) {
                if ([customView respondsToSelector:@selector(customBtnWithTitle:index:)]) {
                    [customView addAction:action index:btnCount];
                    v = [customView customBtnWithTitle:action.title index:btnCount];
                    btnCount ++;
                }
            }
            va_end(list);
            // actionSheet隐藏时将view置为nil，使其被释放
            customView.dismissHandler = ^{
                customView = nil;
                _custom = nil;
            };
            // 单独添加操作按钮
            customView.addActionHandler = ^(CCActionSheetAction *action) {
                if ([cc respondsToSelector:@selector(customBtnWithTitle:index:)]) {
                    [cc addAction:action index:btnCount];
                    v = [cc customBtnWithTitle:action.title index:btnCount];
                    btnCount ++;
                }
            };

            customView.view = v;
            return customView;
        }
    }
    // 使用系统默认ActionSheet
    self.action = [[CCActionSheet alloc] init];
    self.action.title = title;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:self.action.title delegate:self cancelButtonTitle:cancelAction.title destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    if (cancelAction) {
        [self.action addAction:cancelAction index:0];
    }
    actionSheet.actionSheetStyle = actionSheetStyle;
    va_list list;
    va_start(list, otherAction);
    for (CCActionSheetAction *action = otherAction; action != nil; action = va_arg(list, CCActionSheetAction*)) {
        [self.action addAction:action index:btnCount];
        [actionSheet addButtonWithTitle:action.title];
        btnCount ++;
    }
    va_end(list);
    __block CCActionSheet *wsActionSheet = self.action;
    self.action.showHandler = ^(UIView *view) {
        actionSheet.title = wsActionSheet.title;
        [actionSheet showInView:view];
    };
    return self.action;
}

// 自定义actionsheet类
- (void)setCustomAlertViewWithClass:(Class _Nullable)viewClass {
    customViewClass = viewClass;
}

#pragma actionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.action clickedTitle:buttonIndex];
    self.action = nil;
}
@end
