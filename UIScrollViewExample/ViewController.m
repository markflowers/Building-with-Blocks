//
//  ViewController.m
//  UIScrollViewExample
//
//  Created by Mark Flowers on 1/31/13.
//  Copyright (c) 2013 Mark Flowers. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize numberOfRows, table;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.scrollViewCompletionBlock = ^(void){ };
    self.numberOfRows = 15;
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 44.0)];
    
    UIBarButtonItem *topButton = [[UIBarButtonItem alloc] initWithTitle:@"TOP" style:UIBarButtonItemStyleBordered target:self action:@selector(topButtonTapped:)];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonTapped:)];
    
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"EXAMPLE"];
    item.leftBarButtonItem = topButton;
    item.rightBarButtonItem = addButton;
    [navBar pushNavigationItem:item animated:YES];
    [self.view addSubview:navBar];
    
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(navBar.frame), self.view.frame.size.width, self.view.frame.size.height - navBar.frame.size.height - 88.0) style:UITableViewStylePlain];
    self.table.dataSource = self;
    self.table.delegate = self;
    [self.view addSubview:self.table];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate methods

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

-(int) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.numberOfRows;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"genericCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 5.0f, self.table.frame.size.width - 10.f, 34.0f)];
    label.text = [NSString stringWithFormat:@"Row #%d", indexPath.row];
    [cell addSubview:label];
    
    return cell;
}

#pragma mark - UIScrollViewDelegate methods

- (void) scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    self.scrollViewCompletionBlock();
    self.scrollViewCompletionBlock = ^(void){ };
}

#pragma mark - Button action methods

- (void) topButtonTapped:(id)sender {
    self.scrollViewCompletionBlock = ^(void) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Hola" message:@"Welcome to the top my friend." delegate:nil cancelButtonTitle:@"OK ... cool" otherButtonTitles:nil];
        [alertView show];
    };
    
    [self.table scrollRectToVisible:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f) animated:YES];
}

- (void) addButtonTapped:(id)sender {
    NSIndexPath *lastRow = [NSIndexPath indexPathForRow:self.numberOfRows - 1 inSection:0];
    self.numberOfRows++;
    
    __block UITableView *blockTable = self.table;
    
    self.scrollViewCompletionBlock = ^(void) {
        [blockTable beginUpdates];
        [blockTable insertRowsAtIndexPaths:@[lastRow] withRowAnimation:UITableViewRowAnimationBottom];
        [blockTable endUpdates];
        [blockTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:lastRow.row + 1 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    };

    if([[self.table indexPathsForVisibleRows] containsObject:lastRow]) {
        // ROW IS VISIBLE
        self.scrollViewCompletionBlock();
        self.scrollViewCompletionBlock = ^(void){ };
    } else {
        [self.table scrollToRowAtIndexPath:lastRow atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
}

@end
