#
# Be sure to run `pod lib lint SwaggerClient.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = "ListView"
    s.version          = "0.1.0"

    s.summary          = "ListView API"
    s.description      = <<-DESC
                         ListView API
                         DESC

    s.platform     = :ios, '8.0'
    s.requires_arc = true


    s.pod_target_xcconfig = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2' }

    s.homepage     = "https://github.com/hivecms/listview"
    s.license      = "MIT"
    s.source       = { :git => "https://github.com/hivecms/listview.git", :tag => "#{s.version}" }
    s.author       = { "linyize" => "linyize@gmail.com" }

    s.source_files = 'ListView/**/*.{m,h}'
    s.public_header_files = 'ListView/**/*.h'


    s.dependency 'SDWebImage'
    s.dependency 'SDWebImage/GIF'
    s.dependency 'TouchXML'
    s.dependency 'Masonry'
    s.dependency 'CSSParser'
end

