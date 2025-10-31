"""Pytest configuration for browser tests."""

import subprocess
import time
from typing import Generator

import pytest


@pytest.fixture(scope="session")
def lamdera_server() -> Generator[None, None, None]:
    """Start Lamdera server for tests."""
    print("\nPreparing project...")

    print("\nStarting Lamdera server...")
    process = subprocess.Popen(
        ["lamdera", "live"],
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
    )

    # Wait for server to be ready
    max_wait = 15
    start_time = time.time()
    while time.time() - start_time < max_wait:
        try:
            import urllib.request

            urllib.request.urlopen("http://localhost:8000", timeout=1)
            print("Lamdera server ready at http://localhost:8000")
            break
        except Exception:
            time.sleep(0.5)
    else:
        process.kill()
        output, _ = process.communicate()
        print(f"\n=== Lamdera output ===\n{output}")
        raise RuntimeError(f"Lamdera server failed to start within {max_wait} seconds")

    yield

    print("\nStopping Lamdera server...")
    process.terminate()
    try:
        process.wait(timeout=5)
    except subprocess.TimeoutExpired:
        process.kill()
        process.wait()
