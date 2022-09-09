//
//  RCCrashhunter.m
//  RCToolKit
//
//  Created by yoyo on 2022/9/9.
//

#import "RCCrashhunter.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>

static RCCrashhunter * share_obj = nil;

@interface RCCrashhunter ()
@property (nonatomic, assign) BOOL dismissed;
@property (nonatomic,copy)void(^crashCallBack)(NSString * stackMsg);

- (void)handleException:(NSException *)exception;
@end


NSUncaughtExceptionHandler *OldHandler = nil;
//void (*OldAbrtSignalHandler)(int, struct __siginfo *, void *);

NSString * const UncaughtExceptionHandlerSignalExceptionName = @"UncaughtExceptionHandlerSignalExceptionName";
NSString * const UncaughtExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";
NSString * const UncaughtExceptionHandlerAddressesKey = @"UncaughtExceptionHandlerAddressesKey";

const NSInteger UncaughtExceptionHandlerReportAddressCount = 20;//指明获取多少条调用堆栈信息

//signal
void SignalHandler(int signal) {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:signal] forKey:UncaughtExceptionHandlerSignalKey];
    NSArray *callBack = [RCCrashhunter backtrace];
    [userInfo setObject:callBack forKey:UncaughtExceptionHandlerAddressesKey];
    
    NSException *signalException = [NSException exceptionWithName:UncaughtExceptionHandlerSignalExceptionName reason:[NSString stringWithFormat:@"Signal %d was raised.",signal] userInfo:userInfo];
    [[RCCrashhunter share] handleException:signalException];
}

//oc exception
void exceptionHandler(NSException *exception) {
    NSArray *callStack = exception.callStackSymbols;
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:[exception userInfo]];
    [userInfo setObject:callStack forKey:UncaughtExceptionHandlerAddressesKey];
    NSException * newException = [NSException exceptionWithName:[exception name] reason:[exception reason] userInfo:userInfo];
    // 调用之前已经注册的handler
    if (OldHandler) {
        OldHandler(exception);
    }
    [[RCCrashhunter share] handleException:newException];

}
@implementation RCCrashhunter {
    
    NSUncaughtExceptionHandler *OldHandler;
}

+ (instancetype)share {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share_obj = [[RCCrashhunter alloc] init];
    });
    return  share_obj;
}
+ (NSArray *)backtrace {
    void *callStack[128];//堆栈方法数组
    int frames = backtrace(callStack, 128);//获取错误堆栈方法指针数组，返回数目
    char **strs = backtrace_symbols(callStack, frames);//符号化
    
    NSMutableArray *symbolsBackTrace=[NSMutableArray arrayWithCapacity:frames];
    
    unsigned long count = UncaughtExceptionHandlerReportAddressCount < frames ? UncaughtExceptionHandlerReportAddressCount : frames;
    for (int i = 0; i < count; i++) {
        [symbolsBackTrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    return symbolsBackTrace;
}
- (void)start:(void (^)(NSString * _Nonnull))callBack {
    self.crashCallBack = callBack;
    [self registerObserver];
}
- (void)handleException:(NSException *)exception{
    NSString *stackInfo = [[exception userInfo] objectForKey:UncaughtExceptionHandlerAddressesKey];
    NSString * crashLog = [NSString stringWithFormat:@"crash name %@ \n crash reason %@ \n stack %@",[exception name], [exception reason],stackInfo];
    if (self.crashCallBack) {
        self.crashCallBack(crashLog);
    }
#ifdef DEBUG
    NSString *message = [NSString stringWithFormat:@"抱歉，APP发生了异常，请与开发人员联系，点击屏幕继续并自动复制错误信息到剪切板。\n\n异常报告:\n异常名称：%@\n异常原因：%@\n堆栈信息：%@\n", [exception name], [exception reason], stackInfo];
    NSLog(@"%@",message);
//    [self showCrashToastWithMessage:message];
    [self performSelector:@selector(crash) withObject:nil afterDelay:0.5];
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
    while (!self.dismissed) {
        for (NSString *mode in (__bridge NSArray *)allModes) {
            //为阻止线程退出，使用 CFRunLoopRunInMode(model, 0.001, false)等待系统消息，false表示RunLoop没有超时时间
            CFRunLoopRunInMode((CFStringRef)mode, 0.001, false);
        }
    }
    CFRelease(allModes);
#endif
    [self unregisterObserver];
    if ([[exception name] isEqual:UncaughtExceptionHandlerSignalExceptionName]) {
        kill(getpid(), [[[exception userInfo] objectForKey:UncaughtExceptionHandlerSignalKey] intValue]);
    } else {
        [exception raise];
    }
}
- (void)crash {
    self.dismissed = YES;
}
- (void)unregisterObserver {
    NSSetUncaughtExceptionHandler(NULL);
    signal(SIGHUP, SIG_DFL);
    signal(SIGINT, SIG_DFL);
    signal(SIGQUIT, SIG_DFL);
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGPIPE, SIG_DFL);

}

- (void)registerObserver {
    signal(SIGHUP, SignalHandler);
    signal(SIGINT, SignalHandler);
    signal(SIGQUIT, SignalHandler);
    signal(SIGABRT, SignalHandler);
    signal(SIGILL, SignalHandler);
    signal(SIGSEGV, SignalHandler);
    signal(SIGFPE, SignalHandler);
    signal(SIGBUS, SignalHandler);
    signal(SIGPIPE, SignalHandler);
    
    if (NSGetUncaughtExceptionHandler() != exceptionHandler) {
        OldHandler = NSGetUncaughtExceptionHandler();
    }
    NSSetUncaughtExceptionHandler(&exceptionHandler);
}
@end
