//
//  ViewController.m
//  MacOS
//
//  Created by Hmily on 2017/4/25.
//  Copyright © 2017年 Hmily. All rights reserved.
//

#import "ViewController.h"
@interface ViewController()<NSTableViewDelegate, NSTableViewDataSource>

@property(nonatomic, strong) NSTableView *tableView;

@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSTableColumn *colum1= [[NSTableColumn alloc] initWithIdentifier:@"colum1"];
    colum1.width = 200;
    
    NSTableColumn *colum2= [[NSTableColumn alloc] initWithIdentifier:@"colum2"];
    colum1.width = 300;
    _tableView = [[NSTableView alloc] initWithFrame:self.view.bounds];
    _tableView.backgroundColor = [NSColor redColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView addTableColumn:colum1];
    [_tableView addTableColumn:colum2];
    [self.view addSubview:_tableView];

}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return 2;
}

- (NSCell *)tableView:(NSTableView *)tableView dataCellForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    NSCell *cell = [tableView reuse]
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
