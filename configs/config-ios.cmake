############################################################################
# config-ios.cmake
# Copyright (C) 2014  Belledonne Communications, Grenoble France
#
############################################################################
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
############################################################################

include(${CMAKE_CURRENT_LIST_DIR}/options-ios.cmake)


set(DEFAULT_VALUE_CMAKE_LINKING_TYPE "-DENABLE_STATIC=YES" "-DENABLE_SHARED=NO")


set(CMAKE_MACOSX_RPATH TRUE)
set(CMAKE_INSTALL_RPATH "@executable_path/../Frameworks")

# Global configuration
if(NOT LINPHONE_IOS_DEPLOYMENT_TARGET)
	set(LINPHONE_IOS_DEPLOYMENT_TARGET 8.0)
endif()
set(LINPHONE_BUILDER_HOST "${CMAKE_SYSTEM_PROCESSOR}-apple-darwin")
set(COMMON_FLAGS "-miphoneos-version-min=${LINPHONE_IOS_DEPLOYMENT_TARGET} -fms-extensions")
set(LINPHONE_BUILDER_CPPFLAGS "${COMMON_FLAGS}")
set(LINPHONE_BUILDER_LDFLAGS "${COMMON_FLAGS}")
set(LINPHONE_BUILDER_PKG_CONFIG_LIBDIR ${CMAKE_INSTALL_PREFIX}/lib/pkgconfig)	# Restrict pkg-config to search in the install directory
unset(COMMON_FLAGS)

message(STATUS "Xcode version: ${XCODE_VERSION}")

#Framework generation requires cmake 3.6 at least, otherwise it is completely broken.
set(CMAKE_MIN_VERSION "3.6.1")
if(${CMAKE_VERSION} VERSION_LESS ${CMAKE_MIN_VERSION})
	message(FATAL_ERROR "CMake with version greater than ${CMAKE_MIN_VERSION} is required but you are currently using ${CMAKE_VERSION}.")
endif()

set(LINPHONE_BUILDER_CXXFLAGS "${LINPHONE_BUILDER_CXXFLAGS} -stdlib=libc++")
set(LINPHONE_BUILDER_LDFLAGS "${LINPHONE_BUILDER_LDFLAGS} -stdlib=libc++")

# Include builders
include(builders/CMakeLists.txt)

# ffmpeg
lcb_builder_linking_type(ffmpeg "--enable-static" "--disable-shared" "--enable-pic")

# bctoolbox
lcb_builder_linking_type(bctoolbox "-DENABLE_STATIC=NO" "-DENABLE_SHARED=YES")

#belcard
lcb_builder_linking_type(belcard "-DENABLE_STATIC=NO" "-DENABLE_SHARED=YES")

#belcard
lcb_builder_linking_type(belr "-DENABLE_STATIC=NO" "-DENABLE_SHARED=YES")

# linphone
lcb_builder_cmake_options(linphone "-DENABLE_RELATIVE_PREFIX=YES")
lcb_builder_cmake_options(linphone "-DENABLE_CONSOLE_UI=NO")
lcb_builder_cmake_options(linphone "-DENABLE_DAEMON=NO")
lcb_builder_cmake_options(linphone "-DENABLE_NOTIFY=NO")
lcb_builder_cmake_options(linphone "-DENABLE_TUTORIALS=NO")
lcb_builder_cmake_options(linphone "-DENABLE_UPNP=NO")
lcb_builder_cmake_options(linphone "-DENABLE_MSG_STORAGE=YES")
lcb_builder_cmake_options(linphone "-DENABLE_DOC=NO")
lcb_builder_cmake_options(linphone "-DENABLE_NLS=NO")
lcb_builder_linking_type(linphone "-DENABLE_STATIC=NO" "-DENABLE_SHARED=YES")

# mbedtls
lcb_builder_linking_type(mbedtls "-DUSE_STATIC_MBEDTLS_LIBRARY=YES" "-DUSE_SHARED_MBEDTLS_LIBRARY=NO")

# mediastreamer2
lcb_builder_cmake_options(ms2 "-DENABLE_RELATIVE_PREFIX=YES")
lcb_builder_cmake_options(ms2 "-DENABLE_ALSA=NO")
lcb_builder_cmake_options(ms2 "-DENABLE_PULSEAUDIO=NO")
lcb_builder_cmake_options(ms2 "-DENABLE_OSS=NO")
lcb_builder_cmake_options(ms2 "-DENABLE_GLX=NO")
lcb_builder_cmake_options(ms2 "-DENABLE_X11=NO")
lcb_builder_cmake_options(ms2 "-DENABLE_XV=NO")
lcb_builder_cmake_options(ms2 "-DENABLE_DOC=NO")

lcb_builder_linking_type(ms2 "-DENABLE_STATIC=NO" "-DENABLE_SHARED=YES")
## ms2 plugins
lcb_builder_linking_type(mswebrtc "-DENABLE_STATIC=NO" "-DENABLE_SHARED=YES")
lcb_builder_linking_type(msamr "-DENABLE_STATIC=NO" "-DENABLE_SHARED=YES")
lcb_builder_linking_type(mscodec2 "-DENABLE_STATIC=NO" "-DENABLE_SHARED=YES")
lcb_builder_linking_type(msopenh264 "-DENABLE_STATIC=NO" "-DENABLE_SHARED=YES")
lcb_builder_linking_type(mssilk "-DENABLE_STATIC=NO" "-DENABLE_SHARED=YES")
lcb_builder_linking_type(msx264 "-DENABLE_STATIC=NO" "-DENABLE_SHARED=YES")

# opus
lcb_builder_cmake_options(opus "-DENABLE_FIXED_POINT=YES")

# ortp
lcb_builder_cmake_options(ortp "-DENABLE_DOC=NO")
lcb_builder_linking_type(ortp "-DENABLE_STATIC=NO" "-DENABLE_SHARED=YES")

# polarssl
lcb_builder_linking_type(polarssl "-DUSE_SHARED_POLARSSL_LIBRARY=0")

# soci
lcb_builder_linking_type(soci "-DSOCI_STATIC=YES" "-DSOCI_SHARED=NO")

# speex
lcb_builder_cmake_options(speex "-DENABLE_FLOAT_API=NO")
lcb_builder_cmake_options(speex "-DENABLE_FIXED_POINT=YES")

# vpx
lcb_builder_linking_type(vpx "--enable-static" "--disable-shared")

# x264
lcb_builder_linking_type(x264 "--enable-static" "--enable-pic")
lcb_builder_install_target(x264 "install-lib-static")

# zxing
lcb_builder_linking_type(zxing "-DENABLE_STATIC=YES" "-DENABLE_SHARED=NO")
