//
//  GameScene.swift
//  PachinkoWithSpriteKit
//
//  Created by My Nguyen on 8/9/16.
//  Copyright (c) 2016 My Nguyen. All rights reserved.
//

import SpriteKit

// class conforms to the SKPhysicsContactDelegate protocol
class GameScene: SKScene, SKPhysicsContactDelegate {
    override func didMoveToView(view: SKView) {
        /// draw a dark blue background (replacing the default gray background) image in the center of the screen
        let background = SKSpriteNode(imageNamed: "background.jpg")
        // place this background image in the center of a landscape iPad
        background.position = CGPoint(x: 512, y: 384)
        // ignore alpha values
        background.blendMode = .Replace
        // draw the image behind everything else
        background.zPosition = -1
        // add this image to the current screen
        addChild(background)
        // add a physics body to the whole scene (edgeLoopFromRect goes around the scene)
        // the effect is the falling boxes in touchesBegan() will be stopped/contained at the screen bottom
        physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)

        // set the current scene as the physics world's contact delegate
        physicsWorld.contactDelegate = self

        // make 4 slots, good and bad interwoven
        makeSlotAt(CGPoint(x: 128, y: 0), isGood: true)
        makeSlotAt(CGPoint(x: 384, y: 0), isGood: false)
        makeSlotAt(CGPoint(x: 640, y: 0), isGood: true)
        makeSlotAt(CGPoint(x: 896, y: 0), isGood: false)

        // create 5 bouncers spread evenly across the bottom of the screen
        makeBouncerAt(CGPoint(x: 0, y: 0))
        makeBouncerAt(CGPoint(x: 256, y: 0))
        makeBouncerAt(CGPoint(x: 512, y: 0))
        makeBouncerAt(CGPoint(x: 768, y: 0))
        makeBouncerAt(CGPoint(x: 1024, y: 0))
    }

    // this method is triggered when the user touches the screen.
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            // fetch the location where the screen is touched
            let location = touch.locationInNode(self)
            // create a Sprite node based on the image "ballRed.png"
            let ball = SKSpriteNode(imageNamed: "ballRed")
            // give the ball node a generic name
            ball.name = "ball"
            // create a physics body with a circle shape
            ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2.0)
            // set the ball node's contactTestBitMask property to its collisionBitMask
            // contactTestBitMask: which collisions do you want to now about? by default it's set to nothing
            // collisionBitMask: which nodes should I bump into? by default it's set to everything
            // setting contactTestBitMask to collisionBitMask: tell me about every collision
            ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
            // set the ball bounciness
            ball.physicsBody!.restitution = 0.4
            // set the ball's position at where the touch occurred
            ball.position = location
            // add the ball to the scene
            addChild(ball)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }

    // create a stationary node which won't budge when collided by red balls
    func makeBouncerAt(position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width/2.0)

        // setting contactTestBitMask to collisionBitMask: tell me about every collision
        bouncer.physicsBody!.contactTestBitMask = bouncer.physicsBody!.collisionBitMask
        
        // set up so the bouncer object won't move when collided
        bouncer.physicsBody!.dynamic = false
        addChild(bouncer)
    }

    // create a slot (good or bad)
    func makeSlotAt(position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode

        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            // assign name to the slot for general usage, as opposed to declaring multiple variables
            // for different slots
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }

        slotBase.position = position
        slotGlow.position = position

        // add rectangle physics to the slot
        slotBase.physicsBody = SKPhysicsBody(rectangleOfSize: slotBase.size)
        // slot needs to be stationary
        slotBase.physicsBody!.dynamic = false

        addChild(slotBase)
        addChild(slotGlow)

        // rotate the node by 90 degrees over 10 seconds
        let spin = SKAction.rotateByAngle(CGFloat(M_PI_2), duration: 10)
        // repeat the rotation forever
        let spinForever = SKAction.repeatActionForever(spin)
        slotGlow.runAction(spinForever)
    }

    // invoked when there's contact between 2 objects
    func didBeginContact(contact: SKPhysicsContact) {
        if contact.bodyA.node!.name == "ball" {
            collisionBetweenBall(contact.bodyA.node!, object: contact.bodyB.node!)
        } else if contact.bodyB.node!.name == "ball" {
            collisionBetweenBall(contact.bodyB.node!, object: contact.bodyA.node!)
        }
    }

    func collisionBetweenBall(ball: SKNode, object: SKNode) {
        // remove ball when it collides with either the good or the bad slot
        if object.name == "good" {
            destroyBall(ball)
        } else if object.name == "bad" {
            destroyBall(ball)
        }
        // ignore when 2 balls collide, so the 2 balls will remain intact
    }

    func destroyBall(ball: SKNode) {
        // remove the ball from the game
        ball.removeFromParent()
    }
}
