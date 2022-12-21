all: check

check: fmt clippy audit deny

fmt:
	cargo fmt -- --check

clippy:
	cargo clippy --all-targets -- -D warnings

audit:
	cargo audit

deny:
	cargo deny check advisories bans

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

expand:
	cargo +nightly expand

migrate:
	SKIP_DOCKER=true ./scripts/init_db.sh
