all: check

check:
	cargo fmt --check
	cargo clippy --all-targets -- -D warnings
	cargo audit

test:
	cargo test

cov:
	cargo tarpaulin --ignore-tests

release: clean
	cargo build --release
	mkdir release
	cp target/release/subs release/subs

clean:
	rm -rf release
	cargo clean

watch:
	cargo watch -x check
