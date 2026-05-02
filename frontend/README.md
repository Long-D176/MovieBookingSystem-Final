# Frontend Directory

This folder contains the user-facing web application for CineWorld.

## What is inside

- `index.html` - customer home page.
- `login.html` - login form.
- `register.html` - account registration page.
- `forgot-password.html` and `reset-password.html` - password recovery flow.
- `booking.html` - seat selection and ticket booking page.
- `payment.html` - payment step of the booking flow.
- `history.html` - booking history and ticket tracking.
- `admin.html` - admin dashboard interface.
- `scanner.html` - staff ticket scanner page.
- `verify.html` - ticket verification page.
- `app.js` - frontend logic and API calls.
- `style.css` - global styling.
- `default.conf` - Nginx configuration for serving the frontend.

## How it works

The frontend is a static web app served by Nginx. It consumes backend APIs exposed by the microservices and handles user interaction in the browser.

## How to use

1. Build or start the frontend container from the root deployment setup.
2. Open the web app in the browser through the configured frontend port.
3. Use the login and booking pages to test the customer flow.
4. Use the admin and scanner pages for staff workflows.

## Notes

- Update `app.js` when API endpoints or request formats change.
- Update `style.css` when UI or layout changes are needed.
- Keep HTML pages small and focused on one workflow each.
