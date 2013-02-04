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
@property (strong, nonatomic) NSMutableArray *cardsFaceUp;
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

- (NSMutableArray *)cardsFaceUp {
    if(!_cardsFaceUp) _cardsFaceUp = [[NSMutableArray alloc] init];
    return _cardsFaceUp;
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
    self.pointsForMove = 0;
    
    if (! card.isUnplayable) {
        // Card is playable.
        if (! card.isFaceUp) {
            // Card is facedown.
            if ([self.cardsFaceUp count]) {
                // At least one other card face up. Make sure the new one matches the card
                // or cards already face up.
                NSLog(@"Checking %@ against other cards", card.contents);
                int matchScore = [card match:self.cardsFaceUp];
                NSLog(@"Tentative score is %d", matchScore);
            
                if (matchScore) {
                    // New card matches face-up cards. Add it to the face-up list.
                    [self.cardsFaceUp addObject:card];
                    card.faceUp = YES;
                    
                    NSLog(@"%d cards face up", [self.cardsFaceUp count]);
                    if ([self.cardsFaceUp count] == self.matchCount) {
                        // We've matched the desired number of cards. Score.
                        NSLog(@"Scoring");
                        self.score += matchScore;
                        
                        // State has changed.
                        stateChanged = YES;
                
                        // Build the status message, listing the matching cards.
                        self.lastMove = [NSString stringWithFormat:@"Matched"];
                        for (Card *displayCard in self.cardsFaceUp) {
                            self.lastMove =
                            [self.lastMove stringByAppendingString:
                                [NSString stringWithFormat:@" %@", displayCard.contents]];
                            displayCard.faceUp = YES;
                            // This card has been played; mark it unplayable now.
                            displayCard.unplayable = YES;
                        }
                        NSLog(@"%@",self.lastMove);
                        
                        // Mark the card that triggered the successful full match unplayable too.
                        card.unplayable = YES;
                        card.faceUp = YES;
                        
                        // No cards face up now.
                        self.cardsFaceUp = nil;
                        
                        // Update the score.
                        self.pointsForMove = matchScore * MATCH_BONUS;
                    }
                }
                else {
                    // This card didn't match the ones already there.
                    // Assess the penalty and flip the others facedown again.
                    NSLog(@"Bad card, no biscuit");
                    self.pointsForMove = -MISMATCH_PENALTY;
                    self.lastMove = [NSString stringWithFormat:@"%@ doesn't match",
                                     card.contents];
                    for (Card *displayCard in self.cardsFaceUp) {
                        self.lastMove = [self.lastMove stringByAppendingString:[NSString stringWithFormat:@" %@", displayCard]];
                        displayCard.faceUp = NO;
                    }
                    self.cardsFaceUp = nil;
                    // no other cards face up, add this one.
                    [self.cardsFaceUp addObject:card];
                    card.faceUp = YES;
                    NSLog(@"%@",self.lastMove);
                }
            }
            else {
                // No other cards up. Just remember this one. Don't match. Turn it face up.
                [self.cardsFaceUp addObject:card];
                card.faceUp = YES;
                NSLog(@"First card");
                NSLog(@"%@",self.cardsFaceUp);
            }
            // Card management done. If we didn't change the state, just charge the flip cost.
            self.score += self.pointsForMove;
            if (! stateChanged) {
                self.lastMove = [NSString stringWithFormat:  @"Flipped up %@", card.contents];
                self.pointsForMove -= FLIP_COST;
            }
        }
        else {
            // Card was face-up. Remove it from the face-up list. No charge.
            NSLog(@"Flipping card down");
            [self.cardsFaceUp removeObject:card];
            card.faceUp = NO;
            self.lastMove = [NSString stringWithFormat:  @"Flipped down %@", card.contents];
        }
    }
}
@end
