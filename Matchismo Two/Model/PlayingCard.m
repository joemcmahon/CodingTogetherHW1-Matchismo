//
//  PlayingCard.m
//  Matchismo
//
//  Created by Joe McMahon on 2/2/13.
//  Copyright (c) 2013 Joe McMahon. All rights reserved.
//

#import "PlayingCard.h"

@interface PlayingCard()

@end

@implementation PlayingCard

@synthesize suit = _suit;

+ (NSArray *)validSuits {
    return @[ @"♥", @"♦", @"♣", @"♠" ];
}

+ (NSArray *)rankStrings {
    return @[@"?", @"A", @"2", @"3",
             @"4", @"5", @"6", @"7",
             @"8", @"9", @"10", @"J",
             @"Q", @"K"];
}

+ (NSUInteger)maxRank {
    return [self rankStrings].count - 1;
}

- (NSString *)contents {
    return [[PlayingCard rankStrings][self.rank] stringByAppendingString:self.suit];
}

- (void) setSuit:(NSString *)suit {
    if( [[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (void) setRank:(NSUInteger)rank {
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

- (NSString *)suit {
    return _suit ? _suit : @"?";
}

@end
