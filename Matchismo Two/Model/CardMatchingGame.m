//
//  CardMatchingGame.m
//  Matchismo Two
//
//  Created by Joe McMahon on 2/2/13.
//  Copyright (c) 2013 Joe McMahon. All rights reserved.
//

#import "CardMatchingGame.h"
#import "Deck.h"
#import "Card.h"
#import "PlayingCard.h"

#define MATCH_BONUS         4
#define MISMATCH_PENALTY    2
#define FLIP_COST           1

@interface CardMatchingGame()
@property (strong, nonatomic) NSMutableArray *cards;
@property (nonatomic, readwrite) int score;
@property (nonatomic, readwrite) NSString *lastMove;
@property (nonatomic, readwrite) int pointsForMove;
@property (nonatomic) int cardsFaceUp;
@end

@implementation CardMatchingGame

- (void) setMatchCount:(int)matchCount {
    if (matchCount > 3) matchCount = 3;
    if (matchCount < 2) matchCount = 2;
    _matchCount = matchCount;
}

- (NSMutableArray *)cards {
    if (! _cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (id) initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck matchCount:(NSUInteger)matchCount{
    self = [super init];
    if (self) {
        self.matchCount = matchCount;
        for (int i = 0; i < cardCount; i++) {
            Card *card = [deck drawRandomCard];
            if (!card) {
                self = nil;
                break;
            }
            else {
                self.cards[i] = card;
            }
        }
    }
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index {
    return index < self.cards.count ? self.cards[index] : nil;
}

- (void) flipCardAtIndex:(NSUInteger)index {
    Card *card = [self cardAtIndex:index];
    BOOL stateChanged = NO;
    
    if (! card.isUnplayable) {
        if (! card.isFaceUp) {
            for (Card *otherCard in self.cards) {
                if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                    int matchScore = [card match:@[otherCard]];
                    stateChanged = YES;
                    if (matchScore) {
                        otherCard.unplayable = YES;
                        card.unplayable = YES;
                        self.pointsForMove = matchScore * MATCH_BONUS;
                        self.score += self.pointsForMove;
                        self.lastMove = [NSString stringWithFormat:@"%@ matched %@", card.contents, otherCard.contents];
                    }
                    else {
                        otherCard.faceUp = NO;
                        self.pointsForMove = -MISMATCH_PENALTY;
                        self.score += self.pointsForMove;
                        self.lastMove = [NSString stringWithFormat:@"%@ and %@ don't match", card.contents, otherCard.contents];
                    }
                    break;
                }
            }
            self.score -= FLIP_COST;
            if (! stateChanged) {
                self.lastMove = [NSString stringWithFormat:  @"Flipped up %@", card.contents];
                self.pointsForMove -= FLIP_COST;
            }
        }
        card.faceUp = ! card.faceUp;
    }
}
@end
