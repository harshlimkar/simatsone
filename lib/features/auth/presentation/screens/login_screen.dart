import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "../../../../app/theme/simats_colors.dart";
import "../../../../app/theme/simats_text_styles.dart";
import "../../../../app/theme/simats_spacing.dart";
import "../../../../app/config/app_config.dart";
import "../providers/auth_provider.dart";
import "../../../../shared/models/enums.dart";

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  @override
  void dispose() {
    _idCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
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
      ctx.go("/faculty/dashboard");
      return;
    }
    if (role == UserRole.securityAdmin || role == UserRole.superAdmin) {
      ctx.go("/security/dashboard");
      return;
    }
    ctx.go("/student/dashboard");
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState is AuthLoading;
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
                const SizedBox(height: SimatsSpacing.space3xl),
                _buildHeader(),
                const SizedBox(height: SimatsSpacing.spaceXl),
                _buildDemoHints(),
                const SizedBox(height: SimatsSpacing.spaceBase),
                if (error != null) _buildErrorBanner(error),
                TextFormField(
                  controller: _idCtrl,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: "Student ID / Faculty ID / Email",
                    prefixIcon: Icon(Icons.badge_outlined, size: 20),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? "Please enter your ID or email"
                      : null,
                ),
                const SizedBox(height: SimatsSpacing.spaceSm),
                TextFormField(
                  controller: _passCtrl,
                  obscureText: _obscure,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: const Icon(
                      Icons.lock_outline_rounded,
                      size: 20,
                    ),
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
                      ? "Password must be at least 4 characters"
                      : null,
                ),
                const SizedBox(height: SimatsSpacing.spaceBase),
                SizedBox(
                  height: SimatsSpacing.buttonHeight,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _submit,
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: SimatsColors.onPrimary,
                            ),
                          )
                        : const Text("Sign In to SIMATS ONE"),
                  ),
                ),
                const SizedBox(height: SimatsSpacing.space2xl),
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
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: SimatsColors.primaryContainer,
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: Text(
            "S",
            style: TextStyle(
              fontFamily: "Inter",
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
          ),
        ),
      ),
    ],
  );

  Widget _buildDemoHints() => Container(
    padding: const EdgeInsets.all(SimatsSpacing.spaceSm),
    decoration: BoxDecoration(
      color: SimatsColors.surfaceContainerLow,
      borderRadius: BorderRadius.circular(SimatsSpacing.spaceSm),
      border: Border.all(color: SimatsColors.outlineVariant),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Demo Mode — try:",
          style: SimatsTextStyles.labelMd.copyWith(
            color: SimatsColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: SimatsSpacing.spaceXs),
        Text(
          "• Any ID → Student  |  ID with faculty → Faculty",
          style: SimatsTextStyles.bodySm,
        ),
        Text(
          "• ID with security → Security Admin  |  Password: 4+ chars",
          style: SimatsTextStyles.bodySm,
        ),
      ],
    ),
  );

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
