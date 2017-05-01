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
    CGFloat _ballSpeed;
    SKNode *_brickLayer;
}

static const uint32_t BALL_CATEGORY   = 0x1 << 0;
static const uint32_t PADDLE_CATEGORY = 0x1 << 1;
static const uint32_t EDGE_CATEGORY   = 0x1 << 2;
static const uint32_t BRICK_CATEGORY  = 0x1 << 3;

-(void)didMoveToView:(SKView *)view {
    [self setupScene];
}

-(void)setupScene {
    /* Setup your scene here */
    
    self.backgroundColor = [SKColor colorWithRed: 0.15 green: 0.15 blue: 0.3 alpha: 1.0];
    
    //Turn off gravity.
    self.physicsWorld.gravity = CGVectorMake(0.0, 0.0);
    
    [self createBallWithLocation:CGPointMake(self.size.width * 0.5, self.size.height * 0.5) andVelocity:CGVectorMake(30, 200)];
    
    //Setup Edge
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    
    
    // Set contact delegate;
    self.physicsWorld.contactDelegate = self;
    //self.physicsBody.categoryBitMask = wallCategory;
    
    // Setup brick layer.
    _brickLayer = [SKNode node];
    _brickLayer.position = CGPointMake(0, self.size.height - 20);
    _brickLayer.zPosition = 2;
    [self addChild:_brickLayer];
    
    //Add some brinks
    for(int row=0; row<5; row++) {
        for(int col=0; col<9; col++) {
            SKSpriteNode *brick = [SKSpriteNode spriteNodeWithImageNamed:@"BrickGreen"];
            brick.position = CGPointMake(2 + (brick.size.width * 0.5) + ((brick.size.width + 3) * col)
                                         , -(2 + (brick.size.height * 0.5) + ((brick.size.height + 3) * row)));
            
            brick.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:brick.size];
            brick.physicsBody.categoryBitMask = BRICK_CATEGORY;
            brick.physicsBody.dynamic = NO;

            [_brickLayer addChild:brick];
        }
    }
    
    
    _paddle = [SKSpriteNode spriteNodeWithImageNamed:@"PaddleBlue"];
    _paddle.position = CGPointMake(self.size.width *0.5, 90);
    _paddle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_paddle.size];
    _paddle.physicsBody.dynamic = NO;
    _paddle.physicsBody.categoryBitMask = PADDLE_CATEGORY;
    _paddle.zPosition = 1;
    [self addChild:_paddle];
    
    // Set initial values.
    _ballSpeed = 250.0;
}

-(SKSpriteNode*)createBallWithLocation:(CGPoint)position andVelocity:(CGVector)velocity {
    SKSpriteNode *ball = [SKSpriteNode spriteNodeWithImageNamed:@"BallBlue"];
    ball.name = @"ball";
    ball.position = position;
    ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball.size.width * 0.5];
    ball.physicsBody.friction = 0.0;
    ball.physicsBody.linearDamping = 0.0;
    ball.physicsBody.restitution = 1.0;
    ball.physicsBody.angularDamping = 0.0;
    ball.physicsBody.velocity = velocity;
    ball.physicsBody.categoryBitMask = BALL_CATEGORY;
    ball.physicsBody.contactTestBitMask = PADDLE_CATEGORY | BRICK_CATEGORY;
    ball.zPosition = 1;
    [self addChild:ball];
    
    //CGVector impulse = CGVectorMake(100.0,100.0);
    //[ball.physicsBody applyImpulse:impulse];
    
    return ball;
}

-(void)didBeginContact:(SKPhysicsContact *)contact {
    SKPhysicsBody *firstBody;
    SKPhysicsBody *secondBody;
    
    if (contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    } else {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    
    if (firstBody.categoryBitMask == BALL_CATEGORY && secondBody.categoryBitMask == BRICK_CATEGORY) {
        [secondBody.node runAction:[SKAction removeFromParent]];
    }
    
    if (firstBody.categoryBitMask == BALL_CATEGORY && secondBody.categoryBitMask == PADDLE_CATEGORY) {
        if (firstBody.node.position.y > secondBody.node.position.y) { // Fix anti-gravity ball
            // Get contact point in paddle coordinates.
            CGPoint pointInPaddle = [secondBody.node convertPoint:contact.contactPoint fromNode:self];
            // Get contact position as a percentage of the paddle's width.
            CGFloat x = (pointInPaddle.x + secondBody.node.frame.size.width * 0.5) / secondBody.node.frame.size.width;
            // Cap percentage and flip it.
            CGFloat multiplier = 1.0 - fmaxf(fminf(x, 1.0),0.0);
            // Caclulate angle based on ball position in paddle.
            CGFloat angle = (M_PI_2 * multiplier) + M_PI_4;
            // Convert angle to vector.
            CGVector direction = CGVectorMake(cosf(angle), sinf(angle));
            // Set ball's velocity based on direction and speed.
            firstBody.velocity = CGVectorMake(direction.dx * _ballSpeed, direction.dy * _ballSpeed);
        }
        
    }
    
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
        
        //Cap paddle position so it remains on screen
        CGFloat paddleMinX = -_paddle.size.width * 0.25;
        CGFloat paddleMaxX = self.size.width + (_paddle.size.width * 0.25);
        
        if(_paddle.position.x < paddleMinX) {
            _paddle.position = CGPointMake(paddleMinX, _paddle.position.y);
        }
        if(_paddle.position.x > paddleMaxX) {
            _paddle.position = CGPointMake(paddleMaxX, _paddle.position.y);
        }
        
        _touchLocation = [touch locationInNode:self];
        
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
