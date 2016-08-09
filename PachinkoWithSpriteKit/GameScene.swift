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
    }

    // this method is triggered when the user touches the screen.
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            // fetch the location where the screen is touched
            let location = touch.locationInNode(self)
            // create a node filled with red color with size of 64 by 64
            let box = SKSpriteNode(color: UIColor.redColor(), size: CGSize(width: 64, height: 64))
            // add a physics body to the box, which is a rectangle of the same size as the box
            // the effect is the box now appears to have physics so that it falls to the screen bottom
            box.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 64, height: 64))
            // set the box's position at where the touch occurred
            box.position = location
            // add the box to the scene
            addChild(box)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
