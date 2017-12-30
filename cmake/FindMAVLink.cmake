# - Try to find  MAVLink
# Once done, this will define
#
#  MAVLINK_FOUND        : library found
#  MAVLINK_INCLUDE_DIRS : include directories
#  MAVLINK_VERSION      : version

# macros
include(FindPackageHandleStandardArgs)

# Check for ROS_DISTRO
find_program(ROSVERSION rosversion)
execute_process(COMMAND ${ROSVERSION} -d
    OUTPUT_VARIABLE ROS_DISTRO
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

set(_MAVLINK_EXTRA_SEARCH_PATHS
    ../mavlink/include/
    ../../devel/include/
    ../../build/mavlink/include/
    ../../mavlink/include/
    /usr/include/
    /usr/local/include/
    /opt/ros/${ROS_DISTRO}/include/
    )

# find the include directory
find_path(_MAVLINK_INCLUDE_DIR
    NAMES mavlink/v1.0/mavlink_types.h mavlink/v2.0/mavlink_types.h
    PATHS ${_MAVLINK_EXTRA_SEARCH_PATHS}
    PATH_SUFFIXES include
    )

# read the version
if (EXISTS ${_MAVLINK_INCLUDE_DIR}/mavlink/config.h)
    file(READ ${_MAVLINK_INCLUDE_DIR}/mavlink/config.h MAVLINK_CONFIG_FILE)
    string(REGEX MATCH "#define MAVLINK_VERSION[ ]+\"(([0-9]+\\.)+[0-9]+)\""
        _MAVLINK_VERSION_MATCH "${MAVLINK_CONFIG_FILE}")
    set(MAVLINK_VERSION "${CMAKE_MATCH_1}")
else()
    set(MAVLINK_VERSION "2.0")
endif()

# handle arguments
set(MAVLINK_INCLUDE_DIRS ${_MAVLINK_INCLUDE_DIR})
find_package_handle_standard_args(
    MAVLink
    REQUIRED_VARS MAVLINK_INCLUDE_DIRS MAVLINK_VERSION
    VERSION_VAR MAVLINK_VERSION
    )
