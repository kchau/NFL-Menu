//
//  SYNAppDelegate.m
//  NFL-Menu
//
//  Created by mark olson on 4/2/13.
//  Updated by Kafu Chau on 8/7/13.
//  Copyright (c) 2013 Syntaxi. All rights reserved.
//

#import "SYNAppDelegate.h"
#import "SYNGameViewController.h"
#import "time.h"

#define kEndGamesList 1869

@implementation SYNAppDelegate

static SYNAppDelegate *_sharedInstance;

+ (SYNAppDelegate *) sharedInstance
{
	if (!_sharedInstance)
	{
		_sharedInstance = [[SYNAppDelegate alloc] init];
	}

	return _sharedInstance;
}

- (void)awakeFromNib {
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:statusMenu];

    NSDictionary *fontattr;
    if ([[[[NSFontManager alloc] init] availableMembersOfFontFamily:@"Apple Color Emoji"] objectAtIndex:0]) {
        fontattr = [NSDictionary dictionaryWithObject:[NSFont fontWithName:@"Apple Color Emoji" size:13] forKey:NSFontAttributeName];
    }else{
        fontattr = @{};
    }
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"🏈" attributes:fontattr];
    
    [statusItem setAttributedTitle:title];
    [statusItem setEnabled:YES];
    [statusItem setHighlightMode:YES];
    [statusMenu setDelegate:self];
}

-(IBAction)updateGames:(id)sender {
    NSString *url = @"http://www.nfl.com/liveupdate/scorestrip/ss.json";
    [self parseURL:url];
}

-(void)parseURL:(NSString*)theURL {
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:theURL]];
    NSDictionary *parsed = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &error];
    NSArray *json_games = (NSMutableArray *)parsed[@"gms"];

    SYNAppDelegate *delegate = [SYNAppDelegate sharedInstance];
    delegate.week = parsed[@"w"];
    delegate.year = parsed[@"y"];
    delegate.week_type = parsed[@"t"];
    NSLog(@"%@, %@, %@", delegate.year, delegate.week_type, delegate.week);
    
    for (NSMenuItem *item in [statusMenu itemArray]){
        if(item.tag >= kEndGamesList){
            break;
        } else {
            [statusMenu removeItem:item];
        }
    }
    
    for (NSDictionary *g in [json_games reverseObjectEnumerator]) {
        [self addGame:g];
    }
}

-(void)addGame:(NSDictionary *)gamedict {
    NSMenuItem *game = [[NSMenuItem alloc]
                        initWithTitle:[NSString stringWithFormat:@"%@ @ %@", gamedict[@"v"], gamedict[@"h"]]
                        action:nil
                        keyEquivalent:@""];
    
    SYNGameViewController *gv = [[SYNGameViewController alloc] init];
    [game setView:gv.view];
    [game setEnabled:YES];
    [game setTag:0];
    [gv setRaw:gamedict];
    [statusMenu insertItem:game atIndex:0];

}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [NSTimer scheduledTimerWithTimeInterval:(60.0 * 2) target:self selector:@selector(updateGames:) userInfo:nil repeats:YES];
    [self updateGames:nil];

}

- (void)menu:(NSMenu *)menu willHighlightItem:(NSMenuItem *)item {
    //NSLog(@"%@", item);
}

@end
