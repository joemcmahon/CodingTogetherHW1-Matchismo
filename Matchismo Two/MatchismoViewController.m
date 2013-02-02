//
//  MatchismoViewController.m
//  Matchismo Two
//
//  Created by Joe McMahon on 2/2/13.
//  Copyright (c) 2013 Joe McMahon. All rights reserved.
//

#import "MatchismoViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@interface MatchismoViewController ()
@property (weak, nonatomic) IBOutlet UIButton *shownCard;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) PlayingCardDeck *deck;
@end

@implementation MatchismoViewController

- (Deck *) deck {
    if(! _deck) _deck = [[PlayingCardDeck alloc] init];
    return _deck;
}

- (void) setFlipCount:(int)flipCount {
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (IBAction)flipCard:(UIButton *)sender {
    if (!sender.selected) {
        // back showing, set front to a new card
        PlayingCard *newCard = [self.deck drawRandomCard];
        [self.shownCard setTitle:newCard.contents forState:UIControlStateSelected];
    }
    sender.selected = ! sender.selected;
    self.flipCount++;
}
@end
