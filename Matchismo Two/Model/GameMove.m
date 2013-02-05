//
//  GameMove.m
//  Matchismo Two
//
//  Created by Joe McMahon on 2/4/13.
//  Copyright (c) 2013 Joe McMahon. All rights reserved.
//

#import "GameMove.h"

@implementation GameMove

- (BOOL) wasFlippedDown {
    return !self.flippedUp;
}

#pragma mark Designated initializer

- (id) initWithCard:(PlayingCard *)card
          flippedUp:(BOOL)flippedUp
            matched:(BOOL)matched
      matchingCards:(NSArray *)matchingCards
            scoring:(NSUInteger)points {
    self = [super init];
    if (self) {
        self.flippedUp = flippedUp;
        self.matched = matched;
        self.matchingCards = matchingCards;
    }
    return self;
}

- (NSMutableString *)description {
    NSMutableString *decodedMove;
    if ([self wasFlippedDown]) {
        decodedMove = [NSMutableString stringWithFormat:@"Flipped down %@", self.card.contents];
    }
    else {
        // flipped up; either matched or did not.
        if (self.didMatch) {
            decodedMove = [NSMutableString stringWithFormat:@"%@ matched", self.card.contents];
            for (PlayingCard *matchedCard in self.matchingCards) {
                [decodedMove stringByAppendingString:[NSString stringWithFormat:@"%@",  matchedCard.contents]];
            }
        }
        else {
            // didn't match; is this a failed match, or 
        }
    }
    return decodedMove;
}
@end
