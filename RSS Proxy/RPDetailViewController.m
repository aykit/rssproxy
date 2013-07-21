//
//  RPDetailViewController.m
//  RSS Proxy
//
//  Created by Markus Klepp on 5/20/13.
//  Copyright (c) 2013 aykit. All rights reserved.
//

#import "RPDetailViewController.h"

@interface RPDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation RPDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    
    if (self.detailItem) {
        self.detailTitleLabel.text = self.detailItem.title;
        self.detailDateLabel.text = [dateFormatter stringFromDate: self.detailItem.timestamp];
      //  self.detailDescriptionLabel.text = [self.detailItem.desc stringByConvertingHTMLToPlainText];
        UIFont* systemFont = [UIFont systemFontOfSize:17];
        [self.detailDescriptionWebView loadHTMLString:[NSString stringWithFormat:@"<style>* {margin: 0; padding: 0; border: 0; font-family: \"%@\"}</style>%@", systemFont.familyName, self.detailItem.desc] baseURL:nil];
    }
}

- (void) webViewDidFinishLoad:(UIWebView *)webView{
    CGSize titleSize = [self.detailItem.title sizeWithFont: self.detailTitleLabel.font
                                         constrainedToSize:CGSizeMake(self.detailTitleLabel.frame.size.width, CGFLOAT_MAX)
                                             lineBreakMode:UILineBreakModeWordWrap];
    
    CGRect newTitleFrame = CGRectMake(self.detailTitleLabel.frame.origin.x, self.detailTitleLabel.frame.origin.y, titleSize.width, titleSize.height);
    
    CGFloat heightDiff = newTitleFrame.size.height - self.detailTitleLabel.frame.size.height;
    
    self.detailDateLabel.frame = CGRectMake(self.detailDateLabel.frame.origin.x, self.detailDateLabel.frame.origin.y + heightDiff, self.detailDateLabel.frame.size.width, self.detailDateLabel.frame.size.height);
    
    [self.detailTitleLabel setFrame:newTitleFrame];
    
    CGSize descriptionWebViewContentSize = self.detailDescriptionWebView.scrollView.contentSize;
    
    self.detailDescriptionWebView.frame = CGRectMake(self.detailDescriptionWebView.frame.origin.x, self.detailDescriptionWebView.frame.origin.y + heightDiff, descriptionWebViewContentSize.width, descriptionWebViewContentSize.height);
    self.scrollView.contentSize = CGSizeMake(descriptionWebViewContentSize.width, descriptionWebViewContentSize.height + self.detailDescriptionWebView.frame.origin.y);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
