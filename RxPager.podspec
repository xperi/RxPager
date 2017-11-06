#
# Be sure to run `pod lib lint RxPager.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
	s.name						 = 'RxPager'
	s.version					= '0.1.0'
	s.summary					= 'A short description of RxPager.'

# This description is used to generate tags and improve search results.
#	* Think: What does it do? Why did you write it? What is the focus?
#	* Try to keep it short, snappy and to the point.
#	* Write the description between the DESC delimiters below.
#	* Finally, don't worry about the indent, CocoaPods strips it!

	s.description			= <<-DESC
	TODO: Add long description of the pod here.
											 DESC

	s.homepage				 = 'https://github.com/xperi/RxPager'
	s.license					= { :type => 'MIT', :file => 'LICENSE' }
	s.author					 = { 'xperi' => 'xperi@naver.com' }
	s.source					 = { :git => 'https://github.com/xperi/RxPager.git', :tag => s.version.to_s }

	s.ios.deployment_target = '8.0'

	s.source_files = 'RxPager/Classes/**/*'

	s.dependency 'RxSwift', '~> 3.0'
	s.dependency 'RxCocoa', '~> 3.0'
	s.dependency 'RxDataSources', '~> 1.0'
	s.dependency 'RxSwiftExt', '~> 2.5'

end
