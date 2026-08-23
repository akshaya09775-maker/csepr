@echo off
setlocal

title Authentication Project Setup
color 0A

echo.
echo =================================================
echo       AUTHENTICATION PROJECT SETUP
echo =================================================
echo.

REM =================================================
REM CURRENT BAT FILE DIRECTORY
REM =================================================

set "BASE=%~dp0"
set "PROJECT=%BASE%auth-project"
set "API=%PROJECT%\api"

echo Current BAT location:
echo %BASE%
echo.
echo Project location:
echo %PROJECT%
echo.

REM =================================================
REM 1. CREATE PROJECT FOLDER
REM =================================================

echo [1/11] Creating project folder...
echo.

if not exist "%PROJECT%" mkdir "%PROJECT%"
if not exist "%API%" mkdir "%API%"

cd /d "%API%"

echo Project folder created.
echo.

REM =================================================
REM 2. CREATE SPRING BOOT PROJECT
REM =================================================

echo [2/11] Creating Spring Boot project...
echo.

spring init ^
--build=maven ^
--dependencies=web,devtools,thymeleaf,mysql,data-jpa,lombok ^
--package=app ^
--name=auth ^
auth

if errorlevel 1 (
    echo.
    echo ================================================
    echo ERROR: Spring Boot project creation failed.
    echo ================================================
    pause
    exit /b 1
)

REM =================================================
REM 3. EXTRACT SPRING BOOT PROJECT
REM   "spring init" auto-extracts into ".\auth" because the
REM   target location has no .zip extension, so no zip file
REM   is ever produced here.
REM =================================================

echo.
echo [3/11] Preparing Spring Boot project...
echo.

if not exist "%API%\auth" (
    echo.
    echo ================================================
    echo ERROR: Expected folder "%API%\auth" was not created.
    echo ================================================
    pause
    exit /b 1
)

xcopy /E /I /Y "%API%\auth\*" "%API%\" >nul
rmdir /S /Q "%API%\auth"

cd /d "%API%"

REM =================================================
REM 4. ADD SWAGGER / OPENAPI
REM =================================================

echo.
echo [4/11] Adding Swagger / OpenAPI...
echo.

powershell -NoProfile -Command "$pom = Get-Content 'pom.xml' -Raw; $dependency = '<dependency><groupId>org.springdoc</groupId><artifactId>springdoc-openapi-starter-webmvc-ui</artifactId><version>3.1.0</version></dependency>'; $pom = $pom.Replace('</dependencies>', $dependency + '</dependencies>'); Set-Content 'pom.xml' $pom"

if errorlevel 1 (
    echo.
    echo ================================================
    echo ERROR: Failed to add Swagger dependency.
    echo ================================================
    pause
    exit /b 1
)

echo Swagger dependency added successfully.
echo.

REM =================================================
REM 5. APPLICATION.PROPERTIES
REM =================================================

echo [5/11] Creating application.properties...
echo.

(
echo spring.application.name=auth
echo.
echo server.port=5000
echo.
echo spring.datasource.url=jdbc:mysql://127.0.0.1:3306/authentication
echo spring.datasource.username=root
echo spring.datasource.password=root
echo.
echo spring.jpa.hibernate.ddl-auto=update
echo spring.jpa.show-sql=true
echo.
echo springdoc.api-docs.path=/v3/api-docs
echo springdoc.swagger-ui.path=/swagger-ui.html
) > "src\main\resources\application.properties"

echo application.properties created.
echo.

REM =================================================
REM 6. CREATE PACKAGE STRUCTURE
REM =================================================

echo [6/11] Creating packages...
echo.

if not exist "src\main\java\app\model" mkdir "src\main\java\app\model"
if not exist "src\main\java\app\repo" mkdir "src\main\java\app\repo"
if not exist "src\main\java\app\service" mkdir "src\main\java\app\service"
if not exist "src\main\java\app\controller" mkdir "src\main\java\app\controller"
if not exist "src\main\java\app\dto" mkdir "src\main\java\app\dto"

REM =================================================
REM 7. CREATE INDEX.JAVA
REM =================================================

echo [7/11] Creating Index.java...
echo.

(
echo package app;
echo.
echo import java.util.Map;
echo import org.springframework.web.bind.annotation.GetMapping;
echo import org.springframework.web.bind.annotation.RestController;
echo.
echo @RestController
echo public class Index {
echo.
echo     @GetMapping^("/"^)
echo     public Map^<String, Object^> home^(^) {
echo.
echo         return Map.of^(
echo             "msg", "Authentication API is running",
echo             "status", "success",
echo             "api", "authentication"
echo         ^);
echo     }
echo }
) > "src\main\java\app\Index.java"

REM =================================================
REM CREATE USER MODEL
REM =================================================

echo Creating User.java...
echo.

(
echo package app.model;
echo.
echo import jakarta.persistence.Entity;
echo import jakarta.persistence.GeneratedValue;
echo import jakarta.persistence.GenerationType;
echo import jakarta.persistence.Id;
echo import lombok.AllArgsConstructor;
echo import lombok.Data;
echo import lombok.NoArgsConstructor;
echo.
echo @Entity
echo @Data
echo @NoArgsConstructor
echo @AllArgsConstructor
echo public class User {
echo.
echo     @Id
echo     @GeneratedValue^(strategy = GenerationType.IDENTITY^)
echo     private Long id;
echo.
echo     private String name;
echo     private String email;
echo     private String password;
echo     private String role;
echo }
) > "src\main\java\app\model\User.java"

REM =================================================
REM CREATE USER DTO
REM =================================================

echo Creating UserDto.java...
echo.

(
echo package app.dto;
echo.
echo import lombok.AllArgsConstructor;
echo import lombok.Data;
echo import lombok.NoArgsConstructor;
echo.
echo @Data
echo @NoArgsConstructor
echo @AllArgsConstructor
echo public class UserDto {
echo.
echo     private String name;
echo     private String email;
echo     private String password;
echo     private String role;
echo }
) > "src\main\java\app\dto\UserDto.java"

REM =================================================
REM CREATE USER REPOSITORY
REM =================================================

echo Creating UserRepo.java...
echo.

(
echo package app.repo;
echo.
echo import app.model.User;
echo import org.springframework.data.jpa.repository.JpaRepository;
echo.
echo public interface UserRepo extends JpaRepository^<User, Long^> {
echo.
echo     User findByEmail^(String email^);
echo }
) > "src\main\java\app\repo\UserRepo.java"

REM =================================================
REM CREATE USER SERVICE
REM =================================================

echo Creating UserService.java...
echo.

(
echo package app.service;
echo.
echo import app.dto.UserDto;
echo import app.model.User;
echo import app.repo.UserRepo;
echo import org.springframework.stereotype.Service;
echo import java.util.List;
echo.
echo @Service
echo public class UserService {
echo.
echo     private final UserRepo userRepo;
echo.
echo     public UserService^(UserRepo userRepo^) {
echo         this.userRepo = userRepo;
echo     }
echo.
echo     public User save^(UserDto dto^) {
echo.
echo         User user = new User^(^);
echo.
echo         user.setName^(dto.getName^(^)^);
echo         user.setEmail^(dto.getEmail^(^)^);
echo         user.setPassword^(dto.getPassword^(^)^);
echo         user.setRole^(dto.getRole^(^)^);
echo.
echo         return userRepo.save^(user^);
echo     }
echo.
echo     public List^<User^> getAll^(^) {
echo         return userRepo.findAll^(^);
echo     }
echo.
echo     public User getByEmail^(String email^) {
echo         return userRepo.findByEmail^(email^);
echo     }
echo }
) > "src\main\java\app\service\UserService.java"

REM =================================================
REM CREATE USER CONTROLLER
REM =================================================

echo Creating UserController.java...
echo.

(
echo package app.controller;
echo.
echo import app.dto.UserDto;
echo import app.model.User;
echo import app.service.UserService;
echo import org.springframework.web.bind.annotation.*;
echo import java.util.List;
echo import java.util.Map;
echo.
echo @RestController
echo @RequestMapping^("/api/users"^)
echo public class UserController {
echo.
echo     private final UserService userService;
echo.
echo     public UserController^(UserService userService^) {
echo         this.userService = userService;
echo     }
echo.
echo     @PostMapping
echo     public Map^<String, Object^> create^(@RequestBody UserDto dto^) {
echo.
echo         User user = userService.save^(dto^);
echo.
echo         return Map.of^(
echo             "msg", "User created successfully",
echo             "status", "success",
echo             "user", user
echo         ^);
echo     }
echo.
echo     @GetMapping
echo     public Map^<String, Object^> getAll^(^) {
echo.
echo         List^<User^> users = userService.getAll^(^);
echo.
echo         return Map.of^(
echo             "msg", "Users fetched successfully",
echo             "status", "success",
echo             "users", users
echo         ^);
echo     }
echo.
echo     @GetMapping^("/{email}"^)
echo     public User getByEmail^(@PathVariable String email^) {
echo         return userService.getByEmail^(email^);
echo     }
echo }
) > "src\main\java\app\controller\UserController.java"

REM =================================================
REM SHOW PROJECT STRUCTURE
REM =================================================

echo.
echo =================================================
echo PROJECT STRUCTURE
echo =================================================
echo.

tree /F "%PROJECT%"

REM =================================================
REM 8. WRITE LAUNCHER SCRIPTS
REM   Each terminal's commands live in their own .bat file
REM   instead of being crammed into one quoted "cmd /k ..."
REM   string. A double-quoted -e "..." argument for mysql
REM   cannot safely sit inside another double-quoted string,
REM   so this sidesteps that quoting problem entirely.
REM =================================================

echo.
echo [8/11] Writing terminal launcher scripts...
echo.

(
echo @echo off
echo color 0A
echo title MYSQL - AUTHENTICATION DATABASE
echo echo ================================================
echo echo MYSQL AUTHENTICATION DATABASE
echo echo ================================================
echo echo.
echo mysql -u root -proot -e "CREATE DATABASE IF NOT EXISTS authentication; USE authentication; SHOW TABLES;"
echo echo.
echo echo ================================================
echo echo DATABASE AUTHENTICATION IS READY
echo echo ================================================
echo echo.
echo mysql -u root -proot
) > "%PROJECT%\_run-mysql.bat"

(
echo @echo off
echo color 0A
echo title AUTH BACKEND - MAVEN
echo cd /d "%API%"
echo echo ================================================
echo echo AUTHENTICATION BACKEND
echo echo ================================================
echo echo.
echo echo Running: mvn clean install -DskipTests
echo echo.
echo call mvn clean install -DskipTests
echo echo.
echo echo ================================================
echo echo MAVEN BUILD COMPLETED
echo echo ================================================
echo echo.
echo echo Waiting 8 seconds before Spring Boot...
echo timeout /t 8 /nobreak
echo echo.
echo echo ================================================
echo echo STARTING SPRING BOOT
echo echo ================================================
echo echo.
echo call mvn spring-boot:run
) > "%PROJECT%\_run-backend.bat"

REM =================================================
REM 9. OPEN MYSQL CMD
REM =================================================

echo.
echo [9/11] Opening MySQL command prompt...
echo.

start "MYSQL DATABASE" cmd /k "%PROJECT%\_run-mysql.bat"

REM =================================================
REM 10. OPEN BACKEND CMD
REM =================================================

echo.
echo [10/11] Opening backend command prompt...
echo.

start "AUTH BACKEND - MAVEN" cmd /k "%PROJECT%\_run-backend.bat"

REM =================================================
REM 11. WAIT FOR BACKEND, THEN OPEN CHROME
REM   A fixed "timeout /t 15" is not reliable: a first-time
REM   "mvn clean install" downloading dependencies can easily
REM   take longer than that. Poll the server instead of
REM   guessing a duration.
REM =================================================

echo.
echo [11/11] Waiting for Spring Boot to become available...
echo.

set /a ATTEMPTS=0
:WAIT_FOR_SERVER
set /a ATTEMPTS+=1
powershell -NoProfile -Command "try { Invoke-WebRequest -Uri 'http://127.0.0.1:5000/' -UseBasicParsing -TimeoutSec 2 | Out-Null; exit 0 } catch { exit 1 }" >nul 2>&1
if not errorlevel 1 goto SERVER_READY
if %ATTEMPTS% GEQ 60 goto SERVER_TIMEOUT
timeout /t 2 /nobreak >nul
goto WAIT_FOR_SERVER

:SERVER_TIMEOUT
echo.
echo Backend did not respond after 2 minutes.
echo Opening the browser anyway - check the AUTH BACKEND window for errors.
echo.
goto OPEN_BROWSER

:SERVER_READY
echo.
echo Backend is up.
echo.

:OPEN_BROWSER
echo Opening Chrome...
echo.

start "" chrome "http://127.0.0.1:5000/"
timeout /t 2 /nobreak >nul
start "" chrome "http://127.0.0.1:5000/swagger-ui/index.html"

REM =================================================
REM FINAL MESSAGE
REM =================================================

echo.
echo =================================================
echo       SETUP COMPLETED SUCCESSFULLY
echo =================================================
echo.
echo Project:
echo %PROJECT%
echo.
echo Backend:
echo http://127.0.0.1:5000/
echo.
echo Swagger:
echo http://127.0.0.1:5000/swagger-ui/index.html
echo.
echo OpenAPI:
echo http://127.0.0.1:5000/v3/api-docs
echo.
echo Users API:
echo http://127.0.0.1:5000/api/users
echo.
echo Database:
echo authentication
echo.
echo =================================================
echo.

pause
