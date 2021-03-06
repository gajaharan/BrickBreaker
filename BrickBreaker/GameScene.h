//
//  GameScene.h
//  BrickBreaker
//

//  Copyright (c) 2017 Gajaharan Satkunanandan. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

static const int FINAL_LEVEL_NUMBER = 3;

static const uint32_t BALL_CATEGORY   = 0x1 << 0;
static const uint32_t PADDLE_CATEGORY = 0x1 << 1;
static const uint32_t EDGE_CATEGORY   = 0x1 << 2;

@interface GameScene : SKScene <SKPhysicsContactDelegate>

@property (nonatomic) int currentLevel;
@property (nonatomic) int lives;

@end
