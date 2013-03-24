//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Daniel Lohse on 3/23/13.
//  Copyright (c) 2013 dozeo GmbH. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastFlipResultLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *matchModeSwitch;
@end

@implementation CardGameViewController

- (CardMatchingGame *)game
{
  if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count usingDeck:[[PlayingCardDeck alloc] init]];

  return _game;
}

- (void)setCardButtons:(NSArray *)cardButtons
{
  _cardButtons = cardButtons;
  [self updateUI];
}

- (void)updateUI
{
  UIImage *cardBackImage = [UIImage imageNamed:@"cardback.jpg"];
  for (UIButton *cardButton in self.cardButtons) {
    Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];

    [cardButton setTitle:@"" forState:UIControlStateHighlighted];
    [cardButton setTitle:@"" forState:UIControlStateSelected|UIControlStateHighlighted];
    [cardButton setTitle:card.contents forState:UIControlStateSelected];
    [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];

    [cardButton setBackgroundImage:cardBackImage forState:UIControlStateNormal];
    [cardButton setBackgroundImage:nil forState:UIControlStateSelected]; // doesn't work properly
    [cardButton setBackgroundImage:nil forState:UIControlStateSelected|UIControlStateDisabled]; // doesn't work properly

    cardButton.selected = card.isFaceUp;
    cardButton.enabled = !card.isUnplayable;
    cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
  }
  self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
  self.lastFlipResultLabel.text = [self formatLastFlipResult];
}

- (void)setFlipCount:(int)flipCount
{
  _flipCount = flipCount;
  self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
  self.matchModeSwitch.enabled = !flipCount;
}

- (IBAction)flipCard:(UIButton *)sender
{
  [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
  self.flipCount++;
  [self updateUI];
}

- (IBAction)restartGame:(UIButton *)sender
{
  _game = nil;
  self.flipCount = 0;
  [self updateUI];
}

- (IBAction)changeGameMode:(UISegmentedControl *)sender {
  self.game.mode = [sender titleForSegmentAtIndex:sender.selectedSegmentIndex]; // either @"2-card" or @"3-card"
}

- (NSString *)formatLastFlipResult
{
  if ([self.game.lastFlip count] == 0) {
    return @"";
  } else if ([self.game.lastFlip count] == 1) {
    return [NSString stringWithFormat:@"Flipped up %@", [self.game.lastFlip lastObject]];
  } else {
    NSString *format = self.game.lastMatchScore < 0 ? @"%@ don't match! %d point penalty!" : @"Matched %@ for %d points!";
    return [NSString stringWithFormat:format, [self.game.lastFlip componentsJoinedByString:@" and "], abs(self.game.lastMatchScore)];
  }
}

@end
