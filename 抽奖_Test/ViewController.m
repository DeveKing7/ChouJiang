//
//  ViewController.m
//  抽奖_Test
//
//  Created by aaron on 14-7-18.
//  Copyright (c) 2014年 The Technology Studio. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController{
    float random;
    float startValue;
    float endValue;
    NSDictionary *awards;
    NSArray *miss;
    NSArray *data;
    NSString *result;
    int k;
    
    float _vauleStrong;

}
-(void)creatStepper{
    //步数器  就是个减号加号··
    
    UIStepper * stepper = [[UIStepper alloc]initWithFrame:CGRectMake(100, 100, 100, 15)];
    
    stepper.value = 10;
    //接受改变值的事件
    
    [stepper addTarget:self action:@selector(stepper:) forControlEvents:UIControlEventValueChanged];
    //设置最大值和最小值
    
    stepper.maximumValue =10;
    stepper.minimumValue =1;
    
    //设置步进 默认为1
    
    stepper.stepValue =1;
    stepper.autorepeat = YES;
    
    //设置连续加减值
    stepper.continuous = YES;
    
    
    ///最大值变为最小值 循环
    
    stepper.wraps = YES;
    
    
    stepper.tintColor = [UIColor colorWithWhite:1 alpha:1];
   
    
    [self.view addSubview:stepper];
    
    
    
    
}
-(void)stepper:(UIStepper *)stepper{
    
    NSLog(@"%f",stepper.value);
    _labelTextField.text = [NSString stringWithFormat:@"%f",stepper.value];
    
    _vauleStrong = stepper.value;
    
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self creatStepper];
k= 3;

    data = @[@"一等奖",@"二等奖",@"三等奖",@"再接再厉"];
    
//中奖和没中奖之间的分隔线设有2个弧度的盲区，指针不会旋转到的，避免抽奖的时候起争议。
    miss = @[
             @{@"min": @47,
               @"max":@89
               },
             @{@"min": @90,
               @"max":@133
               },
             @{@"min": @182,
               @"max":@223
               },
             @{@"min": @272,
               @"max":@314
               },
             @{@"min": @315,
               @"max":@358
               }
             ];
    
    
    awards = @{
               @"一等奖": @[
                           @{
                             @"min": @137,
                             @"max":@178
                            }
                          ],
               @"二等奖": @[
                       @{
                           @"min": @227,
                           @"max":@268
                           }
                       ],
               @"三等奖": @[
                       @{
                           @"min": @2,
                           @"max":@43
                           }
                       ],
               @"再接再厉":miss
               };
    
}

- (IBAction)start:(id)sender {
   
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    endValue = [self fetchResult];
    rotationAnimation.delegate = self;
    rotationAnimation.fromValue = @(startValue);
    rotationAnimation.toValue = @(endValue);
    if (_vauleStrong>4.0) {
        rotationAnimation.duration = _vauleStrong/2.0;
    }else{
        
         rotationAnimation.duration = 2.0;
    }
   
    rotationAnimation.autoreverses = NO;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeBoth;
    [_rotateStaticImageView.layer addAnimation:rotationAnimation forKey:@"revItUpAnimation"];
    
 
}

-(float)fetchResult{
    NSLog(@"代理方法");
    //todo: fetch result from remote service
    srand((unsigned)time(0));
    random = rand() %4;
    int i = random;
    result = data[i];  //TEST DATA ,shoud fetch result from remote service
    if (_labelTextField.text != nil && ![_labelTextField.text isEqualToString:@""]) {
        result = _labelTextField.text;
    }
    for (NSString *str in [awards allKeys]) {
        if ([str isEqualToString:result]) {
            NSDictionary *content = awards[str][0];
            int min = [content[@"min"] intValue];
            int max = [content[@"max"] intValue];
            
            
            srand((unsigned)time(0));
            random = rand() % (max - min) +min;
            
            return radians(random + 360*_vauleStrong);
        }
    }

    random = rand() %5;
    i = random;
    NSDictionary *content = miss[i];
    int min = [content[@"min"] intValue];
    int max = [content[@"max"] intValue];
    
    srand((unsigned)time(0));
    random = rand() % (max - min) +min;
    
    return radians(random + 360*_vauleStrong);
    
}

//角度转弧度
double radians(float degrees) {
     NSLog(@"代理方法2");
    return degrees*M_PI/180;
}


-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
     NSLog(@"代理方法3");
    startValue = endValue;
    if (startValue >= endValue) {
        
        
        startValue = startValue - radians(360*_vauleStrong);
           
        
    }
    
    NSLog(@"startValue = %f",startValue);
    NSLog(@"result = %@",result);
    _label1.text = result;
    NSLog(@"endValue = %f\n",endValue);
}

@end
