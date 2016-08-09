//
//  GameScene.swift
//  PachinkoWithSpriteKit
//
//  Created by My Nguyen on 8/9/16.
//  Copyright (c) 2016 My Nguyen. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
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
            // create a physics body with a circle shape
            ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2.0)
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
        // set up so the bouncer object won't move when collided
        bouncer.physicsBody!.dynamic = false
        addChild(bouncer)
    }
}
