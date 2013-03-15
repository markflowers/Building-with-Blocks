//
//  ViewController.h
//  UIScrollViewExample
//
//  Created by Mark Flowers on 1/31/13.
//  Copyright (c) 2013 Mark Flowers. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CompletionBlock)(void);

@interface ViewController : UIViewController <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate> {
    
}

@property (nonatomic, retain) UITableView *table;
@property (copy, nonatomic) CompletionBlock scrollViewCompletionBlock;
@property (nonatomic) int numberOfRows;

@end
