//
//  DownloadOperation.h
//  objc-practice
//
//  Created by Yunhe Song on 7/4/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DownloadOperation : NSOperation

@property (readwrite, getter=isExecuting) BOOL executing;
@property (readwrite, getter=isFinished) BOOL finished;

- (instancetype)init NS_UNAVAILABLE; 
- (instancetype)initWithUrl:(NSString *)urlString finishedBlock:(void(^)(NSData * _Nonnull))finishedBlock NS_DESIGNATED_INITIALIZER;
@end

NS_ASSUME_NONNULL_END
