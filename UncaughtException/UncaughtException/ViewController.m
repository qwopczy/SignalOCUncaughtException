//
//  ViewController.m
//  UncaughtException
//
//  Created by chenyi on 2020/7/23.
//  Copyright © 2020 chenyi. All rights reserved.
//

#import "ViewController.h"

typedef struct Test
{
    int a;
    int b;
}Test;
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /**
     SignalHandler不要在debug环境下测试。因为系统的debug会优先去拦截。运行一次后，关闭debug状态。直接在模拟器上点击我们build上去的app去运行。而OCException可以在调试状态下捕捉
     */
    [self readingCrashFile];
//    [self SignalCrash];
//    [self OCException];
    // Do any additional setup after loading the view.
}
/**
 SignalHandler 在非 debug 下捕获 Crash 信息并 writeToFile。然后 debug下打印查看之前捕获的信息 该demo 作为学习, 真实情况需要自己去拓展
 */
- (void)readingCrashFile {
    NSString * _libPathOC  = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"OCCrash"];
    NSString * _libPathSig  = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"SigCrash"];
    NSString *path = [_libPathSig stringByAppendingPathComponent:@"error.log"];
    NSString *strSig = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSString *pathOC = [_libPathOC stringByAppendingPathComponent:@"error.log"];
    NSString *strOc = [NSString stringWithContentsOfFile:pathOC encoding:NSUTF8StringEncoding error:nil];
    
    NSLog(@"SigCrash===%@", strSig);
    
    NSLog(@"OCCrash===%@", strOc);
}
- (void)SignalCrash {
    //1.信号量
    Test *pTest = {1,2};
    free(pTest);//导致SIGABRT的错误，因为内存中根本就没有这个空间，哪来的free，就在栈中的对象而已
    pTest->a = 5;
}
- (void)OCException {
    NSArray *array= @[@"1",@"2"];
    [array objectAtIndex:3];
}
@end
