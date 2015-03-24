//
//  CustomerTableController.m
//  TaskApp
//
//  Created by Benoit PASQUIER on 24/03/2015.
//  Copyright (c) 2015 Benoit Pasquier. All rights reserved.
//

#import "CustomerTableController.h"
#import "CustomerCell.h"
#import "WebServiceManager.h"
#import "NSString+MD5.h"
#import "Reachability.h"

@interface CustomerTableController() <WebServiceDelegate>

@property (nonatomic, strong) NSTimer *refreshTimer;

@end

@implementation CustomerTableController

@synthesize customers;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    customers = [[NSMutableArray alloc] init];
    
    [[WebServiceManager sharedManager] setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_refreshTimer == nil) {
        [self scheduleCustomerRequest];
        _refreshTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(scheduleCustomerRequest) userInfo:nil repeats:true];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_refreshTimer invalidate];
    _refreshTimer = nil;
}

- (void)scheduleCustomerRequest {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if (internetStatus != NotReachable) {
        [[WebServiceManager sharedManager] requestCustomerQueue];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurs" message:@"TaskApp needs an access to Internet. Check your connection and relaunch TaskApp" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
        [alertView show];
    }
}

#pragma mark - Services

- (void)getResultFromCustomerQueueRequest:(NSDictionary *)data {
    
    NSLog(@"GET SOME NEW RESULT");
    
    if ( [(NSString*)[data objectForKey:@"status"] isEqualToString:@"ok"]) {
        
        NSArray* arrayToCompare = [NSMutableArray arrayWithArray:(NSArray*)[[[data objectForKey:@"queueData"] objectForKey:@"queue"] objectForKey:@"customersToday"]];
        
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"expectedTime"  ascending:YES];
        arrayToCompare= [arrayToCompare sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
        
        [arrayToCompare sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            static NSDateFormatter *dateFormatter = nil;
            
            if (!dateFormatter) {
                dateFormatter = [[NSDateFormatter alloc] init];
                dateFormatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
            }
            
            NSString *date1String = [obj1 valueForKey:@"expectedTime"];
            NSString *date2String = [obj2 valueForKey:@"expectedTime"];
            
            NSDate *date1 = [dateFormatter dateFromString:date1String];
            NSDate *date2 = [dateFormatter dateFromString:date2String];
            
            return [date1 compare:date2];
        }];
        
        customers = [NSMutableArray arrayWithArray:[arrayToCompare copy]];
        
        [_tableView reloadData];
    }
}

- (void)getResultWithError:(NSError *)error {
    NSLog(@"WebServiceDelegate error: %@", error.localizedDescription);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurs" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
    [alertView show];
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return customers.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomerCell *cell = (CustomerCell*)[tableView dequeueReusableCellWithIdentifier:@"CustomerCell"];
    
    NSDictionary *customer = (NSDictionary*)[[customers objectAtIndex:indexPath.row] objectForKey:@"customer"];
    
    cell.nameLabel.text = [customer objectForKey:@"name"];
    cell.timeLabel.text = [[customers objectAtIndex:indexPath.row] objectForKey:@"expectedTime"];
    
    if ([[customer objectForKey:@"emailAddress"] isKindOfClass:[NSString class]]) {
        dispatch_queue_t queue = dispatch_queue_create("fr.benoitpasquier.taskapp.loadimg", NULL);
        dispatch_async(queue, ^{
            
            NSString *urlString = [NSString stringWithFormat:@"http://www.gravatar.com/avatar/%@", [(NSString*)[customer objectForKey:@"emailAddress"] MD5Hash]];
            
            NSURL *imgURL=[[NSURL alloc]initWithString:urlString];
            
            NSData *imgdata=[[NSData alloc]initWithContentsOfURL:imgURL];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [cell.gravatarView setImage:[[UIImage alloc]initWithData:imgdata]];
            });
            
        });
    }
    
    
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
