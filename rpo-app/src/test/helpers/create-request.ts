import { NextRequest } from "next/server"
import { TEST_API_KEY } from "./fixtures"

export function createPostRequest(
    path: string,
    body: unknown,
    headers?: Record<string, string>,
): NextRequest {
    return new NextRequest(`http://localhost${path}`, {
        method: "POST",
        headers: {
            "content-type": "application/json",
            "x-rpo-api-key": TEST_API_KEY,
            ...headers,
        },
        body: JSON.stringify(body),
    })
}

export function createGetRequest(
    path: string,
    headers?: Record<string, string>,
): NextRequest {
    return new NextRequest(`http://localhost${path}`, {
        method: "GET",
        headers: {
            "x-rpo-api-key": TEST_API_KEY,
            ...headers,
        },
    })
}

export function createRequestWithoutApiKey(
    path: string,
    method: "GET" | "POST" = "POST",
    body?: unknown,
): NextRequest {
    const init: RequestInit = { method, headers: { "content-type": "application/json" } }
    if (body !== undefined) {
        init.body = JSON.stringify(body)
    }
    return new NextRequest(`http://localhost${path}`, init)
}

export function createRequestWithWrongApiKey(
    path: string,
    method: "GET" | "POST" = "POST",
    body?: unknown,
): NextRequest {
    const init: RequestInit = {
        method,
        headers: {
            "content-type": "application/json",
            "x-rpo-api-key": "wrong-key",
        },
    }
    if (body !== undefined) {
        init.body = JSON.stringify(body)
    }
    return new NextRequest(`http://localhost${path}`, init)
}
