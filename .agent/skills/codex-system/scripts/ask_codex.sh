#!/usr/bin/env bash
# Codex CLI consultation script (macOS)
# Usage:
#   bash ./ask_codex.sh --mode analyze --question "Your question" [--context "optional"]

set -euo pipefail

TASK_TYPE="${TASK_TYPE:-}"
QUESTION="${QUESTION:-}"
CONTEXT="${CONTEXT:-}"
CODEX_MODE="${CODEX_MODE:-ad-hoc}"
OUTPUT_SCHEMA="${OUTPUT_SCHEMA:-}"
MODEL_OVERRIDE=""
EFFORT_OVERRIDE=""
HIGH_RISK=false

usage() {
  cat <<'USAGE'
Usage:
  bash ./ask_codex.sh --mode <analyze|design|debug|review> --question "<text>" [options]

Options:
  -m, --mode               Task type (alias of --task-type)
      --task-type          Task type (required)
  -q, --question           Main question for Codex (required)
  -c, --context            Additional context text (optional)
      --codex-mode         Pipeline mode: plan-review|implementation-review|ad-hoc
      --model              Override model name (default: gpt-5.3-codex)
      --reasoning-effort   Override reasoning effort: low|medium|high|xhigh
      --high-risk          Use high-risk effort preset (default: xhigh)
      --output-schema      JSON schema file path for final output shape
  -h, --help               Show this help
USAGE
}

redact_sensitive_text() {
  sed -E \
    -e 's/sk-[A-Za-z0-9_-]{16,}/[REDACTED_OPENAI_KEY]/g' \
    -e 's/(api[_-]?key[[:space:]]*[:=][[:space:]]*)[^[:space:]]+/\1[REDACTED]/Ig' \
    -e 's/(authorization[[:space:]]*:[[:space:]]*bearer[[:space:]]+)[A-Za-z0-9._-]+/\1[REDACTED]/Ig' \
    -e 's#(postgres(ql)?://)[^[:space:]]+#\1[REDACTED]#Ig'
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -m|--mode|--task-type)
      TASK_TYPE="${2:-}"
      shift 2
      ;;
    -q|--question)
      QUESTION="${2:-}"
      shift 2
      ;;
    -c|--context)
      CONTEXT="${2:-}"
      shift 2
      ;;
    --codex-mode)
      CODEX_MODE="${2:-}"
      shift 2
      ;;
    --model)
      MODEL_OVERRIDE="${2:-}"
      shift 2
      ;;
    --reasoning-effort)
      EFFORT_OVERRIDE="${2:-}"
      shift 2
      ;;
    --high-risk)
      HIGH_RISK=true
      shift
      ;;
    --output-schema)
      OUTPUT_SCHEMA="${2:-}"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      exit 1
      ;;
  esac
done

if [[ -z "$TASK_TYPE" || -z "$QUESTION" ]]; then
  echo "Both --task-type/--mode and --question are required." >&2
  usage
  exit 1
fi

case "$TASK_TYPE" in
  analyze|design|debug|review) ;;
  *)
    echo "Invalid task type: $TASK_TYPE" >&2
    usage
    exit 1
    ;;
esac

case "$CODEX_MODE" in
  plan-review|implementation-review|ad-hoc) ;;
  *)
    echo "Invalid --codex-mode: $CODEX_MODE" >&2
    usage
    exit 1
    ;;
esac

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd -- "$SCRIPT_DIR/../../../.." && pwd)"
VALIDATE_REPORT_SCRIPT="$SCRIPT_DIR/validate_report.sh"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
OUTPUT_DIR="$PROJECT_ROOT/logs/codex-responses"
OUTPUT_BASENAME="$CODEX_MODE-$TASK_TYPE-$TIMESTAMP"
OUTPUT_FILE="$OUTPUT_DIR/$OUTPUT_BASENAME.md"
STDERR_FILE="$OUTPUT_DIR/$OUTPUT_BASENAME.stderr.log"

NODE_PATH="${NODE_PATH:-$(command -v node || true)}"
CODEX_PATH="${CODEX_PATH:-$(command -v codex || true)}"
CODEX_MODEL="${CODEX_MODEL:-gpt-5.3-codex}"
CODEX_REASONING_EFFORT="${CODEX_REASONING_EFFORT:-high}"
CODEX_HIGH_RISK_REASONING_EFFORT="${CODEX_HIGH_RISK_REASONING_EFFORT:-xhigh}"

if [[ -z "$NODE_PATH" ]]; then
  NODE_PATH="/opt/homebrew/bin/node"
fi
if [[ -z "$CODEX_PATH" ]]; then
  CODEX_PATH="/opt/homebrew/bin/codex"
fi

if [[ ! -x "$CODEX_PATH" ]]; then
  echo "Codex CLI not found at: $CODEX_PATH" >&2
  echo "Update CODEX_PATH or install Codex CLI." >&2
  exit 1
fi

EFFECTIVE_MODEL="$CODEX_MODEL"
if [[ -n "$MODEL_OVERRIDE" ]]; then
  EFFECTIVE_MODEL="$MODEL_OVERRIDE"
fi

if [[ -n "$EFFORT_OVERRIDE" ]]; then
  EFFECTIVE_EFFORT="$EFFORT_OVERRIDE"
elif [[ "$HIGH_RISK" == true ]]; then
  EFFECTIVE_EFFORT="$CODEX_HIGH_RISK_REASONING_EFFORT"
else
  EFFECTIVE_EFFORT="$CODEX_REASONING_EFFORT"
fi

case "$EFFECTIVE_EFFORT" in
  low|medium|high|xhigh) ;;
  *)
    echo "Invalid reasoning effort: $EFFECTIVE_EFFORT" >&2
    exit 1
    ;;
esac

mkdir -p "$OUTPUT_DIR"
export PATH="$(dirname "$NODE_PATH"):$(dirname "$CODEX_PATH"):$PATH"

SOURCE_COMMIT="$(git -C "$PROJECT_ROOT" rev-parse --short HEAD 2>/dev/null || echo unknown)"
if git -C "$PROJECT_ROOT" diff --quiet && git -C "$PROJECT_ROOT" diff --cached --quiet; then
  WORKTREE_STATE="clean"
else
  WORKTREE_STATE="dirty"
fi

MANIFEST_FILE="$PROJECT_ROOT/docs/for-codex/manifest.md"
read_manifest_value() {
  local key="$1"
  sed -n "s/^${key}:[[:space:]]*//p" "$MANIFEST_FILE" | head -n 1
}

if [[ "$CODEX_MODE" != "ad-hoc" ]]; then
  if [[ ! -f "$MANIFEST_FILE" ]]; then
    echo "Missing for-codex manifest: $MANIFEST_FILE" >&2
    echo "Run prepare-codex-context before $CODEX_MODE." >&2
    exit 1
  fi

  required_keys=(
    task_id
    generated_at
    source_commit
    read_order
    coverage
    known_gaps
    persona_name
    humor_level
    learner_mode
    report_path
    requirements_questions_asked
    requirements_confirmed
    conversation_language
    ui_language
    readme_language
  )

  for key in "${required_keys[@]}"; do
    if ! grep -Eq "^${key}:" "$MANIFEST_FILE"; then
      echo "Manifest missing required key: $key" >&2
      echo "Run prepare-codex-context and regenerate docs/for-codex/manifest.md." >&2
      exit 1
    fi
  done

  require_non_tbd() {
    local key="$1"
    local value
    value="$(read_manifest_value "$key")"
    if [[ -z "$value" || "$value" == "TBD" ]]; then
      echo "Manifest key '$key' must be populated before $CODEX_MODE." >&2
      exit 1
    fi
  }

  for key in task_id generated_at source_commit coverage known_gaps; do
    require_non_tbd "$key"
  done

  REQUIREMENTS_QUESTION_COUNT="$(read_manifest_value requirements_questions_asked)"
  if ! [[ "$REQUIREMENTS_QUESTION_COUNT" =~ ^[0-9]+$ ]]; then
    echo "Manifest key 'requirements_questions_asked' must be an integer." >&2
    exit 1
  fi
  if (( REQUIREMENTS_QUESTION_COUNT < 3 )); then
    echo "At least 3 requirement deep-dive questions are required before $CODEX_MODE." >&2
    exit 1
  fi

  REQUIREMENTS_CONFIRMED="$(read_manifest_value requirements_confirmed | tr '[:upper:]' '[:lower:]')"
  if [[ "$REQUIREMENTS_CONFIRMED" != "yes" ]]; then
    echo "Manifest key 'requirements_confirmed' must be 'yes' before $CODEX_MODE." >&2
    exit 1
  fi

  KNOWN_GAPS_VALUE="$(read_manifest_value known_gaps | tr '[:upper:]' '[:lower:]')"
  if [[ -n "$KNOWN_GAPS_VALUE" && "$KNOWN_GAPS_VALUE" != "none" && "$KNOWN_GAPS_VALUE" != "tbd" ]] && (( REQUIREMENTS_QUESTION_COUNT < 4 )); then
    echo "Warning: known_gaps is not none. Consider asking 4+ requirement questions for safer planning." >&2
  fi

  for lang_key in conversation_language ui_language readme_language; do
    LANG_VALUE="$(read_manifest_value "$lang_key" | tr '[:upper:]' '[:lower:]')"
    if [[ -z "$LANG_VALUE" || "$LANG_VALUE" == "tbd" ]]; then
      echo "Manifest key '$lang_key' must be populated." >&2
      exit 1
    fi
    if [[ "$LANG_VALUE" != *ja* ]]; then
      echo "Manifest key '$lang_key' must indicate Japanese-first policy (include 'ja'), current: ${LANG_VALUE:-empty}." >&2
      exit 1
    fi
  done

  REPORT_PATH="$(read_manifest_value report_path)"
  if [[ -z "$REPORT_PATH" || "$REPORT_PATH" == "TBD" || "$REPORT_PATH" == "docs/reports/{task_id}.md" ]]; then
    echo "Manifest key 'report_path' must point to an existing report file before $CODEX_MODE." >&2
    echo "Run /update-learning-report and set docs/reports/<task_id>.md in manifest." >&2
    exit 1
  fi

  REPORT_FILE="$PROJECT_ROOT/$REPORT_PATH"
  if [[ ! -f "$REPORT_FILE" ]]; then
    echo "Report file not found: $REPORT_PATH" >&2
    echo "Create or update it via /update-learning-report before gate execution." >&2
    exit 1
  fi

  if [[ ! -x "$VALIDATE_REPORT_SCRIPT" ]]; then
    echo "Report validator not found or not executable: $VALIDATE_REPORT_SCRIPT" >&2
    exit 1
  fi

  bash "$VALIDATE_REPORT_SCRIPT" "$REPORT_FILE"

  MANIFEST_COMMIT="$(read_manifest_value source_commit)"
  if [[ -n "$MANIFEST_COMMIT" && "$MANIFEST_COMMIT" != "$SOURCE_COMMIT" ]]; then
    echo "Warning: manifest source_commit ($MANIFEST_COMMIT) != current commit ($SOURCE_COMMIT)" >&2
    echo "Proceeding because working tree may be dirty, but refresh context if analysis looks stale." >&2
  fi
fi

MODE_INSTRUCTIONS=""
case "$CODEX_MODE" in
  plan-review)
    MODE_INSTRUCTIONS=$'- Focus on plan risks, sequencing, and task decomposition.\n- Return explicit acceptance criteria per task.'
    ;;
  implementation-review)
    MODE_INSTRUCTIONS=$'- Focus on behavioral regressions, security/performance risks, and missing tests.\n- Prioritize findings by severity with actionable fixes.'
    ;;
  ad-hoc)
    MODE_INSTRUCTIONS='- Solve the requested task directly while keeping output structured.'
    ;;
esac

PROMPT="$(cat <<EOF_PROMPT
## Codex Mode
$CODEX_MODE

## Task Type
$TASK_TYPE

## Question
$QUESTION

## Context
$CONTEXT

## For-Codex Context Policy
- Read docs/for-codex first.
- Inspect broader code only if docs/for-codex is inconsistent, incomplete, or risk is high.

## Instructions
- Analyze thoroughly before responding.
- Provide structured output with clear sections.
- Include trade-offs and alternatives where applicable.
- Perform internal reasoning in English for accuracy.
- Write the final user-facing answer in Japanese by default (unless the question explicitly requests another language).
$MODE_INSTRUCTIONS
EOF_PROMPT
)"

echo "=== Consulting Codex CLI ($CODEX_MODE/$TASK_TYPE) ==="
echo "Model: $EFFECTIVE_MODEL"
echo "Reasoning effort: $EFFECTIVE_EFFORT"
echo "Sandbox: read-only"
echo "Commit: $SOURCE_COMMIT ($WORKTREE_STATE)"
echo

CMD=("$CODEX_PATH" exec --model "$EFFECTIVE_MODEL" -c "model_reasoning_effort=\"$EFFECTIVE_EFFORT\"" --sandbox read-only --skip-git-repo-check)
if [[ -n "$OUTPUT_SCHEMA" ]]; then
  CMD+=(--output-schema "$OUTPUT_SCHEMA")
fi

pushd "$PROJECT_ROOT" >/dev/null
if RESULT="$(printf '%s\n' "$PROMPT" | "${CMD[@]}" 2>"$STDERR_FILE")"; then
  if [[ -f "$STDERR_FILE" ]]; then
    STDERR_TMP="$(mktemp)"
    redact_sensitive_text <"$STDERR_FILE" >"$STDERR_TMP"
    mv "$STDERR_TMP" "$STDERR_FILE"
  fi

  if [[ -n "$RESULT" ]]; then
    SANITIZED_RESULT="$(printf '%s\n' "$RESULT" | redact_sensitive_text)"

    {
      echo "# Codex Response"
      echo
      echo "- codex_mode: $CODEX_MODE"
      echo "- task_type: $TASK_TYPE"
      echo "- model: $EFFECTIVE_MODEL"
      echo "- reasoning_effort: $EFFECTIVE_EFFORT"
      echo "- sandbox: read-only"
      echo "- source_commit: $SOURCE_COMMIT"
      echo "- worktree_state: $WORKTREE_STATE"
      echo "- generated_at: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
      echo
      echo "$SANITIZED_RESULT"
    } > "$OUTPUT_FILE"

    if [[ ! -s "$STDERR_FILE" ]]; then
      rm -f "$STDERR_FILE"
    fi

    echo "=== Codex Response ==="
    printf '%s\n' "$SANITIZED_RESULT"
    echo
    echo "Response saved to: $OUTPUT_FILE"
    if [[ -f "$STDERR_FILE" ]]; then
      echo "Stderr saved to: $STDERR_FILE"
    fi
  else
    echo "No response from Codex. Check Codex CLI installation and authentication." >&2
    echo "Stderr log: $STDERR_FILE" >&2
    exit 1
  fi
else
  echo "Failed to execute Codex CLI." >&2
  echo "Stderr log: $STDERR_FILE" >&2
  exit 1
fi
popd >/dev/null
