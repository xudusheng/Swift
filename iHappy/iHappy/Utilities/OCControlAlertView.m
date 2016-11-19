//
//  OCControlAlertView.m
//  Laomoney
//
//  Created by zhengda on 15/7/6.
//  Copyright (c) 2015年 zhengda. All rights reserved.
//

#import "OCControlAlertView.h"
#define alertView_tag 100
@implementation OCControlAlertView
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)buttonTitles{//不带输入框
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        [self ZDAlertViewUIWithTitle:title message:message buttonTitles:buttonTitles];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dealKeyboardShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dealKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder buttonTitles:(NSArray *)buttonTitles{//带输入框
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        [self textFieldAlertViewWithTitle:title placeholder:placeholder buttonTitles:buttonTitles];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dealKeyboardShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dealKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

//仿系统alertView
- (void)textFieldAlertViewWithTitle:(NSString *)title placeholder:(NSString *)placeholder buttonTitles:(NSArray *)buttonTitles{
    CGFloat alertViewWidth = 270.0f;
    CGFloat upgap = 25.0f;//上边距
    CGFloat labelgap = 15.0f;//title和textfield间隙
    CGFloat buttomgap = 15.0f;//底部间隙
    CGFloat margingap = 15.0f;//文本与弹框的边缘间隙
    CGFloat labelWidth = alertViewWidth - 2 * margingap;
    CGFloat buttonHeigth = 44.0f;
    CGFloat buttonWidth = alertViewWidth/buttonTitles.count;
    UIFont * titleFont = [UIFont systemFontOfSize:17.0];
    
    CGSize titleSize = CGSizeZero;
    if (title.length) {
        titleSize = [title sizeWithFont:titleFont
                      constrainedToSize:CGSizeMake(labelWidth, CGFLOAT_MAX)
                          lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    CGFloat alertViewHeight = upgap + titleSize.height + labelgap + 35.0f + buttomgap + buttonHeigth;
    
    UIView * contentView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, alertViewWidth, alertViewHeight)];
    contentView.center = self.center;
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.clipsToBounds = YES;
    contentView.layer.cornerRadius = 8.0f;
    contentView.tag = alertView_tag;
    [self addSubview:contentView];
    
    if (title.length) {
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(margingap, upgap, labelWidth, titleSize.height)];
        titleLabel.font = titleFont;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = title;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.numberOfLines = 0;
        [contentView addSubview:titleLabel];
        upgap += titleSize.height;
    }
    
    upgap += labelgap;
    
    self.inputTextField = [[UITextField alloc]initWithFrame:CGRectMake(margingap, upgap, labelWidth, 35.0f)];
    self.inputTextField.placeholder = placeholder;
    self.inputTextField.font = [UIFont systemFontOfSize:15.0f];
    self.inputTextField.delegate = self;
    self.inputTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.inputTextField.secureTextEntry = YES;
    [contentView addSubview:self.inputTextField];
    upgap += 35.0f;

    upgap += buttomgap;
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, upgap, alertViewWidth, 0.5f)];
    lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [contentView addSubview:lineView];
    
    for (int i = 0; i < buttonTitles.count - 1; i ++) {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(buttonWidth * (i + 1), upgap, 0.5f, buttonHeigth)];
        view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [contentView addSubview:view];
    }
    for (int i = 0; i < buttonTitles.count; i ++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(buttonWidth * i, upgap, buttonWidth -0.5f, buttonHeigth);
        [button setTitle:buttonTitles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:0.0f green:122.0f/255.0f blue:1.0f alpha:1.0f] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:17.0];
        button.tag = i;
        [button addTarget:self action:@selector(alertViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:button];
    }
    
    //可以考虑在这里加个简单动画啥的
    [self animation:contentView];
}

#pragma mark--监听键盘
- (void)dealKeyboardShow:(NSNotification *)nitification{
    [self resetViewFrame:nitification isKeyboardShow:YES];
}
- (void)dealKeyboardHide:(NSNotification *)nitification{
    [self resetViewFrame:nitification isKeyboardShow:NO];
}
-(void)resetViewFrame:(NSNotification *)nitification isKeyboardShow:(BOOL)isKeyboardShow{
    CGFloat imageOrigin = 0;
    if (!ISUPPER_IOS7) {
        imageOrigin = 20;
    }
    CGRect keyboardBounds;
    [[nitification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [nitification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [nitification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self convertRect:keyboardBounds toView:nil];
    UIView * backImageView = (UIView *)[self viewWithTag:alertView_tag];
    CGRect frame = backImageView.frame;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if (isKeyboardShow) {
        frame.origin.y = 0 - (frame.size.height + keyboardBounds.size.height + imageOrigin - screenHeight);
    }else{
        frame.origin.y = screenHeight/2 - frame.size.height/2;
    }
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    [UIView setAnimationDelegate:self];
    backImageView.frame = frame;
    [UIView commitAnimations];
}


//仿系统alertView
- (void)ZDAlertViewUIWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)buttonTitles{
    CGFloat alertViewWidth = 270.0f;
    CGFloat upgap = 25.0f;//上边距
    CGFloat labelgap = 0.0f;//title和message间隙
    CGFloat buttomgap = 25.0f;//底部间隙
    CGFloat margingap = 15.0f;//文本与弹框的边缘间隙
    CGFloat labelWidth = alertViewWidth - 2 * margingap;
    CGFloat buttonHeigth = 44.0f;
    CGFloat buttonWidth = alertViewWidth/buttonTitles.count;
    UIFont * titleFont = [UIFont systemFontOfSize:17];
    UIFont * messageFont = [UIFont systemFontOfSize:13];
    if (title.length && message.length) {
        labelgap = 5.0f;
    }
    
    CGSize titleSize = CGSizeZero;
    if (title.length) {
        titleSize = [title sizeWithFont:titleFont
                      constrainedToSize:CGSizeMake(labelWidth, CGFLOAT_MAX)
                          lineBreakMode:NSLineBreakByWordWrapping];
    }
    CGSize messageSize = CGSizeZero;
    if(message.length){
        messageSize = [message sizeWithFont:messageFont
                          constrainedToSize:CGSizeMake(labelWidth, CGFLOAT_MAX)
                              lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    CGFloat alertViewHeight = upgap + titleSize.height + labelgap + messageSize.height + buttomgap + buttonHeigth;
    
    UIView * contentView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, alertViewWidth, alertViewHeight)];
    contentView.center = self.center;
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.clipsToBounds = YES;
    contentView.layer.cornerRadius = 8.0f;
    contentView.tag = alertView_tag;
    [self addSubview:contentView];
    
    if (title.length) {
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(margingap, upgap, labelWidth, titleSize.height)];
        titleLabel.font = titleFont;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = title;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.numberOfLines = 0;
        [contentView addSubview:titleLabel];
        upgap += titleSize.height;
    }
    
    upgap += labelgap;
    if (message.length) {
        UILabel * messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(margingap, upgap, labelWidth, messageSize.height)];
        messageLabel.font = messageFont;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.text = message;
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        [contentView addSubview:messageLabel];
        upgap += messageSize.height;
    }
    upgap += buttomgap;
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, upgap, alertViewWidth, 0.5f)];
    lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [contentView addSubview:lineView];
    
    for (int i = 0; i < buttonTitles.count - 1; i ++) {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(buttonWidth * (i + 1), upgap, 0.5f, buttonHeigth)];
        view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [contentView addSubview:view];
    }
    for (int i = 0; i < buttonTitles.count; i ++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(buttonWidth * i, upgap, buttonWidth -0.5f, buttonHeigth);
        [button setTitle:buttonTitles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:0.0f green:122.0f/255.0f blue:1.0f alpha:1.0f] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:17];
        button.tag = i;
        [button addTarget:self action:@selector(alertViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:button];
    }
    
    //可以考虑在这里加个简单动画啥的
    [self animation:contentView];
}


- (void)animation:(UIView *)alertView{
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.duration = 0.1f;
    scaleAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2f, 1.2f, 1)], [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)]];
    scaleAnimation.calculationMode = kCAAnimationLinear;
    alertView.layer.anchorPoint = CGPointMake(0.5f, 0.5f);
    [alertView.layer addAnimation:scaleAnimation forKey:@"ZDAlertViewAppear"];
}

- (void)alertViewButtonClick:(UIButton *)button{
    __weak typeof(self) weakSelf = self;
    if (weakSelf.controlAlertViewBlock) {
        weakSelf.controlAlertViewBlock(button.tag);
    }
    [UIView animateWithDuration:.5 animations:^{
        self.alpha = 0.0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}



#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self endEditing:YES];
    return YES;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];//移除监听
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];//移除监听
}
@end
