//
//  LSYReadModel.h
//  LSYReader
//
//  Created by Labanotation on 16/5/31.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSYMarkModel.h"
#import "LSYNoteModel.h"
#import "LSYChapterModel.h"
#import "LSYRecordModel.h"
@interface LSYReadModel : NSObject<NSCoding>
@property (nonatomic,strong) NSURL *resource;//资源路径
@property (nonatomic,copy) NSString *content;//电子书文本内容
@property (nonatomic,assign) ReaderType type;//电子书类型（txt, epub）
@property (nonatomic,strong) NSMutableArray <LSYMarkModel *>*marks;//书签，用于目录展示
@property (nonatomic,strong) NSMutableArray <LSYNoteModel *>*notes;//笔记
@property (nonatomic,strong) NSMutableArray <LSYChapterModel *>*chapters;//章节
@property (nonatomic,strong) NSMutableDictionary *marksRecord;//保存书签的字典，用于标记书签位置
@property (nonatomic,strong) LSYRecordModel *record;//阅读进度

-(instancetype)initWithContent:(NSString *)content;
-(instancetype)initWithePub:(NSString *)ePubPath;
+(void)updateLocalModel:(LSYReadModel *)readModel url:(NSURL *)url;
+(id)getLocalModelWithURL:(NSURL *)url;
@end
