import NextAuth from "next-auth"
import Google from "next-auth/providers/google"
import { getAllowedLoginList } from "@/lib/userAccess"

function sanitizeRedirect(url: string, baseUrl: string) {
    if (url.startsWith("/")) {
        return `${baseUrl}${url}`
    }

    try {
        const target = new URL(url)
        if (target.origin === baseUrl) {
            return url
        }
    } catch {
        // Ignore malformed URL and fallback.
    }

    return `${baseUrl}/applicants`
}

function isLoginAllowedForThisPhase(email: string | null | undefined) {
    const normalized = email?.trim().toLowerCase()
    if (!normalized) {
        return false
    }

    const allowedLogins = getAllowedLoginList()
    if (allowedLogins.length === 0) {
        return true
    }

    return allowedLogins.some((rule) => {
        const normalizedRule = rule.trim().toLowerCase()
        if (!normalizedRule) {
            return false
        }

        if (normalizedRule.startsWith("@")) {
            return normalized.endsWith(normalizedRule)
        }

        return normalized === normalizedRule
    })
}

export const { handlers, auth } = NextAuth({
    providers: [Google],
    session: {
        strategy: "jwt",
    },
    pages: {
        signIn: "/login",
    },
    callbacks: {
        async signIn({ user, account }) {
            if (account?.provider !== "google") {
                return false
            }

            return isLoginAllowedForThisPhase(user.email)
        },
        async jwt({ token, user }) {
            if (user?.id) {
                token.userId = user.id
            } else if (!token.userId) {
                token.userId = token.sub || token.email || "anonymous-user"
            }

            return token
        },
        async session({ session, token }) {
            if (session.user) {
                session.user.id = String(token.userId || token.sub || token.email || "anonymous-user")
            }

            return session
        },
        async redirect({ url, baseUrl }) {
            return sanitizeRedirect(url, baseUrl)
        },
    },
})
