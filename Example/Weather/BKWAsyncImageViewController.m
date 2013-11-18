//
//  BKWAsyncImageViewController.m
//  Weather
//
//  Created by Jerome Morissard on 11/18/13.
//  Copyright (c) 2013 Backelite. All rights reserved.
//

#import "BKWAsyncImageViewController.h"

// BkTask
#import "BkTask.h"

@interface BKWAsyncImageViewController ()
@property (strong, nonatomic) BKTTask *getImageTask;
@end

@implementation BKWAsyncImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonPressed:(id)sender
{
    
    __weak BKWAsyncImageViewController *weakSelf = self;
    self.getImageTask = [BKTTask imageTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://wimages.vr-zone.net/2013/06/steve-jobs-biography-hardback.jpg"]]];
    [self.getImageTask addTarget:self completion:^(BKTTask *task, id output) {
        NSLog(@"completion");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.imageView.image = [UIImage imageWithData:output];
        });
    }];
    
    [self.getImageTask addTarget:self failure:^(BKTTask *task, NSError *error) {
        NSLog(@"failure");
    }];
    
    [self.getImageTask start];
}

@end
