//
//  BKWSelectDemoViewController.m
//  Weather
//
//  Created by Jerome Morissard on 11/18/13.
//  Copyright (c) 2013 Backelite. All rights reserved.
//

#import "BKWSelectDemoViewController.h"

#import "BKWSearchViewController.h"
#import "BKWAsyncImageViewController.h"

@interface BKWSelectDemoViewController ()
@property (strong, nonatomic) NSArray *demos;
@end

@implementation BKWSelectDemoViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.demos = @[@"JSONRequest + Parsing",@"ImageRequest + Caching"];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.demos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"demoCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSString *demoTitle = [self.demos objectAtIndex:indexPath.row];
    cell.textLabel.text = demoTitle;
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:cell.bounds];
    [backgroundView setBackgroundColor:[UIColor colorWithRed:0.357 green:0.576 blue:0.941 alpha:1.000]];
    [cell setSelectedBackgroundView:backgroundView];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        BKWSearchViewController *searchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BKWSearchViewController"];
        [self.navigationController pushViewController:searchVC animated:YES];
    }
    else if (indexPath.row) {
        BKWAsyncImageViewController *imageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BKWAsyncImageViewController"];
        [self.navigationController pushViewController:imageVC animated:YES];
    }
}

@end
