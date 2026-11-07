# CloudCart

A locally runnable e-commerce storefront built with React, Vite, Spring Boot 3, Java 21 and PostgreSQL. The API owns authentication, stock validation, cart persistence, order totals and order placement. Checkout is a mock confirmation flow; no payment details are collected.

## Requirements

- Node.js 20+
- Java 21
- PostgreSQL 16+ (Docker is optional)

## Start locally

1. Make sure PostgreSQL is running. Create a database and user, or use an existing local database. Set `DATABASE_URL`, `DATABASE_USER`, and `DATABASE_PASSWORD` in the root `.env` to match it. For example, the URL format is `jdbc:postgresql://localhost:5432/cloudcart`.
2. Set `JWT_SECRET`, `ADMIN_EMAIL`, and `ADMIN_PASSWORD` in `.env`. Use a random JWT secret of at least 32 characters and a long admin password.
3. Start the API in a terminal from the `backend` directory:

   ```powershell
   cd backend
   .\mvnw.cmd spring-boot:run
   ```

Spring Boot loads the root `.env` automatically when launched from `backend`. The wrapper downloads Maven into your Windows user profile on first use, so Maven does not need to be installed globally. The first run creates the tables, seeds eight products, and creates the configured admin account if it does not already exist. To promote a different existing account, update its `role` to `ADMIN` in the `users` table.

4. Start the frontend in a third terminal:

   ```powershell
   cd frontend
   npm install
   npm run dev
   ```

5. Open <http://localhost:5173>. API runs at <http://localhost:8080/api>.

Vite proxies local `/api` requests to the backend during development. Set `VITE_API_URL` only if you need to point the frontend at a different API base. Set `CORS_ORIGIN` in `.env` if calling the backend directly from a different browser origin. Docker Compose remains available as an optional PostgreSQL setup with `docker compose up -d postgres`.

## Available features

- Responsive storefront, collections, product details, search, category filters and price sorting.
- Registration and login with BCrypt password storage and signed JWT authentication.
- Per-user persistent carts, stock-aware quantity updates, and transactional mock order placement.
- Order history and detail pages. Admin dashboard provides revenue, customer, product and order totals, plus order status updates.
- Admin product REST endpoints support product create, update and delete. Restrict admin creation to the configured bootstrap account or promote a registered user through the database.

## API outline

| Method | Path | Access |
| --- | --- | --- |
| POST | `/api/auth/register`, `/api/auth/login` | Public |
| GET | `/api/products`, `/api/products/{id}` | Public |
| POST/PUT/DELETE | `/api/products[/{id}]` | Admin |
| GET/POST | `/api/cart`, `/api/cart/items` | Signed in |
| PUT/DELETE | `/api/cart/items/{id}` | Signed in, own cart |
| GET/POST | `/api/orders`, `/api/orders/{id}` | Signed in, own orders |
| GET | `/api/admin/dashboard`, `/api/admin/orders` | Admin |
| PUT | `/api/admin/orders/{id}/status` | Admin |

Requests after login use `Authorization: Bearer <token>`. Example registration:

```json
{"name":"Taylor Example","email":"taylor@example.com","password":"correct-horse-battery"}
```

Example cart item:

```json
{"productId":1,"quantity":2}
```

## Notes

Hibernate updates the local schema automatically. For production, replace that setting with versioned database migrations, supply secrets through a secret manager, configure TLS, and add payment processing only when ready. No cloud infrastructure is included.
