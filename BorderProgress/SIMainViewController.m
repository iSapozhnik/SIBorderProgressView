//
//  SIMainViewController.m
//  BorderProgress
//
//  Created by Ivan Sapozhnik on 11/21/13.
//  Copyright (c) 2013 Ivan Sapozhnik. All rights reserved.
//

#import "SIMainViewController.h"
#import "UIImageView+SIBorderProgressView.h"
#import "AFImageRequestOperation.h"

@interface SIMainViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)onAction:(id)sender;

@end

@implementation SIMainViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onAction:(id)sender
{
    self.imageView.image = [UIImage imageNamed:@"thumbnail.jpg"];
    
    NSURLRequest *theRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://webtaj.com/images/nature-lovely-hearts-flowers-wall-height_1436306.jpg"]];
    AFImageRequestOperation *theOperation = [AFImageRequestOperation imageRequestOperationWithRequest:theRequest success:^(UIImage *image) {
        self.imageView.image = image;
    }];
    
    SIBorderProgressTheme *theme = [SIBorderProgressTheme new];
    theme.lineWidth = 1.0;
    theme.lineColor = [UIColor lightGrayColor];
    
    [theOperation setDownloadProgressBlock:^(NSInteger bytesRead, NSInteger totalBytesRead, NSInteger totalBytesExpectedToRead)
    {
        CGFloat theProgress = totalBytesRead*1.0/(totalBytesExpectedToRead);
        [self.imageView setProgress:theProgress withTheme:theme animaed:YES];
    }];
    
    NSOperationQueue *theQueue = [[NSOperationQueue alloc] init];
    [theQueue addOperation:theOperation];
}
@end
