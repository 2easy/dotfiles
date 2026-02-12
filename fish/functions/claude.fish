function zclaude
    # Load token from ~/.env
    if test -f ~/.env
        set -x ANTHROPIC_AUTH_TOKEN (grep '^ANTHROPIC_AUTH_TOKEN=' ~/.env | cut -d= -f2- | tr -d '"')
    end

    set -x ANTHROPIC_BASE_URL "https://api.z.ai/api/anthropic"
    set -x API_TIMEOUT_MS "3000000"
    set -x CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC "1"
    set -x ANTHROPIC_DEFAULT_HAIKU_MODEL "glm-5"
    set -x ANTHROPIC_DEFAULT_SONNET_MODEL "glm-5"
    set -x ANTHROPIC_DEFAULT_OPUS_MODEL "glm-5"

    set -l claude_bin (which claude)
    $claude_bin $argv
end

function cclaude
    # Load token from ~/.env
    if test -f ~/.env
        set -x CLAUDE_CODE_OAUTH_TOKEN (grep '^CLAUDE_CODE_OAUTH_TOKEN=' ~/.env | cut -d= -f2- | tr -d '"')
    end

    set -l claude_bin (which claude)
    $claude_bin $argv
end
