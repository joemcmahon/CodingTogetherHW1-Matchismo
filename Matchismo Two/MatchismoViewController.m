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
@property (strong, nonatomic) IBOutlet UISlider *historySlider;
@property (strong, nonatomic) NSMutableArray *gameStates;

@end

@implementation MatchismoViewController

#pragma mark Lazy instatiations

- (NSMutableArray *)gameStates {
    if (!_gameStates) _gameStates = [[NSMutableArray alloc] init];
    return _gameStates;
}

- (void) setCardButtons:(NSArray *)cardButtons{
    _cardButtons = cardButtons;
    [self updateUI];
}

- (CardMatchingGame *) game {
    // Lazy instantiation of the game. Defaults:
    // - use the number of buttons we're showing as the card count
    // - create a brand new deck just for this game
    // - default the match count setting to match the UI default.
    if (!_game) _game =
        [[CardMatchingGame alloc]
         initWithCardCount:self.cardButtons.count
         usingDeck:[[PlayingCardDeck alloc] init]
         matchCount:[self.cardCountSwitch selectedSegmentIndex]+2];
    return _game;
}

#pragma mark History slider

- (void) setFlipCount:(int)flipCount {
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (IBAction)sweepThroughHistory:(UISlider *)sender {
}

#pragma mark Segmented control 

- (IBAction)setMatchCount:(UISegmentedControl *)sender {
    self.game.matchCount = [sender selectedSegmentIndex] + 2;
    NSLog(@"match count %d", self.game.matchCount);
}

#pragma mark Reset button

- (IBAction)resetGame:(id)sender {
    // Start of game:
    
    // No cards flipped.
    self.flipCount = 0;
    
    // Discard old game state (it will lazily reinitialize itself).
    self.game = nil;
    
    // New status message for reset.
    self.gameStateLabel.text = @"Let's go again!";
    
    // Nothing happened yet, so there's no 'last move' status.
    self.lastMovePointsLabel.text = @"";
    
    // Enable the 2 card/3 card switch until the first flip happens.
    [self.cardCountSwitch setEnabled:YES];
    
    // Display everything.
    [self updateUI];

}

#pragma mark Main UI display

- (void) updateUI {
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        UIImage *cardBackImage = [UIImage imageNamed:@"cardback.png"];
        // Set the cardback image if we're face down, delete it if we're not.
        [cardButton setImage:(! card.isFaceUp ? cardBackImage : nil)
                    forState:UIControlStateNormal];
        // If card is face up (either playable or not), show the card contents in the button.
        [cardButton setTitle:card.contents
                    forState:UIControlStateSelected];
        [cardButton setTitle:card.contents
                    forState:UIControlStateSelected|UIControlStateDisabled];
 
        // Mark the button as selected if the card is face-up.
        cardButton.selected = card.isFaceUp;
        // Enable if playable, disable if not.
        cardButton.enabled = ! card.isUnplayable;
        // Dim it if it's no longer playable.
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
    }
    // Update status messages.
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.gameStateLabel.text = self.game.lastMove;
    self.lastMovePointsLabel.text = [NSString stringWithFormat:@"%@%d points", self.game.pointsForMove > 0 ? @"+" : @"", self.game.pointsForMove];
}

#pragma mark Card flipping

- (IBAction)flipCard:(UIButton *)sender {
    // Flip the card just tapped. Game will manage scoring, etc.; we just display it all
    // in updateUI.
    int currentCard = [self.cardButtons indexOfObject:sender];
    [self.game flipCardAtIndex:currentCard];
    // Another flip (game doesn't care about or track flip count).
    self.flipCount++;
    [self updateUI];
    // We've started playing, so turn off the mode switch.
    [self.cardCountSwitch setEnabled:NO];
}

@end
