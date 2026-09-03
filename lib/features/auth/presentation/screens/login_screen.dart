import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/simats_colors.dart';
import '../../../../app/theme/simats_text_styles.dart';
import '../../../../app/theme/simats_spacing.dart';
import '../../../../app/config/app_config.dart';
import '../../../../core/auth/biometric_auth_service.dart';
import '../providers/auth_provider.dart';
import '../../../../shared/models/enums.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _idCtrl = TextEditingController(text: 'student@simats.edu');
  final _passCtrl = TextEditingController(text: 'simats123');
  bool _obscure = true;
  UserRole _selectedRole = UserRole.student;
  bool _isAuthenticatingBiometrics = false;
  late AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _idCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _onRoleChanged(UserRole role) {
    setState(() {
      _selectedRole = role;
      switch (role) {
        case UserRole.student:
          _idCtrl.text = 'student@simats.edu';
          break;
        case UserRole.faculty:
          _idCtrl.text = 'abisha@simats.edu.in';
          break;
        case UserRole.securityAdmin:
        case UserRole.superAdmin:
          _idCtrl.text = 'admin@simats.edu';
          break;
      }
    });
  }

  String _selectedRoleTitle() {
    return switch (_selectedRole) {
      UserRole.faculty => 'Faculty',
      UserRole.securityAdmin || UserRole.superAdmin => 'Admin',
      _ => 'Student',
    };
  }

  Future<void> _handleBiometricAuth() async {
    if (_isAuthenticatingBiometrics) return;
    setState(() => _isAuthenticatingBiometrics = true);

    final bioService = ref.read(biometricServiceProvider);
    final roleName = _selectedRoleTitle();

    final status = await bioService.authenticate(roleTitle: roleName);

    if (status == BiometricAuthStatus.success) {
      await ref.read(authProvider.notifier).loginWithBiometrics(_selectedRole);
    } else if (status == BiometricAuthStatus.notEnrolled) {
      if (mounted) {
        _showEnrollmentFallbackDialog(roleName);
      }
    } else if (status == BiometricAuthStatus.canceled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Biometric authentication canceled.'),
            backgroundColor: SimatsColors.primary,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      if (mounted) {
        _showEnrollmentFallbackDialog(roleName);
      }
    }

    if (mounted) setState(() => _isAuthenticatingBiometrics = false);
  }

  void _showEnrollmentFallbackDialog(String roleName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: SimatsColors.surface,
        title: Row(
          children: [
            const Icon(Icons.fingerprint_rounded, color: SimatsColors.secondary),
            const SizedBox(width: 8),
            Text('Biometric Authentication', style: SimatsTextStyles.headlineSm),
          ],
        ),
        content: Text(
          'Device biometrics not registered or currently unavailable. Would you like to use Quick Demo Sign-In as $roleName or enter your password?',
          style: SimatsTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Use Password'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await ref
                  .read(authProvider.notifier)
                  .loginWithBiometrics(_selectedRole);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: SimatsColors.secondary,
              foregroundColor: SimatsColors.onSecondary,
            ),
            child: Text('Quick Demo $roleName Sign In'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await ref
        .read(authProvider.notifier)
        .login(identifier: _idCtrl.text.trim(), password: _passCtrl.text);
  }

  void _navigate(AuthState next, BuildContext ctx) {
    if (next is! AuthAuthenticated) return;
    final role = next.session.user!.role;
    if (role == UserRole.faculty) {
      ctx.go('/faculty/dashboard');
      return;
    }
    if (role == UserRole.securityAdmin || role == UserRole.superAdmin) {
      ctx.go('/security/dashboard');
      return;
    }
    ctx.go('/student/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState is AuthLoading || _isAuthenticatingBiometrics;
    final error = authState is AuthError ? authState.failure.message : null;
    ref.listen<AuthState>(authProvider, (_, next) => _navigate(next, context));

    final roleTitle = _selectedRoleTitle();

    return Scaffold(
      backgroundColor: SimatsColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: SimatsSpacing.marginMobile,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: SimatsSpacing.spaceLg),
                _buildHeader(),
                const SizedBox(height: SimatsSpacing.spaceBase),

                // ── 1. Role Tabs Selector (Student / Faculty / Admin) ─────────
                _buildRoleSelector(),
                const SizedBox(height: SimatsSpacing.spaceBase),

                // ── 2. Prominent Biometric / Fingerprint Scanner Card ─────────
                _buildBiometricCard(isLoading, roleTitle),
                const SizedBox(height: SimatsSpacing.spaceBase),

                // ── Divider ───────────────────────────────────────────────────
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: SimatsSpacing.spaceBase,
                      ),
                      child: Text(
                        'OR USE PASSWORD',
                        style: SimatsTextStyles.labelSm.copyWith(
                          color: SimatsColors.outline,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: SimatsSpacing.spaceBase),

                if (error != null) _buildErrorBanner(error),

                // ── ID Field ──────────────────────────────────────────────────
                TextFormField(
                  controller: _idCtrl,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Institutional Email / ID',
                    prefixIcon: Icon(Icons.badge_outlined, size: 20),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Please enter your ID or email'
                      : null,
                ),
                const SizedBox(height: SimatsSpacing.spaceSm),

                // ── Password Field ────────────────────────────────────────────
                TextFormField(
                  controller: _passCtrl,
                  obscureText: _obscure,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscure
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 20,
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  validator: (v) => (v == null || v.length < 4)
                      ? 'Password must be at least 4 characters'
                      : null,
                ),
                const SizedBox(height: SimatsSpacing.spaceBase),

                // ── Standard Password Sign In Button ──────────────────────────
                SizedBox(
                  height: SimatsSpacing.buttonHeight,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SimatsColors.surfaceContainerHigh,
                      foregroundColor: SimatsColors.primary,
                      elevation: 0,
                      side: const BorderSide(color: SimatsColors.outlineVariant),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: SimatsColors.primary,
                            ),
                          )
                        : Text('Sign In with Password as $roleTitle'),
                  ),
                ),
                const SizedBox(height: SimatsSpacing.spaceXl),
                _buildFooter(),
                const SizedBox(height: SimatsSpacing.spaceBase),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() => Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [SimatsColors.primary, Color(0xFF1E3A66)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: SimatsColors.primary.withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'S',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: SimatsColors.onPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(height: SimatsSpacing.spaceSm),
          Text(AppConstants.appName, style: SimatsTextStyles.headlineLg),
          const SizedBox(height: 2),
          Text(
            AppConstants.appTagline,
            style: SimatsTextStyles.bodyMd.copyWith(
              color: SimatsColors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 3,
            ),
            decoration: BoxDecoration(
              color: SimatsColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(9999),
            ),
            child: Text(
              AppConstants.institutionAccreditation,
              style: SimatsTextStyles.labelSm.copyWith(
                color: SimatsColors.secondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      );

  Widget _buildRoleSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Portal Account',
          style: SimatsTextStyles.labelLg.copyWith(
            color: SimatsColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: SimatsSpacing.spaceXs),
        Row(
          children: [
            _roleTile(
              role: UserRole.student,
              title: 'Student',
              icon: Icons.school_rounded,
            ),
            const SizedBox(width: SimatsSpacing.spaceXs),
            _roleTile(
              role: UserRole.faculty,
              title: 'Faculty',
              icon: Icons.person_search_rounded,
            ),
            const SizedBox(width: SimatsSpacing.spaceXs),
            _roleTile(
              role: UserRole.securityAdmin,
              title: 'Admin',
              icon: Icons.security_rounded,
            ),
          ],
        ),
      ],
    );
  }

  Widget _roleTile({
    required UserRole role,
    required String title,
    required IconData icon,
  }) {
    final isSelected = _selectedRole == role ||
        (_selectedRole == UserRole.superAdmin && role == UserRole.securityAdmin);

    return Expanded(
      child: InkWell(
        onTap: () => _onRoleChanged(role),
        borderRadius: BorderRadius.circular(SimatsRadius.md),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? SimatsColors.primary : SimatsColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(SimatsRadius.md),
            border: Border.all(
              color: isSelected ? SimatsColors.primary : SimatsColors.outlineVariant,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: SimatsColors.primary.withValues(alpha: 0.18),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? SimatsColors.onPrimary : SimatsColors.primary,
                size: 22,
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: SimatsTextStyles.labelMd.copyWith(
                  color: isSelected ? SimatsColors.onPrimary : SimatsColors.onSurface,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBiometricCard(bool isLoading, String roleTitle) {
    return Container(
      padding: const EdgeInsets.all(SimatsSpacing.spaceBase),
      decoration: BoxDecoration(
        color: SimatsColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(SimatsRadius.lg),
        border: Border.all(
          color: SimatsColors.secondary.withValues(alpha: 0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: SimatsColors.secondary.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Pulsating fingerprint icon badge
              AnimatedBuilder(
                animation: _pulseCtrl,
                builder: (_, child) {
                  return Transform.scale(
                    scale: 1.0 + (_pulseCtrl.value * 0.08),
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: SimatsColors.secondary.withValues(
                          alpha: 0.12 + (_pulseCtrl.value * 0.08),
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: SimatsColors.secondary.withValues(
                            alpha: 0.3 + (_pulseCtrl.value * 0.3),
                          ),
                          width: 1.5,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.fingerprint_rounded,
                          color: SimatsColors.secondary,
                          size: 30,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: SimatsSpacing.spaceSm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Phone Biometric / Fingerprint',
                      style: SimatsTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: SimatsColors.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Scan fingerprint or face to open $roleTitle Portal',
                      style: SimatsTextStyles.bodySm.copyWith(
                        color: SimatsColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: SimatsSpacing.spaceBase),
          SizedBox(
            width: double.infinity,
            height: SimatsSpacing.buttonHeight,
            child: ElevatedButton.icon(
              onPressed: isLoading ? null : _handleBiometricAuth,
              icon: const Icon(Icons.fingerprint_rounded, size: 22),
              label: Text(
                isLoading
                    ? 'Checking Sensors...'
                    : 'Scan Fingerprint as $roleTitle',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: SimatsColors.primary,
                foregroundColor: SimatsColors.onPrimary,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SimatsRadius.md),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBanner(String error) => Padding(
        padding: const EdgeInsets.only(bottom: SimatsSpacing.spaceSm),
        child: Container(
          padding: const EdgeInsets.all(SimatsSpacing.spaceSm),
          decoration: BoxDecoration(
            color: SimatsColors.errorContainer,
            borderRadius: BorderRadius.circular(SimatsSpacing.spaceSm),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 18,
                color: SimatsColors.error,
              ),
              const SizedBox(width: SimatsSpacing.spaceXs),
              Expanded(
                child: Text(
                  error,
                  style: SimatsTextStyles.bodySm.copyWith(
                    color: SimatsColors.onErrorContainer,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildFooter() => Column(
        children: [
          const Divider(),
          const SizedBox(height: SimatsSpacing.spaceXs),
          Text(
            AppConstants.institutionName,
            style: SimatsTextStyles.labelMd.copyWith(
              color: SimatsColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            AppConstants.institutionAddress,
            style: SimatsTextStyles.bodySm,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            AppConstants.institutionPhone,
            style: SimatsTextStyles.labelSm.copyWith(color: SimatsColors.secondary),
          ),
        ],
      );
}
