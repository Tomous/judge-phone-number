//
//  ViewController.m
//  正则表达式判断手机号
//
//  Created by maxscrenn on 15/11/16.
//  Copyright © 2015年 maxscrenn. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    UITextField *textField;
    UIButton *yanzhengBtn;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    textField = [[UITextField alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    textField.backgroundColor = [UIColor greenColor];
    textField.textColor = [UIColor blackColor];
    [self.view addSubview:textField];
    
    yanzhengBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    yanzhengBtn.backgroundColor = [UIColor redColor];
    [yanzhengBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [yanzhengBtn addTarget:self action:@selector(yanzhengBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:yanzhengBtn];
}

-(void)yanzhengBtnDidClick
{
    //正则表达式
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    BOOL isMatch = [pre evaluateWithObject:textField.text];
    
    if (isMatch) {
        
        [self startTime];
        
    }
    else
    {
        NSLog(@"手机号格式错误");
    }

}

-(void)startTime
{
    __block int timeout=10; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0)
        {
            //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //               [checkNumBtn setBackgroundColor:COLOR(46, 169, 218, 1.0)];
                //                [checkNumBtn setBackgroundColor:[UIColor whiteColor]];
//                [yanzhengBtn setBackgroundImage: [UIImage imageNamed:@"获取验证码"] forState:UIControlStateNormal];
                [yanzhengBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                [yanzhengBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                yanzhengBtn.userInteractionEnabled = YES;
            });
        }
        else
        {
            //int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                //   [checkNumBtn setBackgroundColor:[UIColor lightGrayColor]];
                yanzhengBtn.userInteractionEnabled = NO;
                [yanzhengBtn setTitle:[NSString stringWithFormat:@"已发送(%@)",strTime] forState:UIControlStateNormal];
                [yanzhengBtn setBackgroundImage:[UIImage imageNamed:@"LoginButtonPicture"] forState:UIControlStateNormal];
                [yanzhengBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
