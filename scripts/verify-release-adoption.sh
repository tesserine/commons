#!/usr/bin/env bash
set -euo pipefail

workspace_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
source "$workspace_root/scripts/release-check"

scratch="$(mktemp -d)"
trap 'rm -rf "$scratch"' EXIT

seed_release_repo() {
    local source_repo="$1"
    local remote_repo="$2"

    mkdir "$source_repo"
    tar \
        --exclude=.git \
        --exclude=.cache \
        -C "$workspace_root" \
        -cf - . \
        | tar -C "$source_repo" -xf -

    git -C "$source_repo" init -q
    git -C "$source_repo" config user.name "commons release verification"
    git -C "$source_repo" config user.email "commons-release-verification@example.invalid"
    git -C "$source_repo" checkout -q -b main
    git -C "$source_repo" add .
    git -C "$source_repo" commit -q -m "test: seed release verification"

    git init --bare -q "$remote_repo"
    git -C "$source_repo" remote add origin "$remote_repo"
    git -C "$source_repo" push -q -u origin main
}

assert_release_state() {
    local source_repo="$1"
    local remote_repo="$2"
    local tag="$3"
    local version="${tag#v}"

    if [[ "$(git -C "$source_repo" cat-file -t "$tag")" != "tag" ]]; then
        printf '%s is not an annotated tag\n' "$tag" >&2
        exit 1
    fi

    local release_commit tag_commit
    release_commit="$(git -C "$source_repo" rev-parse HEAD)"
    tag_commit="$(git -C "$source_repo" rev-list -n 1 "$tag")"
    if [[ "$release_commit" != "$tag_commit" ]]; then
        printf '%s does not point at the release commit\n' "$tag" >&2
        exit 1
    fi

    if ! grep -Fq "## [$version] — $(date +%F)" "$source_repo/CHANGELOG.md"; then
        printf 'CHANGELOG.md was not rolled to [%s] with today'\''s date\n' "$version" >&2
        exit 1
    fi

    if ! git --git-dir="$remote_repo" rev-parse --verify --quiet refs/heads/main >/dev/null; then
        printf 'release branch was not pushed\n' >&2
        exit 1
    fi

    if ! git --git-dir="$remote_repo" rev-parse --verify --quiet "refs/tags/$tag" >/dev/null; then
        printf '%s was not pushed\n' "$tag" >&2
        exit 1
    fi

    if [[ -n "$(git -C "$source_repo" status --short)" ]]; then
        printf 'release-cut left a dirty working tree\n' >&2
        exit 1
    fi
}

verify_fresh_checkout() {
    local remote_repo="$1"
    local tag="$2"
    local checkout="$scratch/fresh-${tag//[^A-Za-z0-9]/-}"

    git clone -q "$remote_repo" "$checkout"
    git -C "$checkout" checkout -q "$tag"
    (
        cd "$checkout"
        python3 -m venv .venv
        . .venv/bin/activate
        python3 -m pip install -q -r requirements.txt
        ./scripts/release-check release "$tag"
    )
}

assert_atomic_push_failure_does_not_create_tag() {
    local source_repo="$1"
    local remote_repo="$2"
    local remote_main_before
    remote_main_before="$(git --git-dir="$remote_repo" rev-parse refs/heads/main)"

    cat >"$remote_repo/hooks/pre-receive" <<'EOF'
#!/usr/bin/env sh
while read old new ref; do
    if [ "$ref" = "refs/tags/v9.9.9" ]; then
        echo "rejecting test tag" >&2
        exit 1
    fi
done
exit 0
EOF
    chmod +x "$remote_repo/hooks/pre-receive"

    set +e
    output="$(cd "$source_repo" && ./scripts/release-cut v9.9.9 2>&1)"
    status=$?
    set -e

    if [[ "$status" -eq 0 ]]; then
        printf 'release-cut unexpectedly succeeded when remote tag already existed\n' >&2
        exit 1
    fi

    if [[ "$output" != *"atomic push failed"* ]]; then
        printf 'release-cut failure did not identify atomic push failure\n%s\n' "$output" >&2
        exit 1
    fi

    if git --git-dir="$remote_repo" rev-parse --verify --quiet refs/tags/v9.9.9 >/dev/null; then
        printf 'atomic push failure still created remote tag v9.9.9\n' >&2
        exit 1
    fi

    if [[ "$(git --git-dir="$remote_repo" rev-parse refs/heads/main)" != "$remote_main_before" ]]; then
        printf 'atomic push failure still advanced remote main\n' >&2
        exit 1
    fi
}

stable_source="$scratch/stable-source"
stable_remote="$scratch/stable-origin.git"
seed_release_repo "$stable_source" "$stable_remote"
(
    cd "$stable_source"
    python3 -m venv .venv
    . .venv/bin/activate
    python3 -m pip install -q -r requirements.txt
    ./scripts/release-cut v1.2.3
)
assert_release_state "$stable_source" "$stable_remote" v1.2.3
verify_fresh_checkout "$stable_remote" v1.2.3
printf 'verified stable release adoption for v1.2.3\n'

rc_source="$scratch/rc-source"
rc_remote="$scratch/rc-origin.git"
seed_release_repo "$rc_source" "$rc_remote"
(
    cd "$rc_source"
    python3 -m venv .venv
    . .venv/bin/activate
    python3 -m pip install -q -r requirements.txt
    ./scripts/release-cut v1.2.3-rc.1
)
assert_release_state "$rc_source" "$rc_remote" v1.2.3-rc.1
verify_fresh_checkout "$rc_remote" v1.2.3-rc.1
printf 'verified RC release adoption for v1.2.3-rc.1\n'

failure_source="$scratch/failure-source"
failure_remote="$scratch/failure-origin.git"
seed_release_repo "$failure_source" "$failure_remote"
assert_atomic_push_failure_does_not_create_tag "$failure_source" "$failure_remote"
printf 'verified atomic push failure handling\n'
