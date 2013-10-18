Pod::Spec.new do |s|
  s.name         = "TBAttributedLinkLabel"
  s.version      = "0.0.1"
  s.summary      = "A UILabel subclass with support for detecting tapped links in the attributed text."
  s.homepage     = "http://github.com/Tasboa/TBAttributedLinkLabel"
  s.license      = 'MIT'
  s.author       = { "Vasco Orey" => "vasco.orey@gmail.com" }
  s.platform     = :ios, '6.0'
  s.source       = { :git => "https://github.com/vascoorey/TBAttributedLinkLabel.git", :tag => "0.0.1" }
  s.source_files  = '*.{h,m}'
  s.ios.frameworks = 'Foundation', 'UIKit', 'CoreText'
  s.ios.deployment_target = '6.0' # minimum SDK with autolayout
  s.requires_arc = true
end
