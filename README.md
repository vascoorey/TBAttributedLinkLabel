TBAttributedLinkLabel
=====================

A UILabel subclass that enables tapping on embedded links.

Example
====

In this example we'll be using [BOMarkdownParser](https://github.com/danieleggert/MarkdownParser) to parse a markdown string to an NSAttributedString.

```objective-c
-(void)viewDidLoad
{
  [super viewDidLoad];
  TBAttributedLinkLabel *label = [[TBAttributedLinkLabel alloc] initWithLinkAttributeKey:BOLink];
  label.delegate = self;
  label.attributedText = [[BOMarkdownParser parser] parseString:markdownString];
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
