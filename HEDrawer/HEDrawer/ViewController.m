//
//  ViewController.m
//  HEDrawer
//
//  Created by Hackice on 15/8/29.
//  Copyright (c) 2015年 Hackice. All rights reserved.
//

#import "ViewController.h"

/* 自动获取对象的属性值 */
#define keyPath(objc, keyPath) @(((void)objc.keyPath, #keyPath))

/* 当前设备屏幕的尺寸 */
#define screenHeight [UIScreen mainScreen].bounds.size.height
#define screenWidth [UIScreen mainScreen].bounds.size.width

/* 动画时长 */
#define animationDuration 0.25

@interface ViewController ()

@property (weak, nonatomic) UIView *mainView;/**< 主界面 */

@property (weak, nonatomic) UIView *leftView;/**< 左侧界面 */

@property (weak, nonatomic) UIView *rightView;/**< 右侧界面 */

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 加载所有界面
    [self setupAllViews];
    
    // 创建拖拽手势
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureSel:)];
    // 添加拖拽手势
    [self.mainView addGestureRecognizer:panGesture];
    
    // 创建点按手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureSel:)];
    // 添加点按手势
    [self.mainView addGestureRecognizer:tapGesture];
    
    /* 为主界面的frame值添加监听 */
    [self.mainView addObserver:self forKeyPath:keyPath(self.mainView, frame) options:NSKeyValueObservingOptionNew context:nil];
}

/**
 *  监听方法
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    /* 如果主界面的x值偏移量大于零, 即手势往右滑动, 则 */
    if (self.mainView.frame.origin.x > 0) {
        
        /* 隐藏右侧界面 */
        self.rightView.hidden = YES;
        
    } else if (self.mainView.frame.origin.x < 0) {
        
        /* 显示右侧界面 */
        self.rightView.hidden = NO;
    }
}

- (void)dealloc {
    
    /* 移除监听 */
    [self.mainView removeObserver:self forKeyPath:keyPath(self.mainView, frame)];
}

/**
 *  拖拽手势的响应方法
 */
- (void)panGestureSel:(UIPanGestureRecognizer *)panGesture {
    
    CGPoint oldPoint = [panGesture translationInView:self.mainView];
    /* 获取触摸点中x值 */
    CGFloat offsetX = oldPoint.x;
    
    /* 设置主界面的偏移量 */
    self.mainView.frame = [self frameWithOffsetX:offsetX];
    
    /* 重置触摸点的x值 */
    [panGesture setTranslation:CGPointZero inView:self.mainView];
    
    /******************** 过半复位功能算法 BEGIN ********************/
    
    if (panGesture.state == UIGestureRecognizerStateEnded) {
        
        CGFloat offsetX = 0;
        CGFloat target = 0;
        CGFloat realX = CGRectGetMinX(self.mainView.frame);
        CGFloat realMaxX = CGRectGetMaxX(self.mainView.frame);
        
        if (realX > 0.5 * screenWidth) {
            
            target = 250;
            
        } else if (realMaxX < 0.5 * screenWidth) {
            
            target = - 210;
        }
        offsetX = target - realX;
        
        [UIView animateWithDuration:animationDuration animations:^{
            
            self.mainView.frame = [self frameWithOffsetX:offsetX];
        }];
    };
    /******************** 过半复位功能算法 END ********************/
}

/**
 *  点按手势的响应方法
 */
- (void)tapGestureSel:(UITapGestureRecognizer *)tapGesture {
    
    if (CGRectGetMinX(self.mainView.frame) != 0) {
        
        [UIView animateWithDuration:animationDuration animations:^{
            
            self.mainView.frame = self.view.bounds;
        }];
    }
}

/**
 *  通过x轴方向的偏移量计算出UIView的frame的方法
 */
- (CGRect)frameWithOffsetX:(CGFloat)offsetX {
    
    /* 偏移后的位置 */
    CGFloat newX = CGRectGetMinX(self.mainView.frame) + offsetX;
    CGFloat newY = newX / screenWidth * 100;
    
    /* 取y绝对值 */
    if (CGRectGetMinX(self.mainView.frame) < 0) {
        
        newY = - newY;
    }
    
    CGFloat newHeight = screenHeight - 2 * newY;
    CGFloat newWidth = newHeight / screenHeight * screenWidth;
    
    return CGRectMake(newX, newY, newWidth, newHeight);
}

/**
 *  加载所有界面(创建顺序会影响程序的业务逻辑)
 */
- (void)setupAllViews {
    
    /* 创建左侧界面 */
    UIView *leftView = [[UIView alloc] initWithFrame:self.view.bounds];
    leftView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:leftView];
    self.leftView = leftView;
    
    /* 创建右侧界面 */
    UIView *rightView = [[UIView alloc] initWithFrame:self.view.bounds];
    rightView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:rightView];
    self.rightView = rightView;
    
    /* 创建主界面 */
    UIView *mainView = [[UIView alloc] initWithFrame:self.view.bounds];
    mainView.backgroundColor = [UIColor redColor];
    mainView.layer.shadowOpacity = 0.8;
    mainView.layer.shadowOffset = CGSizeZero;
    
    [self.view addSubview:mainView];
    self.mainView = mainView;
}

@end
