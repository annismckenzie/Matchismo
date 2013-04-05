//
//  SetCardGameViewController.m
//  Matchismo
//
//  Created by Daniel Lohse on 4/1/13.
//  Copyright (c) 2013 dozeo GmbH. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "GameResult.h"

@interface SetCardGameViewController()
@property (strong, nonatomic) GameResult *gameResult;
@end

@implementation SetCardGameViewController

- (GameResult *)gameResult
{
  if (!_gameResult) _gameResult = [[GameResult alloc] initWithGame:@"Set"];

  return _gameResult;
}

- (Deck *)gameDeck
{
  return [[SetCardDeck alloc] init];
}

- (NSString *)gameMode
{
  return @"3-card";
}

- (UIButton *)configureCardButton:(UIButton *)cardButton forCard:(Card *)card
{
  NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:card.contents];
  [att setAttributes:[self attributesForCard:card] range:NSMakeRange(0, [[att string] length])];
  [cardButton setAttributedTitle:att forState:UIControlStateNormal];
  [cardButton setAttributedTitle:att forState:UIControlStateSelected];
  [cardButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@""] forState:UIControlStateSelected|UIControlStateDisabled];
  [cardButton setBackgroundColor:(card.isFaceUp ? [UIColor lightGrayColor] : [UIColor whiteColor])];

  cardButton.selected = card.isFaceUp;
  cardButton.enabled = !card.isUnplayable;
  cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;

  return cardButton;
}

- (NSMutableDictionary *)attributesForCard:(Card *)card
{
  NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
  SEL s = NSSelectorFromString(((SetCard *)card).color);
  UIColor *strokeColor = [UIColor performSelector:s];
  CGColorRef tmpColor = CGColorCreateCopyWithAlpha([strokeColor CGColor], ((SetCard *)card).shading);
  UIColor *fillColor = [UIColor colorWithCGColor:tmpColor];
  CGColorRelease(tmpColor);

  NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
  paragraphStyle.alignment = NSTextAlignmentCenter;

  attributes[NSFontAttributeName]            = [UIFont systemFontOfSize:18.0];
  attributes[NSParagraphStyleAttributeName]  = paragraphStyle;
  attributes[NSForegroundColorAttributeName] = fillColor;
  attributes[NSStrokeColorAttributeName]     = strokeColor;
  attributes[NSStrokeWidthAttributeName]     = @-6.0;

  return attributes;
}

- (NSDictionary *)attributesForLastFlip:(Card *)card
{
  NSMutableDictionary *attributes = [self attributesForCard:card];
  attributes[NSFontAttributeName]        = [UIFont systemFontOfSize:12.0];
  attributes[NSStrokeWidthAttributeName] = @-3.0;

  return attributes;
}

- (NSAttributedString *)formatLastFlipResult:(NSArray *)lastFlip forMatchScore:(int)matchScore
{
  NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@""];

  if (![lastFlip count]) {
    return att;
  } else if ([lastFlip count] < 3) {
    [att appendAttributedString:[[NSAttributedString alloc] initWithString:@"Flipped up "]];
    [att appendAttributedString:[[NSAttributedString alloc] initWithAttributedString:[self formatLastFlip:lastFlip]]];
  } else {
    if (matchScore < 0) {
      [att appendAttributedString:[[NSAttributedString alloc] initWithAttributedString:[self formatLastFlip:lastFlip]]];
      [att appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" don't match! %d point penalty!", abs(matchScore)]]];
    } else {
      [att appendAttributedString:[[NSAttributedString alloc] initWithString:@"Matched "]];
      [att appendAttributedString:[[NSAttributedString alloc] initWithAttributedString:[self formatLastFlip:lastFlip]]];
      [att appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" for %d points!", abs(matchScore)]]];
    }
  }

  return att;
}

- (NSAttributedString *)formatLastFlip:(NSArray *)lastFlip
{
  NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@""];
  for (SetCard *card in lastFlip) {
    [att appendAttributedString:[[NSAttributedString alloc] initWithString:card.contents attributes:[self attributesForLastFlip:card]]];
    if ([lastFlip lastObject] != card) [att appendAttributedString:[[NSAttributedString alloc] initWithString:@" and "]];
  }

  return att;
}

@end
