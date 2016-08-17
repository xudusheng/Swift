//
//  INSArticleModel.m
//  iNews
//
//  Created by xudosom on 16/8/15.
//  Copyright © 2016年 zhengda. All rights reserved.
//

#import "INSArticleModel.h"

@implementation INSArticleModel
- (NSString *)description
{
    return [NSString stringWithFormat:@"\ntitle = %@; \ncontent = %@;    \nsummary = %@;    \nhref = %@;    \narticleType = %@;    \narticleId = %@;   \npublicDate = %@\n\n\n", _title, _content, _summary, _href, _articleType, _articleId, _publicDate];
}

- (instancetype)init{
    if (self = [super init]) {
        _title = @"";
        _summary = @"";
        _href = @"";
        _content = @"";
        _articleType = @"";
        _articleId = @"";
        _publicDate = @"";
    }
    return self;
}


- (void)setTitle:(NSString *)title{
    _title = title.length?title:@"";
}

- (void)setSummary:(NSString *)summary{
    _summary = summary.length?summary:@"";

}
- (void)setHref:(NSString *)href{
    _href = href.length?href:@"";
}
- (void)setContent:(NSString *)content{
    _content = content.length?content:@"";
}

- (void)setArticleType:(NSString *)articleType{
    _articleType = articleType.length?articleType:@"";
}
- (void)setArticleId:(NSString *)articleId{
    _articleId = articleId.length?articleId:@"";
}
- (void)setPublicDate:(NSString *)publicDate{
    _publicDate = publicDate.length?publicDate:@"";
}
@end
