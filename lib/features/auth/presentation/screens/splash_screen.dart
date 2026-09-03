import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "../../../../app/theme/simats_colors.dart";
import "../../../../app/theme/simats_text_styles.dart";
import "../../../../app/theme/simats_spacing.dart";
import "../../../../app/config/app_config.dart";
import "../providers/auth_provider.dart";

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});
  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0, 0.6, curve: Curves.easeOut),
      ),
    );
    _scaleAnim = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0, 0.7, curve: Curves.easeOutBack),
      ),
    );
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authProvider, (_, next) {
      if (next is AuthAuthenticated) {
        final role = next.session.user!.role;
        switch (role) {
          case _ when role.name == "faculty":
            context.go("/faculty/dashboard");
            break;
          case _ when role.name == "securityAdmin":
            context.go("/security/dashboard");
            break;
          case _ when role.name == "superAdmin":
            context.go("/security/dashboard");
            break;
          default:
            context.go("/student/dashboard");
        }
      } else if (next is AuthUnauthenticated) {
        context.go("/login");
      }
    });

    return Scaffold(
      backgroundColor: SimatsColors.primary,
      body: SafeArea(
        child: Center(
          child: AnimatedBuilder(
            animation: _ctrl,
            builder: (_, __) => FadeTransition(
              opacity: _fadeAnim,
              child: ScaleTransition(
                scale: _scaleAnim,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo placeholder — replace with official SIMATS logo asset
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: SimatsColors.onPrimary.withOpacity(0.12),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: SimatsColors.onPrimary.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "S",
                          style: SimatsTextStyles.displayLg.copyWith(
                            color: SimatsColors.onPrimary,
                            fontSize: 48,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: SimatsSpacing.spaceBase),
                    Text(
                      AppConstants.appName,
                      style: SimatsTextStyles.displayLg.copyWith(
                        color: SimatsColors.onPrimary,
                      ),
                    ),
                    const SizedBox(height: SimatsSpacing.spaceXs),
                    Text(
                      AppConstants.appTagline,
                      style: SimatsTextStyles.bodyMd.copyWith(
                        color: SimatsColors.onPrimary.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: SimatsSpacing.space3xl),
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: SimatsColors.onPrimary.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: SimatsSpacing.spaceBase),
                    Text(
                      AppConstants.institutionName,
                      style: SimatsTextStyles.labelSm.copyWith(
                        color: SimatsColors.onPrimary.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
