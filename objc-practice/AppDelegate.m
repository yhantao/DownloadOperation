//
//  AppDelegate.m
//  objc-practice
//
//  Created by Yunhe Song on 7/4/23.
//

#import "AppDelegate.h"
#import "DownloadOperation.h"

static char AppDelegateContext = 0;
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // [self testOp];
    [self testAsyncOperation];
    return YES;
}


- (void)testOp{
    NSOperationQueue *q1 = [[NSOperationQueue alloc] init];
    q1.maxConcurrentOperationCount = 1;
    
    q1.name = @"test queue";
    q1.qualityOfService = NSQualityOfServiceUserInteractive;
    
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"op 1----complete");
    }];
    
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"op 2----complete");
    }];
    
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"op 3----complete");
    }];
    
    void (^completionBlock)(void) = ^{
        NSLog(@"q1 count -- %lu", q1.operationCount);
    };
    
    op1.completionBlock = completionBlock;
    op2.completionBlock = completionBlock;
    op3.completionBlock = completionBlock;
    
    [op3 addDependency:op1];
    [op3 addDependency:op2];
    
    [q1 setSuspended:YES];
    
    [q1 addOperations:@[op1, op2, op3] waitUntilFinished:NO];

    NSLog(@"q1 is suspended : %@", q1.isSuspended ? @"YES" : @"NO");
    [NSThread sleepForTimeInterval:5];
    [q1 setSuspended:NO];
    
    [NSOperationQueue currentQueue];
}

-(void)testAsyncOperation{
    DownloadOperation *op = [[DownloadOperation alloc] initWithUrl:@"https://picsum.photos/1/20/400/300" finishedBlock:^(NSData * _Nonnull) {
        NSLog(@"success");
    }];
    
    [op addObserver:self forKeyPath:@"executing" options:NSKeyValueObservingOptionNew context:&AppDelegateContext];
    
    NSOperationQueue *q1 = [[NSOperationQueue alloc] init];
    [q1 addOperation:op];
    
    [q1 waitUntilAllOperationsAreFinished];
    
    NSLog(@"finished");
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (context != &AppDelegateContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    if([keyPath isEqualToString:@"executing"]){
        NSLog(@"%@", change);
    }
}



#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
