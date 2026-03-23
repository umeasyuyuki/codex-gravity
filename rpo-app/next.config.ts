import { initOpenNextCloudflareForDev } from "@opennextjs/cloudflare"
import type { NextConfig } from "next";

if (process.env.NODE_ENV !== "production") {
    // Enable Cloudflare bindings access only during local development.
    // See: https://opennext.js.org/cloudflare/bindings#local-access-to-bindings
    initOpenNextCloudflareForDev()
}

const nextConfig: NextConfig = {
	/* config options here */
};

export default nextConfig;
