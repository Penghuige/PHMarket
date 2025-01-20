.PHONY: clean all submit clean_data run

# 自定义环境变量
CC = g++ # 指定编译器
CFLAGS = -Iinclude -Wall -Wextra # 添加更多警告以便排查问题
SRC_DIR = src
BIN_DIR = bin

# 文件匹配
CFILES = $(shell find $(SRC_DIR) -name "*.c")
CPPFILES = $(shell find $(SRC_DIR) -name "*.cpp")
OBJS = $(patsubst $(SRC_DIR)/%.cpp, $(BIN_DIR)/%.o, $(CPPFILES)) $(patsubst $(SRC_DIR)/%.c, $(BIN_DIR)/%.o, $(CFILES))
TARGET = $(BIN_DIR)/main

# 删除命令
RM = rm -f

# 进度记录相关
DEVICE = Linux-PC
STUNAME = Penghui
GITFLAGS = -q --author='tracer<Penghui@Linux-PC>' --no-verify --allow-empty

# Git 提交函数
define git_commit
	-@while (test -e .git/index.lock); do sleep 0.1; done
	-@(echo "> $(1)" && echo $(DEVICE) $(STUNAME) && uname -a && uptime) | git commit -F - $(GITFLAGS)
	-@sync
endef

# 提交到 GitHub 仓库
submit:
	git remote set-url origin git@github.com:Penghuige/PHMarket.git
	git add . --ignore-errors
	-@while (test -e .git/index.lock); do sleep 0.1; done
	git commit -m "Automated submission"
	git push origin main

# 默认目标
all: $(TARGET)

# 链接目标
$(TARGET): $(OBJS)
	@mkdir -p $(BIN_DIR)
	$(CC) $(CFLAGS) -o $@ $^
	@$(call git_commit, "Auto-commit")

# 编译规则
$(BIN_DIR)/%.o: $(SRC_DIR)/%.cpp
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

$(BIN_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

# 清理目标
clean:
	rm -rf $(BIN_DIR) $(TARGET)

clean_data:
	$(RM) $(DATA)

run: all
	@$(TARGET)
