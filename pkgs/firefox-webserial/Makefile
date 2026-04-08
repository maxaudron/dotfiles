# Makefile for firefox-webserial native component
# Designed for Nix build environment
# Nix should set CFLAGS and LDFLAGS with appropriate values

# Detect platform
UNAME_S := $(shell uname -s)
UNAME_M := $(shell uname -m)

# Output binary name
TARGET = firefox-webserial

# Compiler
CC = gcc

# Common source files
COMMON_SRCS = main.c printf.c serial.c stdmsg.c websocket.c uuid4.c

# Common libraries needed for all platforms
LIBS = -lcjson -lserialport -lws

# Platform-specific source files and flags
ifeq ($(UNAME_S),Linux)
    PLATFORM_SRCS = serial_linux.c
    PLATFORM_CFLAGS = -Dprintf=__wrap_printf
    PLATFORM_LDFLAGS = -lpthread
endif

ifeq ($(UNAME_S),Darwin)
    PLATFORM_SRCS = serial_macos.c
    PLATFORM_CFLAGS = -Dprintf=__wrap_printf -DLIBSERIALPORT_ATBUILD
    PLATFORM_LDFLAGS = -lpthread -framework IOKit -framework CoreFoundation
    ifeq ($(UNAME_M),x86_64)
        PLATFORM_LDFLAGS += -arch x86_64
    endif
endif

ifeq ($(UNAME_S),Windows_NT)
    PLATFORM_SRCS = serial_win.c
    PLATFORM_CFLAGS = -D_WIN32_WINNT=0x0601
    PLATFORM_LDFLAGS = -lpthread -lsetupapi -lws2_32 -Wl,-wrap,__mingw_vprintf
endif

ifneq (,$(findstring MINGW,$(UNAME_S)))
    PLATFORM_SRCS = serial_win.c
    PLATFORM_CFLAGS = -D_WIN32_WINNT=0x0601
    PLATFORM_LDFLAGS = -lpthread -lsetupapi -lws2_32 -Wl,-wrap,__mingw_vprintf
endif

ifneq (,$(findstring MSYS,$(UNAME_S)))
    PLATFORM_SRCS = serial_win.c
    PLATFORM_CFLAGS = -D_WIN32_WINNT=0x0601
    PLATFORM_LDFLAGS = -lpthread -lsetupapi -lws2_32 -Wl,-wrap,__mingw_vprintf
endif

# All source files
SRCS = $(COMMON_SRCS) $(PLATFORM_SRCS)
OBJS = $(SRCS:.c=.o)

# Add platform-specific flags to the base flags (Nix will populate CFLAGS/LDFLAGS)
CFLAGS += -Wall -Wextra $(PLATFORM_CFLAGS) $(EXTRA_INCLUDES)
LDFLAGS += $(PLATFORM_LDFLAGS)

# Default target
all: $(TARGET)

# Link the final binary
$(TARGET): $(OBJS)
	$(CC) $(LDFLAGS) $(OBJS) -o $(TARGET) $(LIBS) $(PLATFORM_LDFLAGS)

# Compile source files
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# Installation directories
PREFIX ?= /usr
DESTDIR ?=
BIN_DIR = $(DESTDIR)$(PREFIX)/bin
LIB_DIR = $(DESTDIR)$(PREFIX)/lib
APP_ID = io.github.kuba2k2.webserial

# Install command
INSTALL = install

# Clean build artifacts
clean:
	rm -f $(OBJS) $(TARGET)

# Install target
install: $(TARGET)
	$(INSTALL) -Dm755 $(TARGET) "$(BIN_DIR)/$(TARGET)"
	$(INSTALL) -Dm644 /dev/stdin "$(LIB_DIR)/mozilla/native-messaging-hosts/$(APP_ID).json" <<< '{ "name": "$(APP_ID)", "description": "WebSerial for Firefox", "path": "$(BIN_DIR)/$(TARGET)", "type": "stdio", "allowed_extensions": ["webserial@kuba2k2.github.io"] }'

.PHONY: all clean install install-user
