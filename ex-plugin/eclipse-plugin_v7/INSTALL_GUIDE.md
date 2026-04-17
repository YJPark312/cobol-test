# DeepAgents C2J Eclipse Plugin 설치 가이드

## 배포 파일

```
com.deepagents.cli-1.0.0-SNAPSHOT.jar    (약 54KB)
```

## 호환 환경

| 항목 | 지원 범위 |
|------|-----------|
| Eclipse | 3.4 Ganymede (2008) ~ 2024-03 (2024) |
| Java | 1.8 이상 |
| OS | Windows, macOS, Linux |
| 네트워크 | 폐쇄망 가능 (외부 연결 불필요) |

---

## 설치 방법

### 방법 1: dropins 폴더 복사 (권장 — 가장 간단)

1. Eclipse를 **종료**합니다.

2. JAR 파일을 Eclipse 설치 경로의 `dropins` 폴더에 복사합니다:

   **Windows:**
   ```
   C:\eclipse\dropins\com.deepagents.cli-1.0.0-SNAPSHOT.jar
   ```

   **macOS:**
   ```
   /Applications/Eclipse.app/Contents/Eclipse/dropins/com.deepagents.cli-1.0.0-SNAPSHOT.jar
   ```

   **Linux:**
   ```
   /opt/eclipse/dropins/com.deepagents.cli-1.0.0-SNAPSHOT.jar
   ```

   > `dropins` 폴더가 없으면 직접 생성하세요.

3. Eclipse를 **시작**합니다.

4. 확인: 메뉴에 **C2J** 메뉴가 표시되면 설치 성공.

---

### 방법 2: plugins 폴더에 직접 복사

`dropins`가 동작하지 않는 구버전 Eclipse에서 사용:

1. Eclipse 종료
2. JAR을 `plugins` 폴더에 복사:
   ```
   eclipse/plugins/com.deepagents.cli-1.0.0-SNAPSHOT.jar
   ```
3. Eclipse 시작 시 `-clean` 옵션 추가:
   ```bash
   eclipse -clean
   ```
   > 최초 1회만 `-clean` 필요, 이후에는 일반 실행

---

## 설치 확인

1. Eclipse 메뉴바에 **C2J** 메뉴 확인
2. `Window` > `Show View` > `Other...` > `DeepAgents` > `DeepAgents` 선택
3. C2J 패널이 열리면 설치 완료

---

## 초기 설정

플러그인 설치 후, API 서버 주소를 설정해야 합니다:

1. `Window` > `Preferences` (macOS: `Eclipse` > `Preferences`)
2. 좌측 트리에서 **DeepAgents** 선택
3. 설정 항목:

   | 항목 | 설명 | 예시 |
   |------|------|------|
   | C2J API Server URL | 백엔드 API 서버 주소 | `http://10.0.0.100:8123` |
   | User ID | 사용자 식별 키 | `hong` |
   | Auto-approve | 툴 호출 자동 승인 | 체크/해제 |

4. **Apply and Close** 클릭

---

## 사용법

### COBOL→Java 전환

- **방법 1:** 좌측 `Programs` 탭에서 프로그램 더블클릭
- **방법 2:** COBOL 파일 열고 우클릭 > `C2J` > `C2J 전환`
- **방법 3:** 메뉴 `C2J` > `C2J 전환 (현재 파일)`

### 자유 질문 (파일 첨부)

1. 좌측 `Project` 탭에서 참조할 파일을 **체크**
2. 하단 입력창에 질문 입력
3. **Send** → 체크한 파일 내용이 자동 첨부되어 전송됨

---

## 제거 방법

1. Eclipse 종료
2. `dropins` (또는 `plugins`) 폴더에서 JAR 파일 삭제
3. Eclipse 시작

---

## 트러블슈팅

### 플러그인이 로드되지 않을 때

```bash
# Eclipse를 clean 모드로 시작
eclipse -clean
```

### C2J 메뉴가 안 보일 때

- `Help` > `About Eclipse` > `Installation Details` > `Plug-ins` 탭
- `com.deepagents.cli` 검색 → 목록에 있으면 로드됨
- 없으면 JAR 경로 확인

### Linux에서 Browser 영역이 빈 화면일 때

SWT Browser가 WebKit GTK를 필요로 합니다:

```bash
# Ubuntu/Debian
sudo apt-get install libwebkit2gtk-4.0-37

# RHEL/CentOS
sudo yum install webkit2gtk3
```

### 구버전 Eclipse (3.x)에서 동작하지 않을 때

`dropins` 대신 `plugins` 폴더에 복사하고 `-clean`으로 시작하세요.
