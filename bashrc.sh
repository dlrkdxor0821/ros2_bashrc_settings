#!/usr/bin/env bash
# =============================================================================
# ros2_bashrc_settings - bashrc 커스텀 설정
# -----------------------------------------------------------------------------
# Ubuntu 기본 ~/.bashrc(/etc/skel/.bashrc) 대비 추가/변경한 내용만 모아둔 파일.
# 앞으로 수정할 내용(ROS2 설정 등)은 이 파일에 추가한다.
#
# 사용법: ~/.bashrc 맨 끝에 아래 한 줄을 추가하면 적용됨
#   source ~/personal_repo/ros2_bashrc_settings/bashrc.sh
# =============================================================================

# --- 현재 git 브랜치를 프롬프트에 표시 (git 저장소 안에서만) ---------------
parse_git_branch() {
    git branch 2>/dev/null | sed -n 's/^\* \(.*\)/ (\1)/p'
}

# ROS2 환경(jazzy) 활성화 시 도메인 ID를 프롬프트에 표시 (예: "(ID:119) ")
ros_prompt_id() {
    [ -n "$ROS_PROMPT" ] && printf '(ID:%s) ' "$ROS_DOMAIN_ID"
}

# 프롬프트(PS1)를 git 브랜치 + ROS 도메인 ID 표시가 포함된 형태로 재설정.
# 컬러 지원 여부를 직접 감지한다(기본 .bashrc가 color_prompt 변수를 unset 하므로).
if [ -x /usr/bin/tput ] && tput setaf 1 >/dev/null 2>&1; then
    # 컬러: (ID:..)(노랑) user@host(초록) : 경로(파랑) (브랜치)(빨강)
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;33m\]$(ros_prompt_id)\[\033[00m\]\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\[\033[01;31m\]$(parse_git_branch)\[\033[00m\]\n\$ '
else
    # 비컬러
    PS1='${debian_chroot:+($debian_chroot)}$(ros_prompt_id)\u@\h:\w$(parse_git_branch)\n\$ '
fi

# --- 사용자 로컬 bin을 PATH 맨 앞에 추가 -----------------------------------
# pip install --user / pipx 등으로 설치한 CLI가 ~/.local/bin 에 들어감
export PATH="$HOME/.local/bin:$PATH"

# --- alias --------------------------------------------------------------------
alias claude="claude --dangerously-skip-permissions"
alias sb="source ~/.bashrc"
alias gco='git checkout'
alias gs='git status'
alias gd='git diff'

# =============================================================================
# ROS2 설정
# -----------------------------------------------------------------------------
alias ccbs='colcon build --symlink-install'        # colcon 빌드 (symlink install)
alias si='source ./install/local_setup.bash'       # 현재 워크스페이스 overlay source
export ROS_DOMAIN_ID=119                            # 도메인 ID

# jazzy: ROS2 jazzy 환경 활성화 (+ 프롬프트에 (ID:..) 표시)
# 도메인 ID는 위 ROS_DOMAIN_ID 값을 그대로 사용 (한 곳만 바꾸면 됨)
jazzy() {
    source /opt/ros/jazzy/setup.bash
    export ROS_PROMPT=1
}

# 앞으로 추가할 ROS2 설정 (예시)
# source ~/ros2_ws/install/setup.bash              # workspace overlay
# export RMW_IMPLEMENTATION=rmw_fastrtps_cpp        # DDS 미들웨어
# =============================================================================
