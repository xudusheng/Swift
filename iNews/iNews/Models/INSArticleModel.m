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


- (NSString *)toHtmlString{
    static NSString *const kTitlePlaceholder = @"<!-- title -->";
//    static NSString *const kSourcePlaceholder = @"<!-- source -->";
    static NSString *const kTimePlaceholder = @"<!-- time -->";
//    static NSString *const kSummaryPlaceholder = @"<!-- summary -->";
    static NSString *const kContentPlaceholder = @"<!-- content -->";
    static NSString *const kCSSPlaceholder = @"<!-- css -->";
    static NSString *const kOriginPlaceholder = @"<!-- origin -->";
    
    static NSString *htmlTemplate = nil;
    
    if (!htmlTemplate) {
        NSURL *htmlURL = [[NSBundle mainBundle] URLForResource:@"article" withExtension:@"html"];
        htmlTemplate = [NSString stringWithContentsOfURL:htmlURL encoding:NSUTF8StringEncoding error:nil];
    }
    NSString *html = htmlTemplate;
    
    NSURL *URL = [[NSBundle mainBundle] URLForResource:@"day" withExtension:@"css"];
    NSString * css = [[NSString alloc] initWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:nil];
    css = [css stringByAppendingString:@"h1{font-size:18px;}.content, summary {font-size: 15px;line-height:22px;}.source, .time{font-size: 11px;}"];
    css = [css stringByAppendingString:@"h1{font-size:28px;}.content, summary {font-size: 20px;line-height:30px;}.source, .time{font-size: 15px;}"];

    html = [html stringByReplacingOccurrencesOfString:kCSSPlaceholder withString:css];

    if (self.title) {
        html = [html stringByReplacingOccurrencesOfString:kTitlePlaceholder withString:self.title];
    }
//    if (self.source) {
//        html = [html stringByReplacingOccurrencesOfString:kSourcePlaceholder withString:self.source];
//    }
    if (self.publicDate) {
        html = [html stringByReplacingOccurrencesOfString:kTimePlaceholder withString:self.publicDate];
    }
//    if (self.summary) {
//        html = [html stringByReplacingOccurrencesOfString:kSummaryPlaceholder withString:self.summary];
//    }
    if (self.content) {
        html = [html stringByReplacingOccurrencesOfString:kContentPlaceholder withString:self.content];
//        if (settings.isImageWIFIOnly && ![[AFNetworkReachabilityManager sharedManager] isReachableViaWiFi]) {        
//            for (NSString *imgSrc in self.imgSrcs) {
//                html = [html stringByReplacingOccurrencesOfString:imgSrc withString:[@"plainreader://article.body.img?" stringByAppendingString:imgSrc]];
//            }
//        }
    }
    
    NSString * rootUrl = @"http://www.wenzhaiwang.com";
    html = [html stringByReplacingOccurrencesOfString:kOriginPlaceholder withString:[NSString stringWithFormat:@"%@%@.html", rootUrl, self.articleId]];
    return html;
}
@end
