//
//  NLETaskQueue.h
//  NLAppEngine
//
//  Copyright (c) 2014 NeuLion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NLETask.h"

@class NLETaskQueue;
typedef void(^NLETaskQueueFinishedBlock)(NLETaskQueue * taskQueue);

@interface NLETaskQueue : NSObject

@property (nonatomic, assign) NSInteger maxConcurrentTaskCount;
@property (nonatomic, strong, readonly) NSArray * tasks;

+ (NLETaskQueue *)taskQueue;
- (void)addTask:(NLETask *)task;
- (NLETask *)taskWithTaskId:(NSString *)taskId;
- (void)cancelAllTasks;
- (void)resetQueue;
- (void)go;
- (void)goWithFinishedBlock:(NLETaskQueueFinishedBlock)block;

@end
