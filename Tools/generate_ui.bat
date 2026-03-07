@echo off

REM 切换到 bat 所在目录
cd /d "%~dp0"

REM 执行 Python 脚本
python "generate_ui2.py"

REM 保持窗口
pause