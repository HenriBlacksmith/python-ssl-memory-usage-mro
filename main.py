import httpx
import asyncio


async def _main() -> None:
    while True:
        async with httpx.AsyncClient() as client:
            await client.request("GET", "https://example.com/")
        await asyncio.sleep(1)


if __name__ == "__main__":
    asyncio.run(_main())
