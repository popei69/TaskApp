//
//  CustomerTableController.h
//  TaskApp
//
//  Created by Benoit PASQUIER on 24/03/2015.
//  Copyright (c) 2015 Benoit Pasquier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerTableController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *customers;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end
