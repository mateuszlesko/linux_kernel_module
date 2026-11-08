obj-m += hello.o

KERNEL_HEADERS = $(shell uname -r)

all:
	make -C /lib/modules/$(KERNEL_HEADERS)/build M=$(PWD) modules

clean:
	make -C /lib/modules/$(KERNEL_HEADERS)/build M=$(PWD) clean