//
//  RPDetailViewController.h
//  RSS Proxy
//
//  Created by Markus Klepp on 5/20/13.
//  Copyright (c) 2013 aykit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedItem.h"

@interface RPDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) FeedItem* detailItem;

@property (weak, nonatomic) IBOutlet UITextView *detailContentText;
@end
