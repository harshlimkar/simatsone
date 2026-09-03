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

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idCtrl = TextEditingController(text: 'student@simats.edu');
  final _passCtrl = TextEditingController(text: 'simats123');
  bool _obscure = true;
  UserRole _selectedRole = UserRole.student;
  bool _isAuthenticatingBiometrics = false;

  @override
  void dispose() {
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
          _idCtrl.text = 'faculty@simats.edu';
          break;
        case UserRole.securityAdmin:
        case UserRole.superAdmin:
          _idCtrl.text = 'admin@simats.edu';
          break;
      }
    });
  }

  Future<void> _handleBiometricAuth() async {
    if (_isAuthenticatingBiometrics) return;
    setState(() => _isAuthenticatingBiometrics = true);

    final bioService = ref.read(biometricServiceProvider);
    final isAvailable = await bioService.isBiometricsAvailable();

    String roleName = switch (_selectedRole) {
      UserRole.faculty => 'Faculty',
      UserRole.securityAdmin || UserRole.superAdmin => 'Security Admin',
      _ => 'Student',
    };

    if (isAvailable) {
      final success = await bioService.authenticate(roleTitle: roleName);
      if (success) {
        await ref.read(authProvider.notifier).loginWithBiometrics(_selectedRole);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Biometric authentication canceled or not recognized.'),
              backgroundColor: SimatsColors.primary,
            ),
          );
        }
      }
    } else {
      // Direct demo sign in if biometric hardware is unavailable
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Biometric sensor not enrolled. Signing in as $roleName...'),
            backgroundColor: SimatsColors.primary,
          ),
        );
      }
      await ref.read(authProvider.notifier).loginWithBiometrics(_selectedRole);
    }

    if (mounted) setState(() => _isAuthenticatingBiometrics = false);
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
                const SizedBox(height: SimatsSpacing.spaceXl),
                _buildHeader(),
                const SizedBox(height: SimatsSpacing.spaceLg),

                // ── 1. Role Selection Segment (Student / Faculty / Admin) ───────
                _buildRoleSelector(),
                const SizedBox(height: SimatsSpacing.spaceBase),

                // ── 2. Primary Biometric Fingerprint Action ─────────────────────
                _buildBiometricCard(isLoading),
                const SizedBox(height: SimatsSpacing.spaceBase),

                // ── Divider with Or ──────────────────────────────────────────
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
                    labelText: 'ID / Institutional Email',
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
                        : Text('Sign In with Password as ${_selectedRoleTitle()}'),
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

  String _selectedRoleTitle() {
    return switch (_selectedRole) {
      UserRole.faculty => 'Faculty',
      UserRole.securityAdmin || UserRole.superAdmin => 'Security Admin',
      _ => 'Student',
    };
  }

  Widget _buildHeader() => Column(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: const BoxDecoration(
              color: SimatsColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                'S',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  color: SimatsColors.onPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(height: SimatsSpacing.spaceBase),
          Text(AppConstants.appName, style: SimatsTextStyles.headlineLg),
          const SizedBox(height: SimatsSpacing.space2xs),
          Text(
            AppConstants.appTagline,
            style: SimatsTextStyles.bodyMd.copyWith(
              color: SimatsColors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: SimatsSpacing.spaceXs),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: SimatsSpacing.spaceSm,
              vertical: SimatsSpacing.space2xs,
            ),
            decoration: BoxDecoration(
              color: SimatsColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(9999),
            ),
            child: Text(
              AppConstants.institutionAccreditation,
              style: SimatsTextStyles.labelSm.copyWith(
                color: SimatsColors.secondary,
                fontWeight: FontWeight.w600,
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
          'Select Portal Role',
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
        onTap: () {
          _onRoleChanged(role);
          // Optional: immediately trigger biometric on tap if desired
        },
        borderRadius: BorderRadius.circular(SimatsRadius.md),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            vertical: SimatsSpacing.spaceSm,
            horizontal: 6,
          ),
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
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: SimatsTextStyles.labelMd.copyWith(
                  color: isSelected ? SimatsColors.onPrimary : SimatsColors.onSurface,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBiometricCard(bool isLoading) {
    final roleTitle = _selectedRoleTitle();

    return Container(
      padding: const EdgeInsets.all(SimatsSpacing.spaceBase),
      decoration: BoxDecoration(
        color: SimatsColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(SimatsRadius.lg),
        border: Border.all(color: SimatsColors.secondary.withValues(alpha: 0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: SimatsColors.secondary.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: SimatsColors.secondary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.fingerprint_rounded,
                    color: SimatsColors.secondary,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(width: SimatsSpacing.spaceSm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Biometric & Fingerprint Login',
                      style: SimatsTextStyles.titleMd.copyWith(
                        fontWeight: FontWeight.w700,
                        color: SimatsColors.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Instant access to $roleTitle Portal using phone sensors',
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
                    ? 'Verifying Biometrics...'
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
          const SizedBox(height: SimatsSpacing.space2xs),
          Text(
            AppConstants.institutionAddress,
            style: SimatsTextStyles.bodySm,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: SimatsSpacing.space2xs),
          Text(
            AppConstants.institutionPhone,
            style: SimatsTextStyles.labelSm.copyWith(color: SimatsColors.secondary),
          ),
        ],
      );
}
