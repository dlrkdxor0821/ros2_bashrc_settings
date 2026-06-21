# ros2_bashrc_settings

ROS2 개발용 bashrc 설정 모음. Ubuntu 기본 `~/.bashrc`(`/etc/skel/.bashrc`)에서
추가/변경한 내용을 [`bashrc.sh`](./bashrc.sh)에 정리해 둔다.

## 사용법

`bashrc.sh`의 커스텀 부분을 `~/.bashrc`에 **직접 복사해 붙여넣어** 사용한다.
(사용자명·호스트명은 `\u`·`\h`, 홈 경로는 `$HOME`으로 들어가 있어 다른 환경에서도
그대로 복붙하면 된다.) 적용 후 `sb`로 다시 불러올 수 있다.

## 기본값(`/etc/skel/.bashrc`) 대비 변경점

### 1. git 브랜치를 프롬프트에 표시
`parse_git_branch` 함수를 추가하고 `PS1`을 재설정하여, git 저장소 안에서는
프롬프트에 ` (브랜치명)`이 빨간색으로 표시된다.

```bash
parse_git_branch() {
    git branch 2>/dev/null | sed -n 's/^\* \(.*\)/ (\1)/p'
}
```

### 2. 명령 입력을 다음 줄로
`PS1` 끝의 `\$ ` 앞에 `\n`을 넣어, 프롬프트 정보는 윗줄에 두고 명령은 아랫줄에
입력하도록 했다.

```
asd@asd-pc:~/personal_repo/ros2_bashrc_settings (main)
$ 
```

### 3. 사용자 로컬 bin을 PATH에 추가
`pip install --user` / `pipx` 등으로 설치한 CLI(`colcon`, `rosdep` 등)를
이름만으로 실행할 수 있도록 `~/.local/bin`을 PATH 맨 앞에 추가한다.

```bash
export PATH="$HOME/.local/bin:$PATH"
```

### 4. ROS2 도메인 ID
```bash
export ROS_DOMAIN_ID=119
```
도메인 ID는 이 한 곳에서만 관리한다. 값을 바꾸면 `jazzy` 실행 시에도 자동 반영된다.

### 5. `jazzy` 명령 (프롬프트에 도메인 ID 표시)
입력하면 ROS2 jazzy 환경을 활성화하고, 프롬프트 맨 앞에 노란색으로
`(ID:119)`(= 현재 `ROS_DOMAIN_ID` 값)를 표시한다.

```bash
ros_prompt_id() {
    [ -n "$ROS_PROMPT" ] && printf '(ID:%s) ' "$ROS_DOMAIN_ID"
}

jazzy() {
    source /opt/ros/jazzy/setup.bash
    export ROS_PROMPT=1
}
```

`jazzy` 실행 후 프롬프트:
```
(ID:119) asd@asd-pc:~/ros2_ws (main)
$ 
```

### 6. alias 추가

| alias | 명령 | 설명 |
|-------|------|------|
| `claude` | `claude --dangerously-skip-permissions` | 권한 확인 없이 claude 실행 |
| `sb` | `source ~/.bashrc` | bashrc 재적용 |
| `gco` | `git checkout` | git checkout 단축 |
| `gs` | `git status` | git status 단축 |
| `gd` | `git diff` | git diff 단축 |
| `ga` | `git add .` | 전체 staged 추가 |
| `gcm` | `git commit -m "$*"` | 따옴표 없이 `gcm 메시지...` 로 커밋 (함수) |
| `ccbs` | `colcon build --symlink-install` | colcon 빌드 (symlink install) |
| `si` | `source ./install/local_setup.bash` | 현재 워크스페이스 overlay source |

> 나머지 설정(history, lesspipe, ls 컬러/alias, bash-completion 등)은
> Ubuntu 기본값을 그대로 사용한다.
