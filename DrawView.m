//
//  DrawView.m
//  UI_04_iOS_LB
//
//  Created by 李博 on 16/11/15.
//  Copyright © 2016年 李博. All rights reserved.
//

#import "DrawView.h"

@interface DrawView()
@property (nonatomic,strong) NSMutableArray* allLinesArray;//线段数组
@property (nonatomic,strong) NSMutableArray* colorArray;//颜色数组
@property (nonatomic,strong) NSMutableArray* allLinesArray1;//恢复线段数组
@property (nonatomic,strong) NSMutableArray* colorArray1;//恢复颜色数组

@end
@implementation DrawView
// 懒加载
-(NSMutableArray*) allLinesArray{

    if (!_allLinesArray) {
        _allLinesArray = [[NSMutableArray alloc] init];
    }
    return _allLinesArray;
}
-(NSMutableArray*) colorArray{

    if (!_colorArray) {
        _colorArray = [[NSMutableArray alloc] init];
    }
    return _colorArray;
}
-(NSMutableArray*) allLinesArray1{
    
    if (!_allLinesArray1) {
        _allLinesArray1 = [[NSMutableArray alloc] init];
    }
    return _allLinesArray1;
}
-(NSMutableArray*) colorArray1{
    
    if (!_colorArray1) {
        _colorArray1 = [[NSMutableArray alloc] init];
    }
    return _colorArray;
}
//初始化     额外添加按钮
-(instancetype) initWithFrame:(CGRect)frame{
    //父类初始化方法
    self = [super initWithFrame:frame];
    //
    if (self) {
        //初始化按钮
        UIButton* deleteButtun = [UIButton buttonWithType:UIButtonTypeSystem];
        //设置按钮大小
        deleteButtun.frame = CGRectMake(10, 10, 100, 30);
        //设置按钮背景
        deleteButtun.backgroundColor = [UIColor blackColor];
        //设置按钮标签
        [deleteButtun setTitle:@"橡皮檫" forState:(UIControlStateNormal)];
        //设置按钮方法    橡皮檫功能
        [deleteButtun addTarget:self action:@selector(deleteLine) forControlEvents:(UIControlEventTouchUpInside)];
        //添加按钮
        [self addSubview:deleteButtun];
        
        //初始化按钮
        UIButton* recoveryButtun = [UIButton buttonWithType:UIButtonTypeSystem];
        //设置按钮大小
        recoveryButtun.frame = CGRectMake(150, 10, 100, 30);
        //设置按钮背景
        recoveryButtun.backgroundColor = [UIColor blackColor];
        //设置按钮标签
        [recoveryButtun setTitle:@"撤回" forState:(UIControlStateNormal)];
        //设置按钮方法    橡皮檫功能
        [recoveryButtun addTarget:self action:@selector(recoveryLine) forControlEvents:(UIControlEventTouchUpInside)];
        //添加按钮
        [self addSubview:recoveryButtun];

    }
    return self;
}
//橡皮檫功能
-(void) deleteLine{
    //判断线条数组
    if (!self.allLinesArray.count) {
        //为空步操作
    }else{
        //存储线条最后一个元素
        [self.allLinesArray1 addObject:[self.allLinesArray lastObject]];
        //存储颜色最后一个元素
        [self.colorArray1 addObject:[self.colorArray lastObject]];
        //删除线条最后一个元素
        [self.allLinesArray removeLastObject];
        //删除颜色最后一个元素
        [self.colorArray removeLastObject];
        //显示
        [self setNeedsDisplay];
    }
}
//撤回功能
-(void) recoveryLine{
    //判断线条数组
    if (!self.allLinesArray1.count) {
        //为空步操作
    }else{
        [self.allLinesArray addObject:self.allLinesArray1.lastObject];
        [self.colorArray addObject:self.colorArray1.lastObject];
        [self.allLinesArray1 removeLastObject];
        [self.colorArray1 removeLastObject];
        //重新绘制
        [self setNeedsDisplay];
        }
}
//经过分析，执行Began方法时，说明我们正在绘制一条新的线条，所以我们需要创建新的贝塞尔曲线对象，并且将它加入到数组中。
-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //创建贝塞尔曲线对象
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    //将起始点加入到该曲线对象中(起始点实质上就是当前手指所触摸的点)
    //获取触控对象
    UITouch* touch = [touches anyObject];
    //得到起始点（手指触碰的点）
    CGPoint startPoint = [touch locationInView:self];
    //将该点加入到曲线对象中作为起始点
    [bezierPath moveToPoint:startPoint];
    //将曲线对象加入到数组中    （懒加载需要使用self.   因为调用的是get方法）
    [self.allLinesArray addObject:bezierPath];
    //产生随机颜色
    UIColor* color = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1.0];
    //添加颜色至数组上
    [self.colorArray addObject:color];
}
//当手指在屏幕上移动的时候就是产生一组连续的点，我们需要将这组连续的点添加到当前线条对象中
-(void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //获取当前正在绘制的线条对象
    UIBezierPath* bezierPath = self.allLinesArray.lastObject;
    //获取移动产生的点
    CGPoint newPoint = [[touches anyObject] locationInView:self];
    //将该点添加到现有的线条上
    [bezierPath addLineToPoint:newPoint];
    //绘制该线条（对当前的界面进行重新绘制）
    [self setNeedsDisplay];//当View调用该方法的时候，意思就是需要立即绘制当前界面，系统就会自动调用drawRect方法
}
//绘制当前视图
-(void) drawRect:(CGRect)rect{
    //遍历数组，取出所有的线进行绘制
    for (UIBezierPath* Line in self.allLinesArray) {
        //设置画笔的颜色
        //[[UIColor greenColor] setStroke];
        //得到line在allLinesArray数组中的位置，根据该位置从colorArray中取出对应的颜色
        NSInteger index = [self.allLinesArray indexOfObject:Line];
        //获取相应的颜色
        [[self.colorArray objectAtIndex:index] setStroke];
        //设置画笔的宽度
        [Line setLineWidth:6.0];
        //开始画线
        [Line stroke];
    }
    
}


@end
