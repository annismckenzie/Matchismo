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
#import "GameResult.h"

@interface CardGameViewController()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) GameResult *gameResult;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastFlipResultLabel;
@end

@implementation CardGameViewController

- (GameResult *)gameResult
{
  if (!_gameResult) _gameResult = [[GameResult alloc] initWithGame:@"Memory"];

  return _gameResult;
}

- (CardMatchingGame *)game
{
  if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
                                                        usingDeck:[self gameDeck]
                                                         gameMode:[self gameMode]];

  return _game;
}

- (Deck *)gameDeck
{
  return [[PlayingCardDeck alloc] init];
}

- (NSString *)gameMode
{
  return @"2-card";
}

- (void)setCardButtons:(NSArray *)cardButtons
{
  _cardButtons = cardButtons;
  [self updateUI];
}

- (void)updateUI
{
  for (UIButton *cardButton in self.cardButtons) {
    [self configureCardButton:cardButton forCard:[self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]]];
  }
  self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
  self.lastFlipResultLabel.attributedText = [self formatLastFlipResult:self.game.lastFlip forMatchScore:self.game.lastMatchScore];
}

- (UIButton *)configureCardButton:(UIButton *)cardButton forCard:(Card *)card
{
  UIImage *cardBackImage = [UIImage imageNamed:@"cardback.jpg"];
  UIImage *blank = [[UIImage alloc] init];

  [cardButton setTitle:card.contents forState:UIControlStateSelected];
  [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
  [cardButton setImage:cardBackImage forState:UIControlStateNormal];
  [cardButton setImage:blank forState:UIControlStateSelected];
  [cardButton setImage:blank forState:UIControlStateSelected|UIControlStateDisabled];

  cardButton.selected = card.isFaceUp;
  cardButton.enabled = !card.isUnplayable;
  cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;

  return cardButton;
}

- (void)setFlipCount:(int)flipCount
{
  _flipCount = flipCount;
  self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (IBAction)flipCard:(UIButton *)sender
{
  [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
  self.flipCount++;
  [self updateUI];
  self.gameResult.score = self.game.score;
}

- (IBAction)restartGame:(UIButton *)sender
{
  self.game = nil;
  self.gameResult = nil;
  self.flipCount = 0;
  [self updateUI];
}

- (NSAttributedString *)formatLastFlipResult:(NSArray *)lastFlip forMatchScore:(int)matchScore
{
  NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@""];
  if ([lastFlip count] == 0) {
    return att;
  } else if ([lastFlip count] == 1) {
    [att appendAttributedString:[[NSAttributedString alloc] initWithString:@"Flipped up "]];
    [att appendAttributedString:[[NSAttributedString alloc] initWithString:[lastFlip componentsJoinedByString:@" and "]]];

    return att;
  } else {
    NSString *format = matchScore < 0 ? @"%@ don't match! %d point penalty!" : @"Matched %@ for %d points!";
    [att appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:format, [lastFlip componentsJoinedByString:@" and "], abs(matchScore)]]];

    return att;
  }
}

@end
