SHELL = /bin/bash
LINK_FLAGS = --link-flags "-static" -D without_openssl
SRCS = ${wildcard src/bin/*.cr}
PROGS = $(SRCS:src/bin/%.cr=%)

.PHONY : all static compile spec clean bin test
.PHONY : ${PROGS}

all: static

test: spec compile static examples version

static: bin ${PROGS}

bin:
	@mkdir -p bin

rcm: src/bin/rcm.cr
	crystal build --release $^ -o bin/$@ ${LINK_FLAGS}

spec:
	crystal spec -v

compile:
	@for x in src/bin/*.cr ; do\
	  crystal build "$$x" -o /dev/null ;\
	done

clean:
	@rm -rf bin

.PHONY : examples
examples:
	@for x in examples/*.cr ; do\
	  crystal build "$$x" -o /dev/null ;\
	done

version:
	./bin/rcm --version
