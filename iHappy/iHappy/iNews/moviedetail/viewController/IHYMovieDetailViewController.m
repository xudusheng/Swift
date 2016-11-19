//
//  IHYMovieDetailViewController.m
//  iHappy
//
//  Created by xudosom on 2016/11/20.
//  Copyright © 2016年 上海优蜜科技有限公司. All rights reserved.
//

#import "IHYMovieDetailViewController.h"

@interface IHYMovieDetailViewController ()

@end

@implementation IHYMovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self movieDetailViewControllerDataInit];
    [self createMovieDetailViewControllerUI];
}

#pragma mark - UI相关
- (void)createMovieDetailViewControllerUI{
    self.view.backgroundColor = [UIColor whiteColor];
    
}
    
#pragma mark - 网络请求
    
#pragma mark - 代理方法
    
#pragma mark - 点击事件处理
    
#pragma mark - 其他私有方法
- (void)detailHtmlData:(NSData *)htmlData{
    NSString * rootHref = @"http://www.q2002.com/";
    TFHpple * hpp = [[TFHpple alloc] initWithHTMLData:htmlData];
    
    NSArray * dt_dd_elements = [hpp searchWithXPathQuery:@"//dl//dt|//dd"];
    for (TFHppleElement * dt_dd_element in dt_dd_elements) {
       NSString * content = dt_dd_element.text;
        NSString * title = [dt_dd_element firstChildWithTagName:@"span"].text;
        NSLog(@"%@ = %@\n", title, content);
    }
    
    TFHppleElement * sumary_element = [hpp searchWithXPathQuery:@"//div[@class=\"tab-jq ctc\"]"].firstObject;
    NSString * sumary = sumary_element.text;
    NSLog(@"%@", sumary);

    
    NSArray * show_player_gogo_elements = [hpp searchWithXPathQuery:@"//div[@class=\"show_player_gogo\"]//ul"];
    NSArray * bofangqi_elements = [hpp searchWithXPathQuery:@"//li[@class=\"on bofangqi\"]"];
    for (int i = 0; i < show_player_gogo_elements.count; i ++) {
        TFHppleElement * show_player_gogo_element = show_player_gogo_elements[i];
        NSString * playerDesc = @"";
        if (i < bofangqi_elements.count) {
            TFHppleElement * bofangqi_element = bofangqi_elements[i];
            playerDesc = bofangqi_element.text;
        }
        NSLog(@"%@", playerDesc);
        NSArray * button_li_elements = [show_player_gogo_element childrenWithTagName:@"li"];
        for (TFHppleElement * button_li_element in button_li_elements) {
            TFHppleElement * button_a_element = [button_li_element firstChildWithTagName:@"a"];
            NSString * href = [button_a_element objectForKey:@"href"];
            NSString * buttonTitle = button_a_element.text;
            NSLog(@"%@ = %@", buttonTitle, href);
        }
    }
    
    NSArray * footer_elements = [hpp searchWithXPathQuery:@"//div[@class=\"footer clearfix\"]//p"];
    NSMutableString * footerDisc = [NSMutableString string];
    for (TFHppleElement * p_element in footer_elements) {
        NSString * text = p_element.text;
        [footerDisc appendString:text];
        [footerDisc appendString:@"\n"];
    };
    NSLog(@"%@", footerDisc);

}

#pragma mark - 内存管理相关
- (void)movieDetailViewControllerDataInit{
    
}

    
    - (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
        
        __weak typeof(self)weakSelf = self;
        [[[XDSHttpRequest alloc] init] htmlRequestWithHref:@"http://www.q2002.com/show/18004.html"
                                             hudController:self
                                                   showHUD:YES
                                                   HUDText:nil
                                             showFailedHUD:YES
                                                   success:^(BOOL success, NSData * htmlData) {
                                                       NSLog(@"%@", [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding]);
                                                       [weakSelf detailHtmlData:htmlData];
                                                   } failed:^(NSString *errorDescription) {
                                                       
                                                   }];
        
    }

@end
