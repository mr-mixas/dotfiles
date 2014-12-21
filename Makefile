all:

install:
	set -x; for file in .*; do \
        [ -f "$${file}" ] && \
        git blame "$${file}" >/dev/null 2>&1 && \
        install -m 0644 "$${file}" ~/ ; \
    done
