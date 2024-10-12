export default defineNuxtConfig({

	compatibilityDate: "2024-04-03",
	devtools: { enabled: true },

	modules: ["@nuxtjs/strapi"],
	strapi: {
		url: process.env.STRAPI_URL || "http://localhost:1337",
		prefix: "/api",
		admin: "/admin",
		version: "v4",
		cookie: {
			path: "/",
			maxAge: 14 * 24 * 60 * 60,
			secure: process.env.NODE_ENV === "production",
			sameSite: true,
		},
		cookieName: "strapi_jwt",
	},
	runtimeConfig: {
		strapi: {
			url: "http://localhost:1337",
		},
		public: {
			apiUrl: process.env.NUXT_PUBLIC_API_URL, // Publicly accessible ใช้สำหรับ url ออกได้
		},
		apiSecret: process.env.API_SECRET, // Only accessible on the server ใช้สำหรับ api key ที่ต้อง private
	},
});
