<template>
  <div>
    <h1>Nuxt 3 Environment Variables Test</h1>
    <p><strong>Public API URL (Client/Server):</strong> {{ publicApiUrl }}</p>
    <p><strong>API Secret (Server only):</strong> {{ apiSecret || 'Not accessible on client side' }}</p>
  </div>
</template>

<script setup>
// Import the runtimeConfig composable
const config = useRuntimeConfig()

// Extract public and server-side environment variables
const publicApiUrl = config.public.apiUrl // Accessible on client and server
const apiSecret = process.client ? null : config.apiSecret // Only accessible on server-side
</script>
