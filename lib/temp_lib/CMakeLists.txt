cmake_minimum_required(VERSION 3.5)

project(temp LANGUAGES CXX)

#版本14以下可能会导致abseil不支持
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# add_subdirectory(third/)

include_directories(${PROJECT_NAME} ${CMAKE_CURRENT_LIST_DIR}/include)

#包含的源文件和头文件
set(SOURCES
    include/lib_temp.h
    src/lib_temp.cpp)
    
add_library(${PROJECT_NAME} STATIC ${SOURCES})

target_include_directories(${PROJECT_NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include) 
#将库的接口也一并添加，这样程序引用该库的时候就不需要在inlcude路径了，可以直接target_link
