cmake_minimum_required(VERSION 3.0)

project(livox_sdk2)

set(CMAKE_CXX_STANDARD 11)
add_compile_options(-Wall -Wextra -Werror)
add_compile_options(-Wno-unused-variable)
add_compile_options(
	-Wno-unknown-warning-option
	-Wno-deprecated-declarations
	-Wno-unused-private-field
	-Wno-delete-non-abstract-non-virtual-dtor
	-Wno-non-c-typedef-for-linkage
	-Wno-unused-const-variable
	-Wno-unused-parameter
	-Wno-ignored-qualifiers
)
string(REPLACE "-Werror" "" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")

message(STATUS "main project dir: " ${PROJECT_SOURCE_DIR})

if (CMAKE_CROSSCOMPILING)
	set(THREADS_PTHREAD_ARG
		"PLEASE_FILL_OUT-FAILED_TO_RUN"
		CACHE STRING "Result from TRY_RUN" FORCE)
endif()

if (UNIX)
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pthread")
endif(UNIX)

add_subdirectory(livox_lidar_quick_start)
# add_subdirectory(multi_lidars_upgrade)
# add_subdirectory(logger)
# add_subdirectory(debug_point_cloud)
# add_subdirectory(lidar_cmd_observer)
# add_subdirectory(livox_lidar_rmc_time_sync)
