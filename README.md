TBAttributedLinkLabel
=====================

A UILabel subclass that enables tapping on embedded links.

Example
====

```objective-c
-(void)viewDidLoad
{
  [super viewDidLoad];
  TBAttributedLinkLabel *label = [[TBAttributedLinkLabel alloc] initWithLinkAttributeKey:@"link"];
  label.delegate = self;
  NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] initWithString:@"this link should be tappable"];
  [mas addAttribute:@"link" value:[NSURL URLWithString:@"www.github.com/vascoorey/TBAttributedLinkLabel"] range:NSMakeRange(5, 4)];
  // You will also want to add colors etc.
  label.attributedText = mas;
  ...
}

...

-(void)linkLabel:(TBAttributedLinkLabel *)linkLabel didDetectTapOnURL:(NSURL *)url
{
  if(![[UIApplication sharedApplication] openURL:url])
  {
    NSLog(@"Oops! Couldn't open the URL!");
  }
}
```
