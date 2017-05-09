//
//  NLETaskQueue.m
//  NLAppEngine
//
//  Copyright (c) 2014 NeuLion. All rights reserved.
//

#import "NLETaskQueue.h"
#import <CoreGraphics/CoreGraphics.h>

@interface NLETaskQueueTimerTarget : NSObject

@property (nonatomic, weak) id owner;
@property (nonatomic, assign) SEL selector;

- (id)initWithOwner:(id)owner selector:(SEL)selector;
- (void)update;
- (void)update:(id)object;

@end

@implementation NLETaskQueueTimerTarget

- (id)initWithOwner:(id)owner selector:(SEL)selector {
    self = [super init];
    if (self){
        _owner = owner;
        _selector = selector;
    }
    return self;
}

- (void)update {
#       pragma clang diagnostic push
#       pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if ([(NSObject *)_owner respondsToSelector:_selector]) {
        [_owner performSelector:_selector];
    }
#       pragma clang diagnostic pop
}

- (void)update:(id)object
{
#       pragma clang diagnostic push
#       pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if ([(NSObject *)_owner respondsToSelector:_selector]) {
        [_owner performSelector:_selector withObject:object];
    }
#       pragma clang diagnostic pop
}

@end


@interface NLETaskQueue ()

@property (nonatomic, strong) NSMutableArray * queueTasks;
@property (nonatomic, strong) NLETaskQueueTimerTarget * timerTarget;
@property (nonatomic, assign) CGFloat scanningInterval;
@property (nonatomic, assign) BOOL queueHasStarted;
@property (nonatomic, strong) NLETaskQueueFinishedBlock taskQueueFinishedBlock;

@end

@implementation NLETaskQueue

+ (NLETaskQueue *)taskQueue
{
    return [[NLETaskQueue alloc] init];
}

- (id)init
{
    if (self = [super init]) {
        self.maxConcurrentTaskCount = 5;
        self.scanningInterval = 0.1;
        self.queueTasks = [NSMutableArray array];
        self.timerTarget = [[NLETaskQueueTimerTarget alloc] initWithOwner:self selector:@selector(updateAllTask)];
    }
    return self;
}

#pragma mark - Public methods

- (NSArray *)tasks
{
    return self.queueTasks;
}

- (void)addTask:(NLETask *)task
{
    if (![self.queueTasks containsObject:task]) {
        [self.queueTasks addObject:task];
        
        if (self.queueHasStarted) {
            [self updateAllTask];
        }
    }
}

- (void)cancelAllTasks
{
    for (NLETask * task in self.queueTasks) {
        [task cancelTask];
    }
    self.queueTasks = [NSMutableArray array];
}

- (NLETask *)taskWithTaskId:(NSString *)taskId
{
    for (NLETask * task in self.queueTasks) {
        if ([task.taskId isEqualToString:taskId]) {
            return task;
        }
    }
    
    return nil;
}

- (void)go
{
    self.queueHasStarted = YES;
    [self.timerTarget update];
}

- (void)goWithFinishedBlock:(NLETaskQueueFinishedBlock)block
{
    self.taskQueueFinishedBlock = block;
    
    [self go];
}

- (void)resetQueue
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self.timerTarget selector:@selector(update) object:nil];
    [self cancelAllTasks];
    self.queueHasStarted = NO;
}

#pragma mark - Private methods

- (void)updateAllTask
{
    @try {
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self.timerTarget selector:@selector(update) object:nil];
        
        if (self.queueTasks.count) {
            
            NSMutableArray * willExecuteTask = [NSMutableArray array];
            NSMutableArray * willRemoveTask = [NSMutableArray array];
            NSMutableArray * executingTask = [NSMutableArray array];
            NSInteger canExecuteTaskCount = 0;
            
            for (NLETask * task in self.queueTasks) {
                if (task.taskState == NLETaskExecuting) {
                    [executingTask addObject:task];
                }
            }
            
            canExecuteTaskCount = self.maxConcurrentTaskCount - executingTask.count;
            canExecuteTaskCount = canExecuteTaskCount >=0 ? canExecuteTaskCount : 0;
            
            for (NLETask * task in self.queueTasks) {
                if (task.dependencies.count == 0 && task.taskState == NLETaskWait) {
                    //root task
                    [willExecuteTask addObject:task];
                }else {
                    //sub task
                    BOOL canExecuteTask = YES;
                    for (NLETask * depTask in task.dependencies) {
                        if (depTask.taskState == NLETaskWait || depTask.taskState == NLETaskExecuting) {
                            canExecuteTask = NO;
                            break;
                        }
                    }
                    if (canExecuteTask) {
                        [willExecuteTask addObject:task];
                    }
                }
                
                if (task.taskState == NLETaskFinished || task.taskState == NLETaskCancelled) {
                    [willRemoveTask addObject:task];
                }
            }
            
            if (willRemoveTask.count) {
                [self.queueTasks removeObjectsInArray:willRemoveTask];
            }
            
            if (willExecuteTask.count > canExecuteTaskCount) {
                [willExecuteTask subarrayWithRange:NSMakeRange(0, canExecuteTaskCount)];
            }
            
            for (NLETask * task in willExecuteTask) {
                if (task.taskState == NLETaskWait) {
                    [task executeBlockContent];
                }
            }
            
            [self.timerTarget performSelector:@selector(update) withObject:nil afterDelay:self.scanningInterval];
            
        }else {
            
            if (self.taskQueueFinishedBlock) {
                self.taskQueueFinishedBlock(self);
            }
            
        }

    }
    @catch (NSException *exception) {
        NSLog(@"Update Queue Task Exception");
    }
    @finally {
        
    }
}

@end
