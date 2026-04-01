# Docker Compose 작성법 & 사용법 가이드

## 1. Docker Compose란?

여러 개의 Docker 컨테이너를 **하나의 YAML 파일**로 정의하고, 한 번에 실행/관리하는 도구입니다.

```
docker run ... (컨테이너 1개씩)  →  docker compose up (전부 한번에)
```

---

## 2. docker-compose.yml 기본 구조

```yaml
version: "3.8"                # Compose 파일 버전

services:                     # 컨테이너 정의 (핵심)
  서비스이름:
    image: 이미지:태그
    ...

volumes:                      # 데이터 영속 볼륨 정의
  볼륨이름:

networks:                     # 네트워크 정의 (생략 시 자동 생성)
  네트워크이름:
```

---

## 3. services 주요 옵션 설명

### 3-1. 이미지 지정

```yaml
services:
  # 방법 1: 기존 이미지 사용
  neo4j:
    image: neo4j:5-community

  # 방법 2: Dockerfile로 직접 빌드
  app:
    build: .                          # 현재 디렉토리의 Dockerfile 사용
    image: my-app:latest              # 빌드된 이미지에 이름 부여

  # 방법 3: Dockerfile 경로 지정
  loader:
    build:
      context: .                      # 빌드 컨텍스트 (파일 참조 기준 경로)
      dockerfile: Dockerfile.loader   # 사용할 Dockerfile 이름
```

### 3-2. 포트 매핑

```yaml
services:
  web:
    ports:
      - "8080:80"       # 호스트:컨테이너  →  localhost:8080 으로 접속
      - "443:443"       # 여러 포트 매핑 가능
```

**규칙:** `"호스트포트:컨테이너포트"`
- 호스트포트: 내 PC에서 접속할 포트
- 컨테이너포트: 컨테이너 내부에서 실제 서비스가 열린 포트

```
브라우저 → localhost:8080 → (Docker) → 컨테이너:80
```

### 3-3. 환경 변수

```yaml
services:
  app:
    # 방법 1: 직접 지정
    environment:
      - DB_HOST=postgres
      - DB_PORT=5432

    # 방법 2: key: value 형태
    environment:
      DB_HOST: postgres
      DB_PORT: "5432"             # 숫자도 문자열로 감싸는 게 안전

    # 방법 3: .env 파일에서 가져오기
    env_file:
      - .env

    # 방법 4: .env 변수 참조 (${변수명})
    environment:
      - API_KEY=${MY_API_KEY}     # .env 파일의 MY_API_KEY 값 사용
```

### 3-4. 볼륨 (데이터 영속화)

```yaml
services:
  db:
    volumes:
      # Named Volume: Docker가 관리, 컨테이너 삭제해도 데이터 유지
      - db_data:/var/lib/postgresql/data

      # Bind Mount: 호스트 폴더를 컨테이너에 연결
      - ./data:/app/data            # 현재폴더/data → 컨테이너/app/data
      - ./config.yml:/app/config.yml:ro   # :ro = 읽기 전용

volumes:
  db_data:          # Named Volume은 여기에 선언 필수
```

**Named Volume vs Bind Mount:**

| | Named Volume | Bind Mount |
|---|---|---|
| 선언 | `volumes:` 섹션에 정의 | 호스트 경로 직접 지정 |
| 용도 | DB 데이터 등 영속 데이터 | 소스코드, 설정파일 공유 |
| 관리 | Docker가 관리 | 사용자가 직접 관리 |
| 예시 | `db_data:/var/lib/...` | `./src:/app/src` |

### 3-5. 의존성 (depends_on)

```yaml
services:
  app:
    depends_on:
      - neo4j                 # 단순 의존: neo4j 시작 후 app 시작
      - redis

  langfuse:
    depends_on:
      langfuse-db:
        condition: service_healthy   # DB가 healthy 될 때까지 대기
      redis:
        condition: service_healthy
```

**condition 종류:**
- `service_started` — 컨테이너가 시작되면 바로 (기본값)
- `service_healthy` — healthcheck 통과할 때까지 대기 (권장)

### 3-6. 헬스체크 (healthcheck)

```yaml
services:
  postgres:
    image: postgres:17-alpine
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U myuser"]
      interval: 5s      # 5초마다 체크
      timeout: 5s        # 5초 안에 응답 없으면 실패
      retries: 5         # 5번 연속 실패 시 unhealthy

  redis:
    image: redis:7-alpine
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 5s
      timeout: 5s
      retries: 5
```

### 3-7. 컨테이너 이름 & 재시작 정책

```yaml
services:
  app:
    container_name: my-app        # 컨테이너 이름 고정 (없으면 자동 생성)
    restart: unless-stopped       # 재시작 정책
```

**restart 옵션:**

| 값 | 동작 |
|---|---|
| `no` | 재시작 안 함 (기본값) |
| `always` | 항상 재시작 (Docker 재시작 시에도) |
| `unless-stopped` | 수동 중지 전까지 항상 재시작 |
| `on-failure` | 에러로 종료된 경우만 재시작 |

### 3-8. 프로파일 (profiles)

특정 서비스를 평소에는 실행하지 않고, 필요할 때만 실행:

```yaml
services:
  app:
    image: my-app              # profiles 없음 → 항상 실행

  loader:
    image: my-loader
    profiles:
      - loader                 # --profile loader 줘야만 실행

  test:
    image: my-test
    profiles:
      - test                   # --profile test 줘야만 실행
```

```bash
docker compose up -d                     # app만 실행
docker compose --profile loader up loader  # loader도 함께 실행
docker compose --profile test up test      # test도 함께 실행
```

### 3-9. 네트워크

```yaml
services:
  app:
    networks:
      - frontend
      - backend

  db:
    networks:
      - backend          # db는 backend에만 → app만 접근 가능

networks:
  frontend:
  backend:
```

> **참고:** networks를 생략하면 `프로젝트명_default` 네트워크가 자동 생성되어 모든 서비스가 서로 통신 가능합니다. 대부분의 경우 생략해도 됩니다.

---

## 4. 실전 예시: 최소 웹앱 + DB

```yaml
version: "3.8"

services:
  web:
    build: .
    container_name: my-web
    ports:
      - "3000:3000"
    environment:
      - DATABASE_URL=postgresql://admin:secret@db:5432/myapp
    depends_on:
      db:
        condition: service_healthy

  db:
    image: postgres:17-alpine
    container_name: my-db
    environment:
      POSTGRES_USER: admin
      POSTGRES_PASSWORD: secret
      POSTGRES_DB: myapp
    volumes:
      - pg_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U admin"]
      interval: 5s
      timeout: 5s
      retries: 5

volumes:
  pg_data:
```

---

## 5. 자주 쓰는 명령어 모음

### 기본 명령어

```bash
# 서비스 시작
docker compose up -d                  # 백그라운드 실행
docker compose up -d --build          # 이미지 다시 빌드 후 실행
docker compose up -d app neo4j        # 특정 서비스만 실행

# 서비스 중지
docker compose down                   # 중지 + 컨테이너 삭제
docker compose down -v                # 중지 + 컨테이너 + 볼륨 삭제 ⚠️
docker compose stop                   # 중지만 (컨테이너 유지)

# 재시작
docker compose restart                # 전체 재시작
docker compose restart app            # 특정 서비스 재시작
```

### 상태 확인

```bash
docker compose ps                     # 컨테이너 상태 목록
docker compose ps -a                  # 중지된 것까지 포함
docker compose top                    # 각 컨테이너의 프로세스 목록
```

### 로그 확인

```bash
docker compose logs                   # 전체 로그
docker compose logs app               # 특정 서비스 로그
docker compose logs -f app            # 실시간 로그 (tail -f)
docker compose logs --tail 50 app     # 마지막 50줄만
docker compose logs -f app neo4j      # 여러 서비스 동시에
```

### 컨테이너 내부 접속

```bash
# 컨테이너 안에서 쉘 실행
docker compose exec app bash          # bash 접속
docker compose exec app sh            # sh 접속 (alpine 등 bash 없는 경우)
docker compose exec db psql -U admin  # DB 클라이언트 직접 실행

# 일회성 명령 실행
docker compose exec app python manage.py migrate
docker compose exec neo4j cypher-shell -u neo4j -p password
```

### 빌드 관련

```bash
docker compose build                  # 전체 빌드
docker compose build app              # 특정 서비스만 빌드
docker compose build --no-cache app   # 캐시 없이 처음부터 빌드
docker compose pull                   # 원격 이미지 최신 버전 pull
```

### 스케일링

```bash
docker compose up -d --scale worker=3   # worker 서비스를 3개 인스턴스로 실행
```

> container_name이 설정된 서비스는 스케일링 불가 (이름 충돌)

---

## 6. 유용한 패턴

### 패턴 1: 개발용 override 파일

기본 설정과 개발 전용 설정을 분리:

```
docker-compose.yml           # 기본 (운영 환경)
docker-compose.override.yml  # 개발 전용 (자동 병합됨)
```

```yaml
# docker-compose.override.yml (개발용)
services:
  app:
    volumes:
      - ./src:/app/src          # 소스코드 실시간 반영
    environment:
      - DEBUG=true
```

`docker compose up` 실행 시 두 파일이 자동으로 병합됩니다.

### 패턴 2: 환경별 파일 분리

```bash
# 개발 환경
docker compose -f docker-compose.yml -f docker-compose.dev.yml up -d

# 운영 환경
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

### 패턴 3: .env로 Compose 변수 제어

```env
# .env
POSTGRES_VERSION=17-alpine
APP_PORT=8080
```

```yaml
# docker-compose.yml
services:
  db:
    image: postgres:${POSTGRES_VERSION}
  app:
    ports:
      - "${APP_PORT}:3000"
```

---

## 7. 자주 하는 실수 & 주의사항

### 포트 충돌

```
Error: Bind for 0.0.0.0:3000 failed: port is already allocated
```

→ 호스트에서 이미 해당 포트를 사용 중. 호스트 포트(왼쪽)를 변경:

```yaml
ports:
  - "3001:3000"     # 3001로 변경
```

### depends_on은 "준비 완료"를 보장하지 않음

```yaml
depends_on:
  - db       # db 컨테이너가 "시작"되면 진행 (DB가 준비된 건 아님!)
```

→ `condition: service_healthy` + `healthcheck` 조합을 사용:

```yaml
depends_on:
  db:
    condition: service_healthy
```

### 볼륨 데이터 날리는 실수

```bash
docker compose down      # ✅ 안전: 컨테이너만 삭제, 데이터 유지
docker compose down -v   # ⚠️ 위험: 볼륨(데이터)까지 전부 삭제
```

### environment에서 숫자 값

```yaml
environment:
  REDIS_PORT: 6379        # ⚠️ YAML이 숫자로 해석할 수 있음
  REDIS_PORT: "6379"      # ✅ 문자열로 명시
```

### 컨테이너 간 통신은 서비스명 사용

```yaml
# ❌ 잘못된 방법
environment:
  - DB_HOST=localhost          # 컨테이너 안에서 localhost는 자기 자신

# ✅ 올바른 방법
environment:
  - DB_HOST=db                 # docker-compose.yml의 서비스 이름
```

---

## 8. 명령어 빠른 참조표

| 하고 싶은 것 | 명령어 |
|---|---|
| 전체 시작 | `docker compose up -d` |
| 빌드 후 시작 | `docker compose up -d --build` |
| 전체 중지 | `docker compose down` |
| 상태 확인 | `docker compose ps` |
| 로그 보기 | `docker compose logs -f 서비스명` |
| 컨테이너 접속 | `docker compose exec 서비스명 bash` |
| 특정 서비스 재시작 | `docker compose restart 서비스명` |
| 이미지 새로 빌드 | `docker compose build --no-cache` |
| 데이터 포함 완전 초기화 | `docker compose down -v` |
| 설정 검증 | `docker compose config` |
