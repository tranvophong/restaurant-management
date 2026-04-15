enum DeviceType { mobile, tablet }

enum Orientation { portrait, landscape }

class Breakpoints {
  Breakpoints._();

  // Mobile-focused breakpoints
  static const double smallPhone  = 360;  // iPhone SE, Galaxy A series
  static const double normalPhone = 390;  // iPhone 14
  static const double largePhone  = 430;  // iPhone 14 Plus, Pro Max
  static const double tablet      = 600;

  static DeviceType getDeviceType(double width) =>
      width < tablet ? DeviceType.mobile : DeviceType.tablet;

  static bool isSmallPhone(double width)  => width < smallPhone;
  static bool isNormalPhone(double width) => width >= smallPhone && width < largePhone;
  static bool isLargePhone(double width)  => width >= largePhone && width < tablet;
}