//
//  GameViewController.m
//  NFL-Menu
//
//  Created by mark olson on 4/2/13.
//  Updated by Kafu Chau on 8/7/13.
//  Copyright (c) 2013 Syntaxi. All rights reserved.
//
/*
{
 eid: "2013080800",
 gsis: "56095",
 d: "Thu",
 t: "7:30",
 q: "2", -quarter
 k: "07:02", -time left
 h: "TB",
 hnn: "buccaneers",
 hs: "6",
 v: "BAL",
 vnn: "ravens",
 vs: "7",
 p: "TB", -possession
 rz: "0",
 ga: "",
 gt: "PRE"
}

*/


#import "SYNGameViewController.h"
#import "SYNGameView.h"
#import "SYNAppDelegate.h"

@interface SYNGameViewController ()

@end

@implementation SYNGameViewController
@synthesize raw;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

-(void)setRaw:(NSDictionary *)_raw {
    raw = _raw;
    [home setImage:[NSImage imageNamed:[NSString stringWithFormat:@"%@.png", raw[@"h"]]]];
    [away setImage:[NSImage imageNamed:[NSString stringWithFormat:@"%@.png", raw[@"v"]]]];
    if ([raw[@"q"] isEqualToString:@"P"]) {
        [scoreBox setSegmentCount:1];
        [scoreBox setLabel:[NSString stringWithFormat:@"%@ %@", raw[@"d"], raw[@"t"]] forSegment:0];
        [scoreBox setWidth:96 forSegment:0];
    } else if ([raw[@"q"] isEqualToString:@"H"]) {
        [scoreBox setLabel:[NSString stringWithFormat:@"%@", raw[@"vs"]] forSegment:0];
        [scoreBox setLabel:[NSString stringWithFormat:@"%@", raw[@"hs"]] forSegment:2];
        [scoreBox setLabel:@"Halftime" forSegment:1];
    } else {
        [scoreBox setLabel:[NSString stringWithFormat:@"%@", raw[@"vs"]] forSegment:0];
        [scoreBox setLabel:[NSString stringWithFormat:@"%@", raw[@"hs"]] forSegment:2];
        [scoreBox setLabel:[NSString stringWithFormat:@"%@%@ %@", raw[@"q"], [self ordinalFor:raw[@"q"]], raw[@"k"]] forSegment:1];

        if ([raw[@"p"] isEqualToString:raw[@"v"]]) {
            [scoreBox setSelected:YES forSegment:0];
        } else {
            [scoreBox setSelected:YES forSegment:2];
        }
    }
}

-(NSString *)ordinalFor:(NSString *)str {
    NSString *lastDigit = [str substringFromIndex:([str length]-1)];
    if ([str isEqualToString:@"11"] || [str isEqualToString:@"12"] || [str isEqualToString:@"13"]) {
        return @"th";
    } else if ([lastDigit isEqualToString:@"1"]) {
        return @"st";
    } else if ([lastDigit isEqualToString:@"2"]) {
        return @"nd";
    } else if ([lastDigit isEqualToString:@"3"]) {
        return @"rd";
    } else {
        return @"th";
    }
}

-(void)clicked {
    //http://www.nfl.com/gamecenter/2013080800/2013/PRE1/ravens@buccaneers
    SYNAppDelegate *delegate = [SYNAppDelegate sharedInstance];
    NSMutableString *url = [NSString stringWithFormat:@"http://www.nfl.com/gamecenter/%@/%@/%@%@/%@@%@", raw[@"eid"], delegate.year, delegate.week_type, delegate.week, raw[@"vnn"], raw[@"hnn"]];
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:url]];
}

@end
