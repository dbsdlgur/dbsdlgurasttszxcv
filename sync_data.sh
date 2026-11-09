#!/usr/bin/env bash
# data 브랜치에 데이터 파일만 커밋 1개로 덮어쓰기(히스토리 없음) / 받아오기
# 사용법: ./sync_data.sh push | pull
set -euo pipefail

REMOTE="${REMOTE:-origin}"
BRANCH="${BRANCH:-data}"
FILES=(data.enc.json template.enc.json)

cd "$(git rev-parse --show-toplevel)"

push() {
  # 원격 data 브랜치의 현재 커밋 (없으면 빈 값)
  git fetch "$REMOTE" "$BRANCH" 2>/dev/null || true
  local remote_sha
  remote_sha="$(git rev-parse -q --verify "refs/remotes/$REMOTE/$BRANCH" || true)"

  # 작업 트리/현재 브랜치를 건드리지 않도록 임시 인덱스로 트리 생성
  local idx
  idx="$(mktemp -u)"
  trap 'rm -f "$idx"' EXIT
  for f in "${FILES[@]}"; do
    [ -f "$f" ] || { echo "missing: $f" >&2; exit 1; }
    GIT_INDEX_FILE="$idx" git update-index --add --cacheinfo \
      "100644,$(git hash-object -w "$f"),$f"
  done
  local tree commit
  tree="$(GIT_INDEX_FILE="$idx" git write-tree)"

  # 변경 없으면 종료
  if [ -n "$remote_sha" ] && [ "$(git rev-parse "$remote_sha^{tree}")" = "$tree" ]; then
    echo "no changes"
    return
  fi

  # 부모 없는 단일 커밋
  commit="$(git commit-tree "$tree" -m "data")"

  # 그 사이 다른 곳에서 push했다면 덮어쓰지 않고 실패
  git push \
    --force-with-lease="refs/heads/$BRANCH:$remote_sha" \
    "$REMOTE" "$commit:refs/heads/$BRANCH"
  echo "pushed $commit"
}

pull() {
  git fetch "$REMOTE" "$BRANCH"
  for f in "${FILES[@]}"; do
    git show "refs/remotes/$REMOTE/$BRANCH:$f" > "$f"
  done
  echo "pulled latest data"
}

case "${1:-}" in
  push) push ;;
  pull) pull ;;
  *) echo "usage: $0 push|pull" >&2; exit 1 ;;
esac
