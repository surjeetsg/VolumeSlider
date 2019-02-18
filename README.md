# VolumeSlider

Volume Slider provide a subclass of `UIView`, used to create volumeSlider with bar representation.
It can be managed using `IBDesignable` and `IBInspectable` without writting any code.

![SliderImage](https://github.com/surjeet-singh/VolumeSlider/blob/master/ScreenShot/volumeSlider-animation.gif)

With single color 
`volumeSlider.barColor = UIColor.red`
![SliderImage](https://github.com/surjeet-singh/VolumeSlider/blob/master/ScreenShot/Screen%20Shot%2001.png)


If you need horizontal gradient color on slider, then use

`volumeSlider.barColors = [UIColor.red, UIColor.green]`

![SliderImage](https://github.com/surjeet-singh/VolumeSlider/blob/master/ScreenShot/Screen%20Shot%2002.png)

## Usage

## Swift


## Objective-C

```objec
VolumeSlider *volumeSlider = [[VolumeSlider alloc] initWithFrame:CGRectMake(10.f, 50.f, 300.f, 250.f)];
[volumeSlider setMaxValue:100];
[volumeSlider setBarWidth:10];
[volumeSlider setBarSpace:5];
[self.view addSubview:volumeSlider];
```


StepSlider can be fully customised by any of this properties:

- `defaultBarColor`
- `barColor`
- `barColors`

- `verticalPadding`
- `barWidth`
- `barSpace`
- `roundToPlaces`

- `maxValue`
- `currentValue`



## Requirements

- iOS 8.0+
- Swift 3.0+ / Objective-C
- Xcode 8

## Installation

### Manual Installation

Just copy `VolumeSlider` class to your project.
