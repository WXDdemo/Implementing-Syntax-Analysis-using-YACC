# Windows 专用 Makefile（适配 calc.l/calc.y，无 libfl 依赖）
TARGET = main.exe

# 匹配你的实际文件名
LEX_FILE = calc.l
YACC_FILE = calc.y

# 生成的中间文件
LEX_OUTPUT = lex.yy.c
YACC_C = calc.tab.c
YACC_H = calc.tab.h

# 默认目标：一键编译+运行
all: run

# 运行可执行文件
run: $(TARGET)
	$(TARGET)

# 编译链接（删除 -lfl 和库路径，核心修改）
$(TARGET): $(LEX_OUTPUT) $(YACC_C)
	g++ -std=gnu++14 $(LEX_OUTPUT) $(YACC_C) -o $(TARGET)

# flex 编译 calc.l
$(LEX_OUTPUT): $(LEX_FILE)
	flex $(LEX_FILE)

# bison 编译 calc.y → 生成 calc.tab.c + calc.tab.h
$(YACC_C) $(YACC_H): $(YACC_FILE)
	bison -d $(YACC_FILE) -o $(YACC_C)

# 清理文件
clean:
	del /f /q $(LEX_OUTPUT) $(YACC_C) $(YACC_H) $(TARGET)

.PHONY: all run clean
