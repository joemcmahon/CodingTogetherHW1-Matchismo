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

- (int)match:(NSArray *)otherCards {
    int score = 0;
    for (PlayingCard *otherCard in otherCards) {
        NSLog(@"matching %@ and %@", self.contents, otherCard.contents);
        if ([otherCard.suit isEqualToString:self.suit]) {
            score += 1;
        }
        else if (otherCard.rank == self.rank) {
            score += 4;
        }
    }
    if (score > 0 && [otherCards count] > 1) {
        NSMutableArray *recalcCards = [NSMutableArray arrayWithArray:otherCards];
        PlayingCard *testCard = [recalcCards lastObject];
        [recalcCards removeObject:testCard];
        score += [testCard match:recalcCards];
    }

    NSLog(@"score for the match is %d", score);
    return score;
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
