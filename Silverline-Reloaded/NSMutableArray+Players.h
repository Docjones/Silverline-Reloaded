//
//  NSMutableArray+Players.h
//  Silverline-Reloaded
//
//  Created by Marc Rink on 17.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"

@interface NSMutableArray (Players)
-(Player *)getPlayerWithSocket:(AsyncSocket *)socket;
@end
