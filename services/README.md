# Services Directory

This folder contains all backend microservices for the CineWorld movie booking system.

## What is inside

- `catalog` - manages movies, cinemas, screens, showtimes, and concessions.
- `booking` - handles seat reservation, booking creation, pricing, and booking lifecycle.
- `identity` - manages authentication, login, registration, and JWT-based security.
- `otp` - generates OTP codes and barcodes.
- `payment` - simulates payment and refund processing.
- `redemption` - validates tickets, scans barcodes, and supports check-in.
- `management` - provides protected admin APIs for dashboards and CRUD operations.
- `scheduler` - runs background jobs such as expiring pending bookings.

## How it works

Each service is designed to run independently in its own container. Services communicate through REST APIs and share the database only where required by the application design.

## How to use

1. Start the services with Docker Compose from the project root.
2. Open each service's Swagger documentation using the ports listed in the root `README.md`.
3. Configure environment variables before running services locally or in production.
4. Update the code inside each service folder when changing business logic.

## Notes

- Keep secrets out of source control.
- Use the service-specific `requirements.txt` files to install Python dependencies.
- Check each service `main.py` file to understand its startup flow and API routes.
