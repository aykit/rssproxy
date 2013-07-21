//
//  Item.m
//  RSS Proxy
//
//  Created by Markus Klepp on 5/20/13.
//  Copyright (c) 2013 aykit. All rights reserved.
//

#import "FeedItem.h"


@implementation FeedItem

@dynamic title;
@dynamic link;
@dynamic desc;
@dynamic timestamp;
@dynamic unread;

- (BOOL)validateForInsert:(NSError **)error
{
    BOOL isValid = [super validateForInsert:error];
    if (isValid){
        NSManagedObjectContext *moc = [self managedObjectContext];
        NSEntityDescription *entityDescription = [NSEntityDescription
                                                  entityForName:@"FeedItem" inManagedObjectContext:moc];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(title LIKE %@) AND (timestamp == %@) AND (unread == 0)", self.title, self.timestamp];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setPredicate:predicate];
        [request setEntity:entityDescription];
        
        NSError *error;
        NSArray *feedItems = [moc executeFetchRequest:request error:&error];
        if (feedItems.count > 0){
            isValid = false;
        }
    }
    return isValid;
}

@end
