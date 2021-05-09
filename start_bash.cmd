@echo off
rem BASH���iCentOS image via Docker�j���N�����邽�߂̃X�N���v�g
rem M.SAkAMOTO

setlocal enabledelayedexpansion


set IMAGE_ID=my_bash_test:1
set DOCKER_CMDLINE=docker run -d -v myvol:/data --privileged %IMAGE_ID% /sbin/init

echo.[%DATE% %TIME%] Starting container ^(image id : %IMAGE_ID%^)

rem Docker Images�̑��݊m�F
set DOCKER_IMAGE_EXISTS=
for /F "usebackq tokens=* delims=" %%i in (`docker images -q -f "reference=%IMAGE_ID%"`) do set DOCKER_IMAGE_EXISTS=%%i
if "%DOCKER_IMAGE_EXISTS%"=="" (
    echo.Docker image ^(%IMAGE_ID%^) was not fuond.
    timeout /t 5
    exit /b
)

rem Docker�C���[�W�̋N���`�v���Z�X�ւ̃A�^�b�`
for /F "usebackq tokens=* delims=" %%i in (`%DOCKER_CMDLINE%`) do set DOCKER_OUTPUT=%%i

set CONTAINER_ID=%DOCKER_OUTPUT:~0,12%
title "%CONTAINER_ID%"

docker exec -it "%CONTAINER_ID%" /bin/bash

rem Docker�v���Z�X�̒�~�`�폜
echo.[%DATE% %TIME%] Terminating container ^(%CONTAINER_ID%^).
echo.Stopping...
docker stop "%CONTAINER_ID%"

echo.Removing...
docker rm "%CONTAINER_ID%"

timeout /t 5
exit /b
