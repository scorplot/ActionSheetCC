//
//  CCActionSheet.h
//  Pods
//
//  Created by may on 2017/7/18.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>

// ActionSheet点击或其他操作使用该类

@interface CCActionSheetAction : NSObject

@property (nonatomic,copy,readonly) NSString * _Nullable title; //
+ (instancetype _Nullable )actionSheetWithTitle:(NSString *_Nullable)title handler:(void (^_Nullable)(CCActionSheetAction * _Nullable action))handler; // 初始化方法

@end


// ActionSheet 控制类  自定义ActionSheet需要继承该类，并按需求重写方法

@interface CCActionSheet : NSObject
@property (nonatomic, strong) UIView * _Nullable superView; // alertView 的superView 默认 window
@property (nonatomic, copy) NSString * _Nullable title;
- (void)show; // 显示ActionSheet
- (void)dismiss; // 隐藏ActionSheet
- (void)addAction:(CCActionSheetAction *_Nullable)action; // 添加按钮

#pragma mark 自定义ActionSheet时，需要CCActionSheetAction对象进行回调，则调用该方法
-(void)clickedTitle:(NSInteger)index;

#pragma mark 自定义ActionSheet时重写以下方法

/**
  自定义ActionSheet 子类需要重写该方法

 @param title 控件需要显示的title
 @param index 控件的index，该index需要保存下来用到-(void)clickedTitle:(NSInteger)index 中
 @return actionSheet本身
 */
- (UIView *_Nullable)customBtnWithTitle:(NSString *_Nullable)title index:(NSInteger)index;

/**
 自定义ActionSheet 子类需要重写该方法

 @param title actionSheet 要显示的title
 @return actionSheet本身
 */
- (UIView *_Nullable)actionSheetTitle:(NSString *_Nullable)title;

@end

// ActionSheet创建样式类
@interface CCActionSheetFactory : NSObject

+ (instancetype _Nullable )shareInstance; // 单例，获取CCActionSheetFactory对象

- (CCActionSheet *_Nullable)createActionSheet;
/**
 创建ActionSheet 样式

 @param title 显示actionSheet的title
 @param actionSheetStyle 只能在使用默认actionSheet时，使用actionSheetStyle，自定义时不起作用
 @param cancelAction actionSheet 取消操作对象，使用CCActionSheetAction 类方法(actionSheetWithTitle:(NSString *_Nullable)title handler:(void (^_Nullable)(CCActionSheetAction * _Nullable action))handler )获取，可以从block handler中获取到该实例对象
 @param otherAction 其他操作对象，获取方法同上，可以添加多个，用','隔开
 @return 初始化好的CCActionSheet对象
 */
- (CCActionSheet *_Nullable)createActionSheetWithTitle:(NSString *_Nullable)title style:(UIActionSheetStyle)actionSheetStyle cancelAction:(CCActionSheetAction *_Nullable)cancelAction otherActions:(CCActionSheetAction *_Nullable)otherAction, ... NS_REQUIRES_NIL_TERMINATION;

- (void)setCustomAlertViewWithClass:(Class _Nullable)viewClass; // 设置自定义ActionSheet ，传入view的class

@end
