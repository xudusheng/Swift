//
//  NLETask.m
//  NLAppEngine
//
//  Copyright (c) 2014 NeuLion. All rights reserved.
//

#import "NLETask.h"

@interface NLETask ()

@property (nonatomic, strong) NSMutableArray * dependencyTasks;
- (void)executeBlockContent;

@end

@implementation NLETask

- (void)dealloc
{

}

+ (NLETask *)task
{
    return [[NLETask alloc] init];
}

- (id)init
{
    if (self = [super init]) {
        self.dependencyTasks = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Public methods

- (void)addDependency:(NLETask *)task
{
    if (![self.dependencyTasks containsObject:task]) {
        [self.dependencyTasks addObject:task];
    }
}

- (void)removeDependency:(NLETask *)task
{
    if ([self.dependencyTasks containsObject:task]) {
        [self.dependencyTasks removeObject:task];
    }
}

- (void)taskHasFinished
{
    [self handleTaskWithUpdateState:NLETaskFinished];
}

- (void)cancelTask
{
    [self handleTaskWithUpdateState:NLETaskCancelled];
}

- (NSArray *)dependencies
{
    return self.dependencyTasks;
}

- (void)executeBlockContent
{
    [self handleTaskWithUpdateState:NLETaskExecuting];
}

- (void)handleTaskWithUpdateState:(NLETaskState)state
{
    if (state != _taskState) {
        
        _taskState = state;
        
        if (self.taskStateChangedBlock) {
            self.taskStateChangedBlock(self);
        }
        
        if (_taskState == NLETaskExecuting) {
            if (self.taskContentBlock) {
                self.taskContentBlock(self);
            }
        }
        
        if (_taskState == NLETaskFinished || _taskState == NLETaskCancelled) {
            [self.dependencyTasks removeAllObjects];
        }
    }
}

#pragma mark - Private methods


@end
