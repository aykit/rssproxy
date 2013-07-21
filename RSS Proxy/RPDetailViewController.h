//
//  RPDetailViewController.h
//  RSS Proxy
//
//  Created by Markus Klepp on 5/20/13.
//  Copyright (c) 2013 aykit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedItem.h"

@interface RPDetailViewController : UIViewController <UISplitViewControllerDelegate, UIWebViewDelegate>

@property (strong, nonatomic) FeedItem* detailItem;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UILabel *detailTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailDateLabel;
@property (weak, nonatomic) IBOutlet UIWebView *detailDescriptionWebView;
@end
