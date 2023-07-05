//
//  DownloadOperation.m
//  objc-practice
//
//  Created by Yunhe Song on 7/4/23.
//

#import "DownloadOperation.h"

@interface DownloadOperation()

@property (nonatomic, copy) void(^finishedBlock)(NSData *data);
@property (nonatomic, copy) NSString *urlString;

@end

@implementation DownloadOperation

@synthesize executing = _executing;
@synthesize finished = _finished;

- (instancetype)initWithUrl:(NSString *)urlString finishedBlock:(void(^)(NSData * _Nonnull))finishedBlock{
    self = [super init];
    if(self){
        _urlString = urlString;
        _finishedBlock = finishedBlock;
    }
    return self;
}

- (void)start{
    NSURL *url = [NSURL URLWithString:self.urlString];
    if(!url){
        return;
    }
    
    if(self.isCancelled){
        [self done];
        return;
    }
    self.finished = NO;
    self.executing = YES;
    
    [self download:url withCompletion:^(NSData * _Nonnull data) {
        self.finishedBlock(data);
        [self done];
    }];
    
}

- (void)download:(NSURL *)url withCompletion:(void(^)(NSData * _Nonnull))completion{
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(!error && data && completion){
            completion(data);
        }
    }];
    
    [task resume];
}

- (void)setFinished:(BOOL)finished{
    [self willChangeValueForKey:@"finished"];
    _finished = finished;
    [self didChangeValueForKey:@"finished"];
}

- (BOOL)isFinished{
    return _finished;
}

- (void)setExecuting:(BOOL)executing{
    [self willChangeValueForKey:@"executing"];
    _executing = executing;
    [self didChangeValueForKey:@"executing"];
}

- (BOOL)isExecuting{
    return _executing;
}

- (void)done{
    self.executing = NO;
    self.finished = YES;
}
@end
