//
//  TBAttributedLinkLabel.h
//
//  Created by Vasco d'Orey on 10/17/13.
//  Copyright (c) 2013 Tasboa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@class TBAttributedLinkLabel;
@protocol TBLinkLabelDelegate <NSObject>
/**
 TBLinkLabel will detect touched on characters which have the attribute key defined in 'initWithLinkAttributeKey:'
 and forward the associated NSURL to the delegate. If the associated object is not an NSURL nothing will be done.
 */
-(void)linkLabel:(TBAttributedLinkLabel *)linkLabel didDetectTapOnURL:(NSURL *)url;
@end

@interface TBAttributedLinkLabel : UILabel
@property (nonatomic, weak) id <TBLinkLabelDelegate> delegate;
-(id)init __attribute__((deprecated("You should initWithLinkAttributeKey: instead")));
-(id)initWithFrame:(CGRect)frame __attribute__((deprecated("You should initWithFrame:linkAttributeKey: instead")));
-(id)initWithLinkAttributeKey:(NSString *)key;
-(id)initWithFrame:(CGRect)frame linkAttributeKey:(NSString *)key;
@end
