#!/bin/bash
# Git自动配置与仓库克隆脚本
# 将此脚本保存为 setup_git.sh 并赋予执行权限: chmod +x setup_git.sh
 
# 显示彩色输出
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color
 
echo -e "${YELLOW}开始配置Git环境...${NC}"
 
# 1. 检查并安装Git
if ! command -v git &> /dev/null; then
    echo -e "${YELLOW}Git未安装，正在安装...${NC}"
    # 检测系统类型并安装Git
    if command -v apt-get &> /dev/null; then
        apt-get update
        apt-get install -y git
    elif command -v yum &> /dev/null; then
        yum install -y git
    else
        echo -e "${RED}无法确定包管理器，请手动安装Git${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}Git已安装，版本: $(git --version)${NC}"
fi
 
# 2. 配置Git用户信息
echo -e "${YELLOW}配置Git用户信息...${NC}"
git config --global user.name "qiujiangwen"  # 替换为你的姓名
git config --global user.email "2069001598@qq.com"  # 替换为你的邮箱
 
# 3. 生成SSH密钥
echo -e "${YELLOW}检查SSH密钥...${NC}"
SSH_DIR=~/.ssh
SSH_SAVE_DIR=/openbayes/home/sshpub
 
# 创建存储公钥的目录
mkdir -p "$SSH_SAVE_DIR"
 
# 检查是否已有SSH密钥
if [ ! -f "$SSH_DIR/id_ed25519" ] && [ ! -f "$SSH_DIR/id_rsa" ]; then
    echo -e "${YELLOW}未找到SSH密钥，正在生成...${NC}"
    # 创建.ssh目录（如果不存在）
    mkdir -p "$SSH_DIR"
    chmod 700 "$SSH_DIR"
    
    # 生成不带密码的SSH密钥
    ssh-keygen -t ed25519 -C "2069001598@qq.com" -f "$SSH_DIR/id_ed25519" -N ""
    
    echo -e "${GREEN}SSH密钥生成完成!${NC}"
else
    echo -e "${GREEN}SSH密钥已存在.${NC}"
fi
 
# 复制公钥到指定目录
if [ -f "$SSH_DIR/id_ed25519.pub" ]; then
    cp "$SSH_DIR/id_ed25519.pub" "$SSH_SAVE_DIR/"
    echo -e "${GREEN}ED25519公钥已保存到 $SSH_SAVE_DIR/id_ed25519.pub${NC}"
elif [ -f "$SSH_DIR/id_rsa.pub" ]; then
    cp "$SSH_DIR/id_rsa.pub" "$SSH_SAVE_DIR/"
    echo -e "${GREEN}RSA公钥已保存到 $SSH_SAVE_DIR/id_rsa.pub${NC}"
fi
 
# 显示公钥
echo -e "${YELLOW}以下是您的公钥，请添加到Github:${NC}"
if [ -f "$SSH_DIR/id_ed25519.pub" ]; then
    cat "$SSH_DIR/id_ed25519.pub"
elif [ -f "$SSH_DIR/id_rsa.pub" ]; then
    cat "$SSH_DIR/id_rsa.pub"
fi
 
# 4. 创建工作目录
WORK_DIR=/openbayes/home/workspace
if [ ! -d "$WORK_DIR" ]; then
    echo -e "${YELLOW}创建工作目录: $WORK_DIR${NC}"
    mkdir -p "$WORK_DIR"
fi
cd "$WORK_DIR"
 
# 5. 克隆或更新仓库
REPO_DIR="$WORK_DIR/Band-gap-predict"
if [ ! -d "$REPO_DIR" ]; then
    echo -e "${YELLOW}克隆仓库...${NC}"
    # 使用HTTPS方式克隆（无需SSH密钥）
    git clone https://github.com/Four-Q/Band-gap-predict.git
    
    # 如果需要使用SSH方式克隆（需先添加SSH公钥到Gitee）
    # git clone git@gitee.com:four-Q/Band-gap-predict.git
else
    echo -e "${YELLOW}更新已有仓库...${NC}"
    cd "$REPO_DIR"
    git pull origin main
fi
 
# 6. 配置Python环境（可选，如果项目需要特定Python包）
# if [ -f "$REPO_DIR/requirements.txt" ]; then
#     echo -e "${YELLOW}安装Python依赖...${NC}"
#     pip install -r "$REPO_DIR/requirements.txt"
# fi
 
echo -e "${GREEN}Git环境配置完成!${NC}"
echo -e "${GREEN}工作目录: $WORK_DIR${NC}"
echo -e "${GREEN}仓库位置: $REPO_DIR${NC}"
echo -e "${GREEN}SSH公钥位置: $SSH_SAVE_DIR${NC}"
echo -e "${YELLOW}请记得将SSH公钥添加到您的Github账户中!${NC}"
 
# 导航到仓库目录（添加检查确保目录存在）
if [ -d "$REPO_DIR" ]; then
    cd "$REPO_DIR"
    echo -e "${GREEN}已切换到仓库目录${NC}"
else
    echo -e "${RED}仓库目录不存在，请检查克隆是否成功${NC}"
fi