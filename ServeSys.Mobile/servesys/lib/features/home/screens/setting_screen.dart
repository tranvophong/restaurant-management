import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:servesys/core/utils/appcolor_util.dart';
import 'package:servesys/features/auth/bloc/auth_bloc.dart';
import 'package:servesys/features/auth/bloc/auth_event.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      _buildProfileCard(),
                      const SizedBox(height: 28),
                      _buildSectionLabel('TÀI KHOẢN'),
                      const SizedBox(height: 8),
                      _buildMenuGroup([
                        _buildMenuItem(
                          icon: Icons.person_outline_rounded,
                          label: 'Chỉnh sửa hồ sơ',
                          onTap: () {},
                        ),
                        _buildDivider(),
                        _buildMenuItem(
                          icon: Icons.lock_outline_rounded,
                          label: 'Đổi mật khẩu',
                          onTap: () {},
                        ),
                      ]),
                      const SizedBox(height: 28),
                      _buildSectionLabel('ỨNG DỤNG'),
                      const SizedBox(height: 8),
                      _buildMenuGroup([
                        _buildToggleItem(
                          icon: Icons.notifications_outlined,
                          label: 'Thông báo đẩy',
                          value: _notificationsEnabled,
                          onChanged: (val) =>
                              setState(() => _notificationsEnabled = val),
                        ),
                        _buildDivider(),
                        _buildToggleItem(
                          icon: Icons.nights_stay_outlined,
                          label: 'Chế độ tối',
                          value: _darkModeEnabled,
                          onChanged: (val) =>
                              setState(() => _darkModeEnabled = val),
                        ),
                        _buildDivider(),
                        _buildMenuItem(
                          icon: Icons.language_rounded,
                          label: 'Ngôn ngữ',
                          trailing: const Text(
                            'Tiếng Việt',
                            style: TextStyle(
                              color: AppColors.onSurfaceMuted,
                              fontSize: 14,
                            ),
                          ),
                          onTap: () {},
                        ),
                      ]),
                      const SizedBox(height: 28),
                      _buildSectionLabel('HỖ TRỢ & PHÁP LÝ'),
                      const SizedBox(height: 8),
                      _buildMenuGroup([
                        _buildMenuItem(
                          icon: Icons.help_outline_rounded,
                          label: 'Trung tâm trợ giúp',
                          trailingIcon: Icons.open_in_new_rounded,
                          onTap: () {},
                        ),
                        _buildDivider(),
                        _buildMenuItem(
                          icon: Icons.shield_outlined,
                          label: 'Chính sách bảo mật',
                          onTap: () {},
                        ),
                        _buildDivider(),
                        _buildMenuItem(
                          icon: Icons.description_outlined,
                          label: 'Điều khoản dịch vụ',
                          onTap: () {},
                        ),
                      ]),
                      const SizedBox(height: 32),
                      _buildLogoutButton(context),
                      const SizedBox(height: 16),
                      _buildVersionText(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            child: const Icon(
              Icons.person_rounded,
              color: AppColors.onPrimary,
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nguyễn Văn An',
                style: TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Nhân viên phục vụ',
                style: TextStyle(color: AppColors.onSurfaceMuted, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: AppColors.primary,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildMenuGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Widget? trailing,
    IconData trailingIcon = Icons.chevron_right_rounded,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      splashColor: AppColors.primary.withOpacity(0.08),
      highlightColor: AppColors.primary.withOpacity(0.04),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: AppColors.onSurfaceMuted, size: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (trailing != null) ...[trailing, const SizedBox(width: 4)],
            Icon(trailingIcon, color: AppColors.onSurfaceMuted, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleItem({
    required IconData icon,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: AppColors.onSurfaceMuted, size: 20),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.onSurface,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Transform.scale(
            scale: 0.85,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.onPrimary,
              activeTrackColor: AppColors.primary,
              inactiveThumbColor: AppColors.onSurfaceMuted,
              inactiveTrackColor: AppColors.surfaceElevated,
              trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: AppColors.border,
      indent: 50,
      endIndent: 0,
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: () {
          context.read<AuthBloc>().add(AuthLogoutRequested());
        },
        icon: const Icon(
          Icons.logout_rounded,
          size: 20,
          color: AppColors.onPrimary,
        ),
        label: const Text(
          'Đăng xuất',
          style: TextStyle(
            color: AppColors.onPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  Widget _buildVersionText() {
    return const Center(
      child: Text(
        'SERVESYS V2.4.0',
        style: TextStyle(
          color: AppColors.onSurfaceMuted,
          fontSize: 11,
          letterSpacing: 1.5,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
