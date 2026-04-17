"""
IDE 연동 예제 클라이언트
API 서버(main.py)에 HTTP 요청을 보내는 방법을 보여줍니다.
"""

import httpx
import json


BASE_URL = "http://localhost:8000"


def run_streaming(message: str, agent: str = None):
    """SSE 스트리밍으로 실시간 출력 받기"""
    payload = {
        "message": message,
        "stream": True,
        "auto_approve": True,
    }
    if agent:
        payload["agent"] = agent

    print(f"▶ Running: {message!r}\n")
    with httpx.stream("POST", f"{BASE_URL}/run", json=payload, timeout=120) as r:
        for line in r.iter_lines():
            if line.startswith("data: "):
                event = json.loads(line[6:])
                if event["type"] == "output":
                    print(event["text"])
                elif event["type"] == "error" and event["text"]:
                    print(f"[stderr] {event['text']}")
                elif event["type"] == "done":
                    print(f"\n✓ exit_code={event['exit_code']}")


def run_blocking(message: str, agent: str = None) -> dict:
    """논-스트리밍: 완료 후 전체 결과 반환"""
    payload = {"message": message, "stream": False, "auto_approve": True}
    if agent:
        payload["agent"] = agent

    r = httpx.post(f"{BASE_URL}/run", json=payload, timeout=120)
    r.raise_for_status()
    return r.json()


def list_agents() -> list:
    r = httpx.get(f"{BASE_URL}/agents")
    r.raise_for_status()
    return r.json()["agents"]


def list_threads() -> list:
    r = httpx.get(f"{BASE_URL}/threads")
    r.raise_for_status()
    return r.json()["threads"]


if __name__ == "__main__":
    # 1) 사용 가능한 에이전트 목록 확인
    print("=== Agents ===")
    try:
        print(list_agents())
    except Exception as e:
        print(f"  (error: {e})")

    # 2) 스트리밍으로 간단한 작업 실행
    print("\n=== Streaming run ===")
    run_streaming("List the files in the current directory", agent="coder")

    # 3) 블로킹으로 실행
    print("\n=== Blocking run ===")
    result = run_blocking("What is 2+2?")
    print(result["output"])
