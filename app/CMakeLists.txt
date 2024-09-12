project(temp_exe LANGUAGES CXX)



# 使用git describe命令获取更新次数
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


# 设置项目的版本号
set(PROJECT_VERSION "${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH}.${VERSION_EXTRA}")

message(STATUS "")
message(STATUS "------- ${PROJECT_NAME} -------")

message(STATUS "DEV VERSION: ${PROJECT_VERSION}")
message(STATUS "GIT VERSION: ${PROJECT_GIT_VERSION}")
message(STATUS "TAG VERSION: ${PROJECT_TAG_VERSION}")
message(STATUS "BINARY_NAME: ${PROJECT_NAME}-${PROJECT_VERSION}")

#版本14以下可能会导致abseil不支持
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)


#包含的源文件和头文件
include_directories(${PROJECT_NAME} ${CMAKE_CURRENT_LIST_DIR}/include)
# include_directories(${PROJECT_NAME} ${CMAKE_CURRENT_LIST_DIR}/include/Carrier)
# include_directories(${PROJECT_NAME} ${CMAKE_CURRENT_LIST_DIR}/include/Compontent)
# include_directories(${PROJECT_NAME} ${CMAKE_CURRENT_LIST_DIR}/include/Connector)
# include_directories(${PROJECT_NAME} ${CMAKE_CURRENT_LIST_DIR}/include/DB)
# include_directories(${PROJECT_NAME} ${CMAKE_CURRENT_LIST_DIR}/include/Extra)

include_directories(${PROJECT_NAME} ${CMAKE_CURRENT_LIST_DIR}/src)

#  set(DB_TABLE_SOURCE
#     include/DB/relay_account_tb.h
#     src/DB/relay_account_tb.cpp
# )
# set(COMPONTENT_TYPE_SOURCE
#     include/Compontent/process_queue.h
#     src/Compontent/process_queue.cpp
# )

# set(CARRIER_TYPE_SOURCE
#     include/Carrier/client_ntrip.h
#     include/Carrier/server_ntrip.h
#     # include/Carrier/server_relay.h
#     src/Carrier/client_ntrip.cpp
#     src/Carrier/server_ntrip.cpp
#     # src/Carrier/server_relay.cpp
#     include/Carrier/source_ntrip.h
#     src/Carrier/source_ntrip.cpp
# )

# set(CONNECTOR_TYPE_SOURCE
#     include/Connector/ntrip_compat_listener.h
#     include/Connector/ntrip_relay_connector.h
#     src/Connector/ntrip_compat_listener.cpp
#     src/Connector/ntrip_relay_connector.cpp
# )

# set(EXTRA_SOURCE
#     # include/Extra/heart_beat.h
#     # src/Extra/heart_beat.cpp
#     include/Extra/license_check.h
#     src/Extra/license_check.cpp
#     src/Extra/license_check.cpp
#     src/Extra/register.h
#     src/Extra/register.cpp
# )

set(MAIN_SOURCES
    include/temp.h
    src/temp.cpp
    src/main.cpp
)

add_executable(${PROJECT_NAME} 
                ${MAIN_SOURCES} 
                # ${CARRIER_TYPE_SOURCE}  
                # ${CONNECTOR_TYPE_SOURCE}
                # ${COMPONTENT_TYPE_SOURCE}    
                # ${DB_TABLE_SOURCE} 
                # ${EXTRA_SOURCE}
                # ${VERSION_SOURCES}
                )

#生成的可执行文件名称和包含的文件

#基于version.h.in 生成 version.h
configure_file(${CMAKE_SOURCE_DIR}/.cmake/version.h.in version.h @ONLY)
target_include_directories(${PROJECT_NAME}  PRIVATE ${CMAKE_CURRENT_BINARY_DIR})

#基于工程目录下的配置文件 生成 执行目录下的配置文件
set_target_properties(${PROJECT_NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/bin")
configure_file(${CMAKE_SOURCE_DIR}/.cmake/config.yml.in ${CMAKE_SOURCE_DIR}/bin/conf/config.yml @ONLY)
# configure_file(${CMAKE_SOURCE_DIR}/.cmake/Caster_Core.yml.in ${CMAKE_SOURCE_DIR}/bin/conf/Caster_Core.yml @ONLY)
# configure_file(${CMAKE_SOURCE_DIR}/.cmake/Service_Setting.yml.in ${CMAKE_SOURCE_DIR}/bin/conf/Service_Setting.yml @ONLY)
# configure_file(${CMAKE_SOURCE_DIR}/.cmake/redis.conf.in ${CMAKE_SOURCE_DIR}/bin/env/redis.conf @ONLY)

message(STATUS "BINARY_DIR : ${CMAKE_SOURCE_DIR}/bin")


target_link_libraries(${PROJECT_NAME} temp)

# #Koro_NavTool
# target_link_libraries(${PROJECT_NAME} knt)
# #caster_core
# target_link_libraries(${PROJECT_NAME} castercore)
# #auth_verify
# target_link_libraries(${PROJECT_NAME} authverify)

# #libevent 
# target_link_libraries(${PROJECT_NAME} event)
# target_link_libraries(${PROJECT_NAME} event_core)
# target_link_libraries(${PROJECT_NAME} event_extra)

# #nlohmann/json
# include_directories(${PROJECT_NAME} ${JSON_INCLUDE_PATH})
# #spdlog
# # target_link_libraries(${PROJECT_NAME} spdlog)
# include_directories(${PROJECT_NAME} ${SPDLOG_INCLUDE_PATH})
# #yaml
# target_link_libraries(${PROJECT_NAME} yaml-cpp)