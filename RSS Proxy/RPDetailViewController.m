//
//  RPDetailViewController.m
//  RSS Proxy
//
//  Created by Markus Klepp on 5/20/13.
//  Copyright (c) 2013 aykit. All rights reserved.
//

#import "NSString+HTML.h"
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
        
        // Update the view when on iPad
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            [self configureView];
        }
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.detailItem) {
//        self.detailTitleLabel.text = self.detailItem.title;
//        self.detailDateLabel.text = [dateFormatter stringFromDate: self.detailItem.timestamp];
//        self.detailDescriptionLabel.text = self.detailItem.desc;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        
        NSString *dateString = [dateFormatter stringFromDate: self.detailItem.timestamp];
        
        const CGFloat fontSize = 17;
        UIFont *boldFont = [UIFont boldSystemFontOfSize:fontSize + 5];
        UIFont *regularFont = [UIFont systemFontOfSize:fontSize];
        
        NSDictionary *boldAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                               boldFont, NSFontAttributeName, nil];
        NSDictionary *defaultAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                                  regularFont, NSFontAttributeName, nil];
        
        NSRange titleRange = NSMakeRange(0,self.detailItem.title.length);
//        NSRange dateRange = NSMakeRange(titleRange.location+1,dateString.length);
//        NSRange textRange = NSMakeRange(dateRange.location+1,self.detailItem.desc.length);

        NSString *wholeText = [NSString stringWithFormat:@"%@\n\n%@\n\n%@", self.detailItem.title, dateString, self.detailItem.desc];
        
        NSMutableAttributedString *attributedText =
        [[NSMutableAttributedString alloc] initWithString:wholeText
                                               attributes:defaultAttrs];
        
        [attributedText setAttributes:boldAttrs range:titleRange];
        
        self.detailContentText.attributedText = attributedText;
        
        
//        CGFloat titleFontSize = self.detailTitleLabel.font.pointSize;
//        [self.detailTitleLabel setNumberOfLines:2];
//        CGSize titleSize = [self.detailItem.title sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:titleFontSize]}];
//        
//        CGRect newTitleFrame = CGRectMake(self.detailTitleLabel.frame.origin.x, self.detailTitleLabel.frame.origin.y, titleSize.width, titleSize.height);
//        
//        CGFloat heightDiff = newTitleFrame.size.height - self.detailTitleLabel.frame.size.height;
//        
//        self.detailDateLabel.frame = CGRectMake(self.detailDateLabel.frame.origin.x, self.detailDateLabel.frame.origin.y + heightDiff, self.detailDateLabel.frame.size.width, self.detailDateLabel.frame.size.height);
//        
//        [self.detailTitleLabel setFrame:newTitleFrame];
//        
//        CGSize descriptionViewContentSize = self.detailDescriptionLabel.frame.size;
//        
//        self.detailDescriptionLabel.frame = CGRectMake(self.detailDescriptionLabel.frame.origin.x, self.detailDescriptionLabel.frame.origin.y + heightDiff, descriptionViewContentSize.width, descriptionViewContentSize.height);
//        self.scrollView.contentSize = CGSizeMake(descriptionViewContentSize.width, descriptionViewContentSize.height + self.detailDescriptionLabel.frame.origin.y);
    }
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
