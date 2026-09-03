# SIMATS ONE — Security Architecture & Guidelines

## 1. Token Storage
- **Zero Local Password Storage**: User passwords are exchanged once for JWT tokens and discarded immediately from memory.
- **Android Keystore Encryption**: Access tokens and refresh tokens are encrypted using AES-256 in `flutter_secure_storage` backed by the hardware-backed Android Keystore.
- **Never in SharedPreferences**: SharedPreferences is strictly reserved for non-sensitive presentation preferences (such as selected timetable day or theme mode).

## 2. Network Security
- **HTTPS Only**: Plain HTTP requests are disallowed.
- **Token Refresh**: Dio `QueuedInterceptor` automatically handles 401 Unauthorized by exchanging the stored refresh token without dropping user state or prompting for re-login.
- **No Sensitive Credential Logging**: Logging interceptor scrubs Authorization headers and request bodies containing sensitive biometric or credential fields.

## 3. Role-Based Access Control (RBAC)
- **Frontend Route Guards**: GoRouter checks `UserRole` before routing to `/student`, `/faculty`, or `/security`.
- **Defense in Depth**: Frontend checks are paired with backend authorization header validation on all protected endpoints.
- **Security Broadcast Protection**: Only verified `SECURITY_ADMIN` or `SUPER_ADMIN` tokens are permitted to hit the `/api/v1/alerts` broadcast endpoint.
