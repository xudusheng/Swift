//
//  LSImage.h
//
//  LayerSprites Project
//  Version 1.2
//
//  Created by Nick Lockwood on 18/05/2013.
//  Copyright 2013 Charcoal Design
//
//  Distributed under the permissive zlib License
//  Get the latest version from here:
//
//  https://github.com/nicklockwood/LayerSprites
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface LSImage : NSObject <NSCopying>

@property (nonatomic, readonly) CGSize size;
@property (nonatomic, readonly) CGFloat scale;
@property (nonatomic, readonly) CGRect contentsRect;
@property (nonatomic, readonly) CGSize originalSize;
@property (nonatomic, readonly) CGPoint anchorPoint;
@property (nonatomic, readonly) CGAffineTransform transform;
@property (nonatomic, readonly) CGImageRef CGImage;

+ (LSImage *)imageWithUIImage:(UIImage *)image
                 contentsRect:(CGRect)contentsRect
                  anchorPoint:(CGPoint)anchorPoint
                      rotated:(BOOL)rotated;

- (LSImage *)initWithUIImage:(UIImage *)image
                contentsRect:(CGRect)contentsRect
                 anchorPoint:(CGPoint)anchorPoint
                     rotated:(BOOL)rotated;

- (CGRect)rectWhenDrawnAtPoint:(CGPoint)point;
- (void)drawAtPoint:(CGPoint)point;
- (void)drawInRect:(CGRect)rect;

@end


@interface CALayer (LSImage)

- (void)setContentsWithLSImage:(LSImage *)image;
- (void)setDimensionsWithLSImage:(LSImage *)image;

@end
