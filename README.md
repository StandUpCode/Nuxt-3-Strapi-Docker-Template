# Nuxt 3 + Strapi Docker Template

## คำอธิบาย

โปรเจกต์นี้เป็น template สำหรับการตั้งค่า Nuxt 3 ที่เชื่อมต่อกับ Strapi โดยการใช้ Docker และ Runtime Environment Variables เพื่อการจัดการ Authentication และการปรับแต่งการทำงานเพิ่มเติม

## การใช้งาน

### การติดตั้ง

1. ติดตั้งโมดูล `@nuxtjs/strapi` ลงในโปรเจกต์ของคุณ:
    ```bash
    npx nuxi@latest module add strapi
    ```

2. เพิ่มโมดูลลงใน `nuxt.config.ts`:
    ```typescript
    // nuxt.config.ts
    export default defineNuxtConfig({
      modules: ['@nuxtjs/strapi'],
      strapi: {
        // ตั้งค่าเพิ่มเติม
      }
    })
    ```

3. ตั้งค่า Docker และ Environment Variables สำหรับ Strapi และ Nuxt

### การตั้งค่า

ค่าเริ่มต้นของ Strapi สามารถตั้งค่าใน `nuxt.config.ts` ดังนี้:
```typescript
export default defineNuxtConfig({
  // การตั้งค่าแยก URL สำหรับ client/server
  runtimeConfig: {
    strapi: {
      url: 'http://localhost:1337'
    },
    public: {
      strapi: {
        url: 'http://localhost:1337'
      }
    }
  }
})
```

### ค่าเริ่มต้น (Defaults)

```json
{
  url: process.env.STRAPI_URL || 'http://localhost:1337',
  prefix: '/api',
  admin: '/admin',
  version: 'v4',
  cookie: {},
  cookieName: 'strapi_jwt'
}
```

#### อธิบายการตั้งค่า:

- **url**: URL ของเซิร์ฟเวอร์ Strapi (สามารถ override ได้โดยใช้ตัวแปรสภาพแวดล้อม `STRAPI_URL`)
- **admin**: Prefix สำหรับ Strapi admin
- **prefix**: Prefix ของ API (ใช้เมื่อเวอร์ชั่นเป็น v4)
- **version**: เวอร์ชั่นของ Strapi (รองรับ v3 หรือ v4)
- **cookie**: การตั้งค่า cookie สำหรับ Strapi token
- **cookieName**: ชื่อของ cookie สำหรับ Strapi token

### การ Authentication

การปรับแต่งการตั้งค่า Authentication ใน Strapi สามารถใช้การตั้งค่าดังนี้:

- **auth.populate**: ตั้งค่า populate query param สำหรับ route `/users/me`
- **auth.fields**: ตั้งค่า fields query param สำหรับ route `/users/me`

### Advanced

#### Nuxt Devtools

รองรับการฝัง Strapi admin เข้ากับ Nuxt Devtools ตั้งแต่เวอร์ชัน `v1.9.0+`

อ่านเพิ่มเติมเกี่ยวกับการใช้งานได้ใน [Devtools documentation](https://nuxtjs.org/docs)

#### การใช้งาน Edge Version

สามารถใช้งาน `@nuxtjs/strapi-edge` สำหรับอัปเดตล่าสุด:
```json
{
  "devDependencies": {
    "@nuxtjs/strapi": "npm:@nuxtjs/strapi-edge@latest"
  }
}
```

จากนั้นรันคำสั่ง `pnpm install`, `yarn install`, หรือ `npm install` เพื่ออัปเดต dependencies

## การใช้งานในโหมด SPA ด้วย Docker

คุณสามารถ build และรันโปรเจกต์ในโหมด SPA (Single Page Application) โดยการใช้ไฟล์ `docker-compose-spa.yaml` ที่กำหนดไว้สำหรับโหมดนี้ โดยไม่ต้องคอมไพล์เป็น SSR (Server-Side Rendering)

### การตั้งค่า `docker-compose-spa.yaml`

สร้างไฟล์ `docker-compose-spa.yaml` และเพิ่มการตั้งค่าตามตัวอย่างด้านล่าง:

```yaml
networks:
  lodashventure:
    driver: bridge

services:
  strapi:
    image: strapi
    container_name: strapi
    restart: always
    build:
      context: ./backend/strapi
    env_file: ./.env
    volumes:
      - ./data:/usr/src/app/data
    ports:
      - 1337:1337
    networks:
      - lodashventure

    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:1337/healthcheck"]
      interval: 1m30s
      timeout: 10s
      retries: 3

  frontend: # service
    container_name: frontend # container name
    image: frontend
    build:
      context: ./frontend/home
      dockerfile: spa.Dockerfile
      args:
        - API_SECRET=mysecretkey # ในโหมดนี้หากต้องการแก้จะต้อง build ใหม่
        - NUXT_PUBLIC_API_URL=https://api.lodashventure.com/v2/223233
    ports:
      - 3000:80
    networks:
      - lodashventure
    env_file:
      - ./.env

```

### คำสั่งที่ใช้ในการ build

1. สร้างไฟล์ `docker-compose-spa.yaml` ใน root directory ของโปรเจกต์
2. รันคำสั่งต่อไปนี้เพื่อเริ่มการ build และรัน Nuxt 3 ในโหมด SPA:

```bash
docker-compose -f docker-compose-spa.yaml up --build
```

ไฟล์นี้จะใช้ Docker เพื่อทำการ build โปรเจกต์ในโหมด SPA และเชื่อมต่อกับ Strapi โดยใช้ URL ที่กำหนดผ่าน environment variable `STRAPI_URL` ซึ่งสามารถปรับได้ตามการตั้งค่าในโปรเจกต์ของคุณ

### ข้อดีของการใช้โหมด SPA

- การใช้งานโหมด SPA ช่วยให้การ build และ deploy แอปพลิเคชันง่ายขึ้นในบางกรณีที่ไม่ต้องการใช้ SSR
- เหมาะสำหรับโปรเจกต์ที่โฟกัสไปที่ฝั่ง client และไม่จำเป็นต้องเรนเดอร์บนเซิร์ฟเวอร์


### การให้บริการแอป SPA ด้วย Nginx vs SSR ด้วย Node.js และความแตกต่างในการโหลด Environment Variables

การให้บริการแอปพลิเคชันมีวิธีการหลักอยู่ 2 วิธี ได้แก่ การให้บริการแอปพลิเคชันแบบ **Single Page Application (SPA)** ด้วย Nginx และการให้บริการแบบ **Server-Side Rendering (SSR)** ด้วย Node.js ซึ่งแต่ละวิธีมีข้อดีข้อเสียต่างกัน โดยเฉพาะในด้านการจัดการ Environment Variables (env) และการเปลี่ยนแปลงตาม Runtime ที่เกิดขึ้นในช่วงการทำงานของแอปพลิเคชัน เรามาอธิบายเป็นลำดับขั้นตอนดังนี้:

---

### 1. การให้บริการ SPA ด้วย Nginx

#### Architecture:
- **Browser** <---> **Nginx** <---> **Static Files (HTML, CSS, JS)**

SPA จะเป็นแอปพลิเคชันที่ทำงานบนฝั่ง Client (Client-Side) ซึ่งหมายความว่าไฟล์ HTML, CSS, และ JavaScript จะถูกสร้างและบรรจุมาในรูปแบบไฟล์สถิต (static) จากการ Build หรือ Compile โดยเครื่องของนักพัฒนาแล้วจากนั้นถูก Deploy บน Server

**ขั้นตอนการทำงานของ Nginx กับ SPA:**
1. เมื่อ Browser ส่งคำขอไปที่ Server (เช่น `/` หรือ `/about`)
2. Nginx จะทำหน้าที่ส่งไฟล์สถิตที่เป็นผลลัพธ์ของแอปพลิเคชัน SPA กลับมา (เช่น index.html)
3. ตัวแอปพลิเคชัน SPA จะทำงานที่ฝั่ง Browser โดยที่ฝั่ง Server ไม่จำเป็นต้องประมวลผลอะไรเพิ่มเติม

#### ข้อดีของการใช้ Nginx กับ SPA:
- การให้บริการแบบ **Cacheable**: ไฟล์ static สามารถเก็บ Cache ได้ง่าย ลดภาระของ Server
- ทำงานเร็วมากหลังจากที่โหลดหน้าแรก

#### ข้อเสียของการใช้ Nginx กับ SPA:
- **Environment Variables จะต้องถูก Build ล่วงหน้า**: เนื่องจากไฟล์ static ถูกสร้างไว้แล้วตอน Build ดังนั้นค่าตัวแปรต่างๆ จะไม่สามารถเปลี่ยนได้ในช่วง Runtime ต้องมีการ Rebuild ใหม่หากมีการเปลี่ยนแปลง Environment Variables

---

### 2. การให้บริการ SSR ด้วย Node.js

#### Architecture:
- **Browser** <---> **Node.js** <---> **Dynamic HTML** (ที่สร้างจาก Server-Side)

Server-Side Rendering (SSR) คือกระบวนการที่ฝั่ง Server ประมวลผลและสร้างหน้า HTML ขึ้นมาตอบสนองคำขอจากฝั่ง Client โดยการเรนเดอร์ที่ฝั่ง Server จะทำให้แอปพลิเคชันตอบสนองเร็วขึ้นและเหมาะกับ SEO มากกว่า SPA

**ขั้นตอนการทำงานของ Node.js กับ SSR:**
1. เมื่อ Browser ส่งคำขอไปที่ Server
2. Node.js จะประมวลผลคำขอนั้นและดึงข้อมูลที่จำเป็นจากฐานข้อมูลหรือ API
3. Server จะเรนเดอร์หน้า HTML ขึ้นมาใหม่ตามคำขอของ Browser และส่งกลับไปให้ผู้ใช้

#### ข้อดีของการใช้ SSR กับ Node.js:
- **Environment Variables โหลดตอน Runtime ได้**: เนื่องจากการเรนเดอร์หน้าเว็บเกิดขึ้นที่ฝั่ง Server ดังนั้น Node.js สามารถเข้าถึง Environment Variables ได้ขณะนั้น (เช่น `process.env`) และสามารถปรับเปลี่ยนค่าตัวแปรได้ทันทีโดยไม่ต้อง Rebuild แอปพลิเคชัน
- **SEO และการโหลดเร็วขึ้น**: เนื่องจากหน้า HTML ถูกสร้างมาจากฝั่ง Server ทำให้เครื่องมือค้นหาสามารถอ่านเนื้อหาของหน้าเว็บได้ทันที

#### ข้อเสียของการใช้ SSR กับ Node.js:
- **โหลดช้ากว่า SPA ในบางกรณี**: เนื่องจาก Server ต้องเรนเดอร์ทุกหน้าที่มีการร้องขอ ทำให้เพิ่มภาระงานให้กับ Server โดยตรง
- **การใช้ทรัพยากร Server สูงกว่า SPA**: เพราะ Server ต้องประมวลผลทุกครั้งที่มีคำขอ

---

### ความแตกต่างหลักระหว่าง SPA และ SSR:

| คุณสมบัติ | SPA (Nginx) | SSR (Node.js) |
|------------|----------------|----------------|
| การทำงานฝั่ง Server | ทำงานเฉพาะการเสิร์ฟไฟล์สถิต | เรนเดอร์และประมวลผลฝั่ง Server |
| SEO | ยากต่อการทำ SEO | ดีต่อการทำ SEO |
| การปรับเปลี่ยน Environment Variables | ต้อง Rebuild ไฟล์สถิตใหม่ | สามารถเปลี่ยนได้ที่ Runtime |
| ความเร็วในการตอบสนอง | เร็วหลังจากโหลดครั้งแรก | เร็วในหน้าแรกสำหรับผู้ใช้ใหม่ |

#### สรุป:
- SPA ด้วย Nginx เหมาะกับแอปที่มีการทำงานที่ต้องการความเร็วและไม่เปลี่ยน Environment บ่อยๆ
- SSR ด้วย Node.js เหมาะสำหรับแอปที่ต้องการปรับเปลี่ยนค่า Runtime และเน้นการทำ SEO หรือการเรนเดอร์เนื้อหาที่เปลี่ยนแปลงบ่อย

