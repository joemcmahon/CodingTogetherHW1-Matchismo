//
//  MatchismoViewController.m
//  Matchismo Two
//
//  Created by Joe McMahon on 2/2/13.
//  Copyright (c) 2013 Joe McMahon. All rights reserved.
//

#import "MatchismoViewController.h"
#import "Deck.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "CardMatchingGame.h"

@interface MatchismoViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UIButton *shownCard;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastMovePointsLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *cardCountSwitch;

@end

@implementation MatchismoViewController

- (IBAction)setMatchCount:(UISegmentedControl *)sender {
    self.game.matchCount = [sender selectedSegmentIndex] + 2;
    NSLog(@"match count %d", self.game.matchCount);
}

- (IBAction)resetGame:(id)sender {
    self.flipCount = 0;
    self.game = nil;
    [self updateUI];
    self.gameStateLabel.text = @"Let's go again!";
    self.lastMovePointsLabel.text = @"";
}

- (CardMatchingGame *) game {
    if (!_game) _game =
        [[CardMatchingGame alloc]
                         initWithCardCount:self.cardButtons.count
                                 usingDeck:[[PlayingCardDeck alloc] init]
                                matchCount:2];
    return _game;
}

- (void) setCardButtons:(NSArray *)cardButtons{
    _cardButtons = cardButtons;
    [self updateUI];
}

- (void) setFlipCount:(int)flipCount {
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (void) updateUI {
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents
                    forState:UIControlStateSelected];
        [cardButton setTitle:card.contents
                    forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = ! card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.gameStateLabel.text = self.game.lastMove;
    self.lastMovePointsLabel.text = [NSString stringWithFormat:@"%@%d points", self.game.pointsForMove > 0 ? @"+" : @"", self.game.pointsForMove];
}

- (IBAction)flipCard:(UIButton *)sender {
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    [self updateUI];
}

@end
