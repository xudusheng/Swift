//
//  NLETask.h
//  NLAppEngine
//
//  Copyright (c) 2014 NeuLion. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    NLETaskWait = 0,
    NLETaskExecuting,
    NLETaskFinished,
    NLETaskCancelled,
}NLETaskState;

@class NLETask;
typedef void(^NLETaskStateChangedBlock)(NLETask * task);
typedef void(^NLETaskContentBlock)(NLETask * task);

@interface NLETask : NSObject

@property (nonatomic, copy) NSString * taskId;
@property (nonatomic, readonly) NLETaskState taskState;
@property (nonatomic, copy) NLETaskContentBlock taskContentBlock;
@property (nonatomic, copy) NLETaskStateChangedBlock taskStateChangedBlock;
@property (nonatomic, strong, readonly) NSArray *dependencies;
@property (nonatomic, strong) id userInfo;

+ (NLETask *)task;
- (void)addDependency:(NLETask *)task;
- (void)removeDependency:(NLETask *)task;
- (void)executeBlockContent;
- (void)taskHasFinished;
- (void)cancelTask;

@end
