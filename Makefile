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
	# you must be install bunyan before
	# cargo install bunyan
	TEST_LOG=true cargo test health_check_works | bunyan

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

udeps:
	cargo +nightly udeps

migrate:
	SKIP_DOCKER=true ./scripts/init_db.sh

sqlx_prepare:
	cargo sqlx prepare -- --lib

docker_build:
	docker build --tag subs --file Dockerfile .

docker_run:
	docker run -p 8000:8000 subs
