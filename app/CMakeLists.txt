project(temp_exe LANGUAGES CXX)

message(STATUS "")
message(STATUS "------- ${PROJECT_NAME} -------")# 使用git describe命令获取更新次数
execute_process(
    COMMAND git describe --tags --abbrev=0
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    OUTPUT_VARIABLE LATEST_TAG
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

if(NOT LATEST_TAG)
    message(WARNING "Failed to get latest tag.")
else()
    # 使用git describe命令获取距离最近标签的更新次数
    execute_process(
        COMMAND git rev-list ${LATEST_TAG}..HEAD --count
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        OUTPUT_VARIABLE UPDATE_COUNT
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    set(VERSION_EXTRA ${UPDATE_COUNT})
endif()

message(STATUS "DEV VERSION: ${PROJECT_VERSION}")
message(STATUS "GIT VERSION: ${PROJECT_GIT_VERSION}")
message(STATUS "TAG VERSION: ${PROJECT_TAG_VERSION}")
message(STATUS "BINARY_NAME: ${PROJECT_NAME}-${PROJECT_VERSION}")

#版本14以下可能会导致abseil不支持
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)


#包含的源文件和头文件
include_directories(${PROJECT_NAME} ${CMAKE_CURRENT_LIST_DIR}/include)
include_directories(${PROJECT_NAME} ${CMAKE_CURRENT_LIST_DIR}/src)

set(MAIN_SOURCES
    include/temp.h
    src/temp.cpp
    src/main.cpp
)
#生成的可执行文件名称和包含的文件
add_executable(${PROJECT_NAME}  ${MAIN_SOURCES})

#基于工程目录下的配置文件 生成 执行目录下的配置文件
configure_file(${CMAKE_SOURCE_DIR}/.cmake/config.yml.in ${CMAKE_SOURCE_DIR}/bin/conf/config.yml @ONLY)
target_include_directories(${PROJECT_NAME}  PRIVATE ${CMAKE_SOURCE_DIR}) #添加 Version.h的引用

target_link_libraries(${PROJECT_NAME} temp)

#设置可执行文件生成目录
set_target_properties(${PROJECT_NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/bin")
message(STATUS "BINARY_DIR : ${CMAKE_SOURCE_DIR}/bin")







