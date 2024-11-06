ifdef ARM_GCC_TOOLCHAIN
  CC := $(ARM_GCC_TOOLCHAIN)
else
  CC := gcc
endif  
#
# For out of kernel tree rules
#
all:
	$(CC) -o devbuf_map devbuf_map.c

clean:
	rm -f devbuf_map