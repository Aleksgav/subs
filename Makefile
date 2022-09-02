all: check

check:
	cargo fmt --check
	cargo clippy --all-targets

test:
	cargo test

release: clean
	cargo build --release
	mkdir release
	cp target/release/subs release/subs

clean:
	rm -rf release
	cargo clean
