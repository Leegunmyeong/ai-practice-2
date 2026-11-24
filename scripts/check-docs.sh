#!/bin/bash
# 에이전트 문서 규격 검사. 로컬 또는 CI 에서 실행: bash scripts/check-docs.sh
fail=0
err() { echo "❌ $1"; fail=1; }

lines=$(wc -l < CLAUDE.md)
[ "$lines" -gt 10 ] && err "CLAUDE.md ${lines}줄 (상한 10). 늘리기 전에 팀과 상의"
grep -q '^@' CLAUDE.md && err "CLAUDE.md 에 @import 금지 (매 세션 통째로 로드됨). 경로만 적을 것"

for f in .claude/skills/*/SKILL.md .claude/agents/*.md; do
  grep -q '^name:' "$f" || err "$f: name 없음"
  grep -q '^description:' "$f" || err "$f: description 없음"
done

for f in .claude/skills/*/SKILL.md; do
  for ref in $(grep -o '^@[^ ]*' "$f" | tr -d '@'); do
    [ -f "$ref" ] || err "$f: 깨진 참조 $ref"
  done
done

for d in docs/*/; do
  [ -f "${d}README.md" ] || err "${d}README.md 없음 (폴더 규칙 필수)"
done

[ $fail -eq 0 ] && echo "✅ 문서 규격 통과"
exit $fail
