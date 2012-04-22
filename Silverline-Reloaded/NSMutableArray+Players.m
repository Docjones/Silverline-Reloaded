//
//  NSMutableArray+Players.m
//  Silverline-Reloaded
//
//  Created by Marc Rink on 17.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSMutableArray+Players.h"
#import "Player.h"

@implementation NSMutableArray (Players)
-(Player *)getPlayerWithSocket:(AsyncSocket *)socket {
  for (Player *p in self) {
    if ([[p _connection] isEqual:socket]) {
      return p;
    }
  }
  return nil;
}

-(void) addPlayer:(Player *)p {
  [self addObject:p];
  [p setIndex:[self indexOfObject:p]];
  [p setContainer:self];
}

-(void)sendMessage:(NSString*)message fromSender:(Player*)p {
  for (Player *p1 in self) {
    if (![p1 isEqual:p]) {
      [p1 sendMessage:message];
    }
  }
}
@end
