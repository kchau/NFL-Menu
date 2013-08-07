//
//  SYNAppDelegate.h
//  NFL-Menu
//
//  Created by mark olson on 4/2/13.
//  Updated by Kafu Chau on 8/7/13.
//  Copyright (c) 2013 Syntaxi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SYNAppDelegate : NSObject <NSApplicationDelegate, NSMenuDelegate> {
    IBOutlet NSMenu *statusMenu;
    
    NSStatusItem *statusItem;
    NSMutableArray *gameArray;
}

+ (SYNAppDelegate *) sharedInstance;

@property (assign) IBOutlet NSWindow *window;
@property (retain) NSString *week_type;
@property (retain) NSString *week;
@property (retain) NSString *year;


@end
