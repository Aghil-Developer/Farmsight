import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme.dart';

class SettingsPage extends StatefulWidget {
  final VoidCallback onLogout;
  final bool isDarkMode;
  final Function(bool) onToggleDarkMode;

  const SettingsPage({
    super.key,
    required this.onLogout,
    required this.isDarkMode,
    required this.onToggleDarkMode,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool darkMode;
  String username = "Aghil";

  @override
  void initState() {
    super.initState();
    darkMode = widget.isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 12),

        
        Container(
          decoration: BoxDecoration(
            gradient: FarmColors.drawerHeaderGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: FarmColors.primary.withValues(alpha: 0.25),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 3),
                  ),
                  child: CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    child: Text(
                      username.isNotEmpty ? username[0].toUpperCase() : 'U',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        style: GoogleFonts.playfairDisplay(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tap pencil to edit profile',
                        style: GoogleFonts.nunito(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.edit_rounded, color: Colors.white, size: 22),
                    onPressed: () async {
                      String? newName = await showDialog<String>(
                        context: context,
                        builder: (context) {
                          final controller = TextEditingController();
                          return AlertDialog(
                            title: const Text("Edit Profile"),
                            content: TextField(
                              controller: controller,
                              decoration: const InputDecoration(labelText: "New Username"),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  "Cancel",
                                  style: GoogleFonts.nunito(fontWeight: FontWeight.w600),
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, controller.text),
                                child: Text(
                                  "Save",
                                  style: GoogleFonts.nunito(fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                      if (newName != null && newName.isNotEmpty) {
                        setState(() => username = newName);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Username changed to $username")),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 28),

        
        _buildSectionLabel('Appearance', Icons.palette_rounded, isDark),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: isDark ? FarmColors.cardDark : FarmColors.cardLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark
                  ? FarmColors.primaryLight.withValues(alpha: 0.12)
                  : FarmColors.primaryLight.withValues(alpha: 0.15),
            ),
            boxShadow: [
              BoxShadow(
                color: (isDark ? Colors.black : FarmColors.primary).withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SwitchListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            title: Text(
              'Dark Mode',
              style: GoogleFonts.nunito(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: isDark ? FarmColors.textPrimaryDark : FarmColors.textPrimary,
              ),
            ),
            subtitle: Text(
              'Toggle between light and dark theme',
              style: GoogleFonts.nunito(
                fontSize: 13,
                color: isDark ? FarmColors.textSecondaryDark : FarmColors.textSecondary,
              ),
            ),
            value: darkMode,
            onChanged: (val) {
              setState(() => darkMode = val);
              widget.onToggleDarkMode(val);
            },
            secondary: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark
                    ? FarmColors.primaryLight.withValues(alpha: 0.12)
                    : FarmColors.primarySurface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                color: isDark ? FarmColors.primaryLight : FarmColors.primary,
                size: 22,
              ),
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),

        const SizedBox(height: 28),

        
        _buildSectionLabel('Account', Icons.person_rounded, isDark),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: isDark ? FarmColors.cardDark : FarmColors.cardLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark
                  ? FarmColors.primaryLight.withValues(alpha: 0.12)
                  : FarmColors.primaryLight.withValues(alpha: 0.15),
            ),
            boxShadow: [
              BoxShadow(
                color: (isDark ? Colors.black : FarmColors.primary).withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDark
                        ? FarmColors.primaryLight.withValues(alpha: 0.12)
                        : FarmColors.primarySurface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.exit_to_app_rounded,
                    color: isDark ? FarmColors.primaryLight : FarmColors.primary,
                    size: 22,
                  ),
                ),
                title: Text(
                  'Logout',
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: isDark ? FarmColors.textPrimaryDark : FarmColors.textPrimary,
                  ),
                ),
                subtitle: Text(
                  'Sign out of your account',
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    color: isDark ? FarmColors.textSecondaryDark : FarmColors.textSecondary,
                  ),
                ),
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: isDark ? FarmColors.textSecondaryDark : FarmColors.textSecondary,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                onTap: () {
                  widget.onLogout();
                },
              ),
              Divider(
                height: 1,
                indent: 16,
                endIndent: 16,
                color: isDark
                    ? FarmColors.primaryLight.withValues(alpha: 0.1)
                    : FarmColors.primary.withValues(alpha: 0.08),
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: FarmColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    color: FarmColors.error,
                    size: 22,
                  ),
                ),
                title: Text(
                  'Delete Account',
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: FarmColors.error,
                  ),
                ),
                subtitle: Text(
                  'Permanently remove your data',
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    color: isDark ? FarmColors.textSecondaryDark : FarmColors.textSecondary,
                  ),
                ),
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: isDark ? FarmColors.textSecondaryDark : FarmColors.textSecondary,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Delete account clicked")),
                  );
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 40),

        
        Center(
          child: Text(
            'FarmSight v0.1.0',
            style: GoogleFonts.nunito(
              fontSize: 12,
              color: isDark ? FarmColors.textSecondaryDark : FarmColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSectionLabel(String title, IconData icon, bool isDark) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: isDark ? FarmColors.primaryLight : FarmColors.primary,
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: GoogleFonts.playfairDisplay(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: isDark ? FarmColors.textPrimaryDark : FarmColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
