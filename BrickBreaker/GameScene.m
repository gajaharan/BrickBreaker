//
//  GameScene.m
//  BrickBreaker
//
//  Created by Gajaharan Satkunanandan on 29/04/2017.
//  Copyright (c) 2017 Gajaharan Satkunanandan. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene
{
    SKSpriteNode *_paddle;
    CGPoint _touchLocation;
}

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    
    self.backgroundColor = [SKColor colorWithRed: 0.15 green: 0.15 blue: 0.3 alpha: 1.0];
    
    _paddle = [SKSpriteNode spriteNodeWithImageNamed:@"PaddleBlue"];
    _paddle.position = CGPointMake(self.size.width *0.5, 90);
    [self addChild:_paddle];

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        _touchLocation = [touch locationInNode:self];
    }
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    for(UITouch *touch in touches) {
        // Calculate how far touch has moved on x axis.
        CGFloat xMovement = [touch locationInNode:self].x - _touchLocation.x;
        // Move paddle distance of touch
        _paddle.position = CGPointMake(_paddle.position.x + xMovement, _paddle.position.y);
        
        //Limit Paddle movement
        
        _touchLocation = [touch locationInNode:self];
        
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
