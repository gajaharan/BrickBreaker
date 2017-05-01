//
//  GameScene.m
//  BrickBreaker
//
//  Created by Gajaharan Satkunanandan on 29/04/2017.
//  Copyright (c) 2017 Gajaharan Satkunanandan. All rights reserved.
//

#import "Brick.h"
#import "GameScene.h"



@implementation GameScene
{
    SKSpriteNode *_paddle;
    CGPoint _touchLocation;
    CGFloat _ballSpeed;
    SKNode *_brickLayer;
    BOOL _ballReleased;
    BOOL _positionBall;
}

-(void)didMoveToView:(SKView *)view {
    [self setupScene];
}

-(void)setupScene {
    /* Setup your scene here */
    
    self.backgroundColor = [SKColor colorWithRed: 0.15 green: 0.15 blue: 0.3 alpha: 1.0];
    
    //Turn off gravity.
    self.physicsWorld.gravity = CGVectorMake(0.0, 0.0);
    
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

    
    _paddle = [SKSpriteNode spriteNodeWithImageNamed:@"PaddleBlue"];
    _paddle.position = CGPointMake(self.size.width *0.5, 90);
    _paddle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_paddle.size];
    _paddle.physicsBody.dynamic = NO;
    _paddle.physicsBody.categoryBitMask = PADDLE_CATEGORY;
    _paddle.zPosition = 1;
    [self addChild:_paddle];
    
    // Set initial values.
    _ballSpeed = 250.0;
    _currentLevel = 0;
    
    // Load Level
    [self loadLevel:_currentLevel];
    
    [self newBall];
}


-(void)newBall
{
    // Remove all bricks including indestruble grey bricks
    [self enumerateChildNodesWithName:@"ball" usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeFromParent];
    }];
    
    // Create positioning ball.
    SKSpriteNode *ball = [SKSpriteNode spriteNodeWithImageNamed:@"BallBlue"];
    ball.position = CGPointMake(self.size.width *0.25, _paddle.size.height*0.5);
    [_paddle addChild:ball];
    _ballReleased = NO;
    //Reset paddle position
    _paddle.position = CGPointMake(self.size.width * 0.5, _paddle.position.y);
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

-(void)loadLevel:(int)levelNumber
{
    [_brickLayer removeAllChildren];
    
    NSArray *level = nil;
    
    switch (levelNumber) {
        case 0:
            level = @[@[@0,@0,@0,@0,@1,@0,@0,@0,@0],
                      @[@0,@0,@0,@0,@0,@0,@0,@0,@0],
                      @[@0,@0,@0,@0,@0,@0,@0,@0,@0],
                      @[@0,@0,@0,@0,@0,@0,@0,@0,@0],
                      @[@0,@0,@0,@0,@0,@0,@0,@0,@0]];
            break;
        case 1:
            level = @[@[@1,@1,@1,@1,@1,@1,@1,@1,@1],
                      @[@0,@1,@1,@1,@1,@1,@1,@1,@0],
                      @[@0,@0,@0,@0,@0,@0,@0,@0,@0],
                      @[@0,@0,@0,@0,@0,@0,@0,@0,@0],
                      @[@0,@2,@2,@2,@2,@2,@2,@2,@0]];
            break;
            
        case 2:
            level = @[@[@4,@1,@2,@2,@2,@2,@2,@1,@4],
                      @[@2,@2,@0,@0,@0,@0,@0,@2,@2],
                      @[@2,@0,@0,@0,@0,@0,@0,@0,@2],
                      @[@0,@0,@1,@1,@1,@1,@1,@0,@0],
                      @[@1,@0,@1,@1,@1,@1,@1,@0,@1],
                      @[@1,@1,@3,@3,@3,@3,@3,@1,@1]];
            break;
            
        case 3:
            level = @[@[@1,@0,@1,@1,@0,@1],
                      @[@1,@0,@1,@1,@0,@1],
                      @[@0,@0,@3,@3,@0,@0],
                      @[@2,@0,@0,@0,@0,@2],
                      @[@0,@0,@1,@1,@0,@0],
                      @[@3,@2,@1,@1,@2,@3]];
            break;
            
        default:
            break;
    }
    
    //Add some brinks
    int row = 0;
    int col = 0;
    for (NSArray *rowBricks in level) {
        col = 0;
        
        for (NSNumber *brickType in rowBricks) {
            if ([brickType intValue] > 0) {
                Brick *brick = [[Brick alloc] initWithType:(BrickType)[brickType intValue]];
                if (brick) {
                    brick.position = CGPointMake(2 + (brick.size.width * 0.5) + ((brick.size.width + 3) * col)
                                                 , -(2 + (brick.size.height * 0.5) + ((brick.size.height + 3) * row)));
                    
                    NSLog(@"add");
                    [_brickLayer addChild:brick];
                }
            }
            col++;
        }
        row++;
    }
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
        if ([secondBody.node respondsToSelector:@selector(hit)]) {
            [secondBody.node performSelector:@selector(hit)];
        }
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

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

        if (_positionBall) {
            _positionBall = NO;
            _ballReleased = YES;
            [_paddle removeAllChildren];
            [self createBallWithLocation:CGPointMake(_paddle.position.x, _paddle.position.y + _paddle.size.height) andVelocity:CGVectorMake(0, _ballSpeed)];
        }
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        
        if (!_ballReleased) {
            _positionBall = YES;
        }
        
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
    
    if ([self isLevelComplete]) {
        self.currentLevel++;
        [self loadLevel:self.currentLevel];
        [self newBall];
    }
}

-(BOOL)isLevelComplete
{
    // Look for remaining bricks that are not indestrucitble.
    for (SKNode *node in _brickLayer.children) {
        if ([node isKindOfClass:[Brick class]]) {
            if (!((Brick*)node).indestructible) {
                return NO;
            }
        }
    }
    // Couldn't find any non-indestructible bricks
    return YES;
}

@end
