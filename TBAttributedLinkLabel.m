//
//  TBAttributedLinkLabel.m
//
//  Created by Vasco d'Orey on 10/17/13.
//  Copyright (c) 2013 Tasboa. All rights reserved.
//

#import "TBAttributedLinkLabel.h"

@interface TBAttributedLinkLabel ()
@property (nonatomic) CTFramesetterRef framesetter;
@property (nonatomic, strong) NSString *linkAttributeKey;
@end

@implementation TBAttributedLinkLabel

#pragma mark - Public

-(void)setAttributedText:(NSAttributedString *)attributedText
{
  if(self.framesetter)
  {
    CFRelease(self.framesetter);
  }
  self.framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)(attributedText));
  [super setAttributedText:attributedText];
}

-(id)initWithLinkAttributeKey:(NSString *)key
{
  if((self = [super init]))
  {
    _linkAttributeKey = key;
  }
  return self;
}

-(id)initWithFrame:(CGRect)frame linkAttributeKey:(NSString *)key
{
  if((self = [super initWithFrame:frame]))
  {
    _linkAttributeKey = key;
  }
  return self;
}

-(id)init
{
  self = [super init];
  return self;
}

-(id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  return self;
}

#pragma mark - Private

/**
 Shamelessly copied from TTTAttributedLabel, cheers mattt ;)
 
 @see TTTAttributedLabel
 */
- (CFIndex)characterIndexAtPoint:(CGPoint)p {
  if (!CGRectContainsPoint(self.bounds, p)) {
    return NSNotFound;
  }
  
  CGRect textRect = [self textRectForBounds:self.bounds limitedToNumberOfLines:self.numberOfLines];
  if (!CGRectContainsPoint(textRect, p)) {
    return NSNotFound;
  }
  
  // Offset tap coordinates by textRect origin to make them relative to the origin of frame
  p = CGPointMake(p.x - textRect.origin.x, p.y - textRect.origin.y);
  // Convert tap coordinates (start at top left) to CT coordinates (start at bottom left)
  p = CGPointMake(p.x, textRect.size.height - p.y);
  
  CGMutablePathRef path = CGPathCreateMutable();
  CGPathAddRect(path, NULL, textRect);
  CTFrameRef frame = CTFramesetterCreateFrame(self.framesetter, CFRangeMake(0, [self.attributedText length]), path, NULL);
  if (frame == NULL) {
    CFRelease(path);
    return NSNotFound;
  }
  CFArrayRef lines = CTFrameGetLines(frame);
  NSInteger numberOfLines = self.numberOfLines > 0 ? MIN(self.numberOfLines, CFArrayGetCount(lines)) : CFArrayGetCount(lines);
  if (numberOfLines == 0) {
    CFRelease(frame);
    CFRelease(path);
    return NSNotFound;
  }
  
  NSUInteger idx = NSNotFound;
  
  CGPoint lineOrigins[numberOfLines];
  CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), lineOrigins);
  
  for (CFIndex lineIndex = 0; lineIndex < numberOfLines; lineIndex++) {
    CGPoint lineOrigin = lineOrigins[lineIndex];
    CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
    
    // Get bounding information of line
    CGFloat ascent, descent, leading, width;
    width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    CGFloat yMin = floor(lineOrigin.y - descent);
    CGFloat yMax = ceil(lineOrigin.y + ascent);
    
    // Check if we've already passed the line
    if (p.y > yMax) {
      break;
    }
    // Check if the point is within this line vertically
    if (p.y >= yMin) {
      // Check if the point is within this line horizontally
      if (p.x >= lineOrigin.x && p.x <= lineOrigin.x + width) {
        // Convert CT coordinates to line-relative coordinates
        CGPoint relativePoint = CGPointMake(p.x - lineOrigin.x, p.y - lineOrigin.y);
        idx = CTLineGetStringIndexForPosition(line, relativePoint);
        break;
      }
    }
  }
  
  CFRelease(frame);
  CFRelease(path);
  
  return idx;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  if([self.delegate conformsToProtocol:@protocol(TBLinkLabelDelegate)])
  {
    CGPoint touchLocation = [[touches anyObject] locationInView:self];
    CFIndex idx = [self characterIndexAtPoint:touchLocation];
    if(idx != NSNotFound)
    {
      NSDictionary *attributes = [self.attributedText attributesAtIndex:idx effectiveRange:NULL];
      id url = nil;
      if((url = attributes[self.linkAttributeKey]) && [url isKindOfClass:[NSURL class]])
      {
        [self.delegate performSelector:@selector(linkLabel:didDetectTapOnURL:) withObject:self withObject:url];
      }
    }
  }
}

@end
