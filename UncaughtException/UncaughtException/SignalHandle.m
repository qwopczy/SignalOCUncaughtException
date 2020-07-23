//
//  SignalHandle.m
//  UncaughtException
//
//  Created by chenyi on 2020/7/23.
//  Copyright © 2020 chenyi. All rights reserved.
//

#import "SignalHandle.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>
#import <UIKit/UIKit.h>

@implementation SignalHandle

+(void)saveCreash:(NSString *)exceptionInfo
{
    NSString * _libPath  = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"SigCrash"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:_libPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:_libPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString * savePath = [_libPath stringByAppendingFormat:@"/error.log"];
    BOOL sucess = [exceptionInfo writeToFile:savePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    NSLog(@"YES sucess:%d",sucess);
}


@end

//SignalExceptionHandler是信号出错时候的回调
void SignalExceptionHandler(int signal)
{
    NSMutableString *mstr = [[NSMutableString alloc] init];
    [mstr appendString:@"===Stack:\n"];
    void* callstack[128];
    int i, frames = backtrace(callstack, 128);
    char** strs = backtrace_symbols(callstack, frames);
    for (i = 0; i <frames; ++i) {
        [mstr appendFormat:@"%s\n", strs[i]];
    }
    [SignalHandle saveCreash:mstr];

}

void InstallSignalHandler(void)
{
//    signal(SIGHUP, SignalExceptionHandler);//SIGHUP--程序终端中止信号
//    signal(SIGINT, SignalExceptionHandler);//SIGINT--程序键盘中断信号
//    signal(SIGQUIT, SignalExceptionHandler);//告知进程退出
    
    signal(SIGABRT, SignalExceptionHandler);//SIGABRT--程序中止命令中止信号
    signal(SIGILL, SignalExceptionHandler);//SIGILL--程序非法指令信号
    signal(SIGSEGV, SignalExceptionHandler);//SIGSEGV--程序无效内存中止信号
    signal(SIGFPE, SignalExceptionHandler);//SIGFPE--程序浮点异常信号
    signal(SIGBUS, SignalExceptionHandler);//SIGBUS--程序内存字节未对齐中止信号
    signal(SIGPIPE, SignalExceptionHandler);//SIGPIPE--程序Socket发送失败中止信号
    signal(SIGKILL, SignalExceptionHandler);//SIGKILL--程序结束接收中止信号
    signal(SIGTERM, SignalExceptionHandler);//SIGTERM--程序kill中止信号
    signal(SIGTRAP, SignalExceptionHandler);//由断点指令或其它trap指令产生. 由debugger使用。
    /**
     
   Objective-C的异常处理是不能得到signal的，如果要处理它，我们还要利用unix标准的signal机制，注册SIGABRT, SIGBUS, SIGSEGV等信号发生时的处理函数，处理函数中做你的处理。
     
     在以上列出的信号中，程序不可捕获、阻塞或忽略的信号有：SIGKILL,SIGSTOP
     不能恢复至默认动作的信号有：SIGILL,SIGTRAP
     默认会导致进程流产的信号有：SIGABRT,SIGBUS,SIGFPE,SIGILL,SIGIOT,SIGQUIT,SIGSEGV,SIGTRAP,SIGXCPU,SIGXFSZ
     默认会导致进程退出的信号有:
     SIGALRM,SIGHUP,SIGINT,SIGKILL,SIGPIPE,SIGPOLL,SIGPROF,SIGSYS,SIGTERM,SIGUSR1,SIGUSR2,SIGVTALRM
     默认会导致进程停止的信号有：SIGSTOP,SIGTSTP,SIGTTIN,SIGTTOU
     */
    /**
     SIGSTOP--程序键盘中止信号
     SIGALRM--程序超时信号
     
     会导致程序被杀掉的有下面几种，我们只需收集这几种信号的上下文信息，就能找到崩溃发生原因。
     SIGABRT,
     SIGBUS,
     SIGFPE,
     SIGILL,
     SIGSEGV,
     SIGTRAP,
     SIGTERM,
     SIGKILL,
     */
}
