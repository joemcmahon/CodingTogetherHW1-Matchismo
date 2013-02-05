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

#pragma mark Class methods for constants

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

#pragma mark Lazy instantiation

- (NSString *)suit {
    // Set suit to "?" if we haven't set it yet.
    return _suit ? _suit : @"?";
}

#pragma mark Setters

- (void) setSuit:(NSString *)suit {
    // Set the suit if it's one of the acceptable values.
    if( [[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (void) setRank:(NSUInteger)rank {
    // Set the rank if it's acceptable.
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

#pragma match Calculate match score (zero if not a match).

- (int)match:(NSArray *)otherCards {
    // Initial score (defaults to zero).
    int score = 0;
    
    // Match the current card against all the other face-up cards. We need
    // to do this match first to ensure we haven't just added a new non-matching
    // card.
    for (PlayingCard *otherCard in otherCards) {
        NSLog(@"matching %@ and %@", self.contents, otherCard.contents);
        if ([otherCard.suit isEqualToString:self.suit]) {
            score += 1;
        }
        else if (otherCard.rank == self.rank) {
            score += 4;
        }
    }
    
    // If the new card matched the cards we already have, we need to calculate the
    // match score for the remaining cards, as long as we have more than one left.
    // (No point trying to match with only one card.)
    if (score > 0 && [otherCards count] > 1) {
        // Copy the cards we have, not including the new one.
        NSMutableArray *recalcCards = [NSMutableArray arrayWithArray:otherCards];
        
        // Pull off the last card.
        PlayingCard *testCard = [recalcCards lastObject];
        [recalcCards removeObject:testCard];
        
        // Recursively score the cards.
        score += [testCard match:recalcCards];
    }

    NSLog(@"score for the match is %d", score);
    return score;
}

- (NSString *)contents {
    // Convenience method to show rank and suit.
    return [[PlayingCard rankStrings][self.rank] stringByAppendingString:self.suit];
}

@end
