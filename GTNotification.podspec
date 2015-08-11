Pod::Spec.new do |s|
  s.name         = "GTNotification"
  s.version      = "1.0"
  s.summary      = "[King-Wizard version] An in app customizable notification banner for Swift."
  s.description  = <<-DESC
                   Which slides/fades automatically/manually from the top/bottom of the screen.
                   DESC
  s.homepage     = "https://github.com/King-Wizard/GTNotification"
  s.license      = "MIT"
  s.author             = { "Mathieu White" => "", "King-Wizard" => "king.wizard.contact@gmail.com" }
  s.social_media_url   = "https://twitter.com/KingWizardTwitt"
  s.platform     = :ios, "8.4"
  s.source = { :git => "https://github.com/King-Wizard/GTNotification.git", :tag => s.version.to_s }
  s.source_files  = 'GTNotification/*.swift'
end
