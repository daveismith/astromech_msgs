cmake_minimum_required(VERSION 3.8)
project(astromech_msgs)

find_package(ament_cmake REQUIRED)
find_package(rosidl_default_generators REQUIRED)
find_package(std_msgs REQUIRED)
find_package(builtin_interfaces REQUIRED)

rosidl_generate_interfaces(${PROJECT_NAME}
  "msg/ServoDescriptor.msg"
  "msg/ServoState.msg"
  "msg/ServoStateArray.msg"
  "msg/LedDisplay.msg"
  "msg/LedSurface.msg"
  "msg/LedClip.msg"
  "msg/LedDisplayState.msg"
  "msg/LedSurfaceState.msg"
  "msg/LedStateArray.msg"
  "msg/DomeButtonSequence.msg"
  "msg/DomeButtonState.msg"
  "srv/ListServos.srv"
  "srv/ConfigureServo.srv"
  "srv/MoveServoRaw.srv"
  "srv/ListLeds.srv"
  "srv/RunLedEffect.srv"
  "srv/SayLedText.srv"
  "srv/StopLedEffect.srv"
  "srv/ConfigureLedDisplay.srv"
  DEPENDENCIES std_msgs builtin_interfaces
)

ament_export_dependencies(rosidl_default_runtime)
ament_package()
