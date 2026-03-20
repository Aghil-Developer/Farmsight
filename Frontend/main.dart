import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';


import 'theme.dart';
import 'settings_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  void toggleDarkMode(bool val) {
    setState(() {
      isDarkMode = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Crop Dashboard',
      theme: FarmTheme.lightTheme,
      darkTheme: FarmTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: DashboardPage(
        isDarkMode: isDarkMode,
        onToggleDarkMode: toggleDarkMode,
      ),
    );
  }
}

class DashboardPage extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onToggleDarkMode;

  const DashboardPage({
    super.key,
    required this.isDarkMode,
    required this.onToggleDarkMode,
  });

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _selectedPage = 'Health Scan';


  final TextEditingController yearController = TextEditingController();
  final TextEditingController rainfallController = TextEditingController();
  final TextEditingController pesticidesController = TextEditingController();
  final TextEditingController tempController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController itemController = TextEditingController();

  
  File? _image;
  String healthResult = '';
  String diseaseResult = '';
  String recommendedPesticide = '';
  String recommendedFertilizer = '';
  String advice = '';
  final picker = ImagePicker();

  
  double yieldResult = 0.0;

  final String baseUrl = "https://aniyah-overanxious-overforwardly.ngrok-free.dev";

  void logout() {
    Fluttertoast.showToast(msg: "Logged out");
  }

  @override


  
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget currentPage;
    if (_selectedPage == 'Health Scan') {
      currentPage = _buildHealthPage(context, isDark);
    } else if (_selectedPage == 'Yield Prediction') {
      currentPage = _buildYieldPage(context, isDark);
    } else {
      currentPage = SettingsPage(
        isDarkMode: widget.isDarkMode,
        onToggleDarkMode: widget.onToggleDarkMode,
        onLogout: logout,
      );
    }

    return Scaffold(
      appBar: _buildAppBar(isDark),
      drawer: _buildDrawer(context, isDark),
      body: currentPage,
    );
  }

  PreferredSizeWidget _buildAppBar(bool isDark) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(70),
      child: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? FarmColors.appBarGradientDark
              : FarmColors.appBarGradient,
          boxShadow: [
            BoxShadow(
              color: FarmColors.primary.withValues(alpha: 0.25),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.eco, color: FarmColors.accent, size: 26),
              const SizedBox(width: 10),
              Text(
                'FarmSight',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: FarmColors.textOnPrimary,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          iconTheme: const IconThemeData(color: FarmColors.textOnPrimary),
        ),
      ),
    );
  }

  
  Widget _buildDrawer(BuildContext context, bool isDark) {
    return Drawer(
      child: Column(
        children: [
          // Drawer Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
            decoration: const BoxDecoration(
              gradient: FarmColors.drawerHeaderGradient,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.agriculture, color: Colors.white, size: 32),
                ),
                const SizedBox(height: 16),
                Text(
                  'FarmSight',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Smart Agriculture Dashboard',
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          
          _buildDrawerItem(
            context,
            icon: Icons.local_florist,
            label: 'Health Scan',
            isSelected: _selectedPage == 'Health Scan',
            isDark: isDark,
          ),
          _buildDrawerItem(
            context,
            icon: Icons.bar_chart_rounded,
            label: 'Yield Prediction',
            isSelected: _selectedPage == 'Yield Prediction',
            isDark: isDark,
          ),
          _buildDrawerItem(
            context,
            icon: Icons.settings_rounded,
            label: 'Settings',
            isSelected: _selectedPage == 'Settings',
            isDark: isDark,
          ),

          const Spacer(),

          
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'FarmSight — Test Application',
              style: GoogleFonts.nunito(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: isDark ? FarmColors.textSecondaryDark : FarmColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isSelected,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: isSelected
            ? (isDark
                ? FarmColors.primaryLight.withValues(alpha: 0.15)
                : FarmColors.primarySurface)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: ListTile(
          leading: Icon(
            icon,
            color: isSelected
                ? (isDark ? FarmColors.primaryLight : FarmColors.primary)
                : (isDark ? FarmColors.textSecondaryDark : FarmColors.textSecondary),
          ),
          title: Text(
            label,
            style: GoogleFonts.nunito(
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              color: isSelected
                  ? (isDark ? FarmColors.primaryLight : FarmColors.primary)
                  : (isDark ? FarmColors.textPrimaryDark : FarmColors.textPrimary),
            ),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          onTap: () {
            setState(() => _selectedPage = label);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  
  Widget _buildHealthPage(BuildContext context, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 12),

          
          _buildSectionHeader(
            icon: Icons.local_florist,
            title: 'Crop Health Scanner',
            subtitle: 'Upload a leaf image to detect diseases',
            isDark: isDark,
          ),

          const SizedBox(height: 24),

         
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? FarmColors.cardDark : FarmColors.cardLight,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark
                    ? FarmColors.primaryLight.withValues(alpha: 0.15)
                    : FarmColors.primaryLight.withValues(alpha: 0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: (isDark ? Colors.black : FarmColors.primary).withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDark
                        ? FarmColors.surfaceDark
                        : FarmColors.primarySurface.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: FarmColors.primaryLight.withValues(alpha: 0.15),
                      strokeAlign: BorderSide.strokeAlignInside,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: _image == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate_outlined,
                                size: 56,
                                color: isDark
                                    ? FarmColors.textSecondaryDark
                                    : FarmColors.textSecondary,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Select a leaf image',
                                style: GoogleFonts.nunito(
                                  fontSize: 14,
                                  color: isDark
                                      ? FarmColors.textSecondaryDark
                                      : FarmColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                        : Image.file(_image!, fit: BoxFit.cover, width: double.infinity),
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        icon: Icons.photo_library_rounded,
                        label: 'Gallery',
                        isDark: isDark,
                        isPrimary: true,
                        onPressed: () async {
                          final pickedFile =
                              await picker.pickImage(source: ImageSource.gallery);
                          if (pickedFile != null) {
                            setState(() {
                              _image = File(pickedFile.path);
                              // Clear previous results when new image selected
                              healthResult = '';
                              diseaseResult = '';
                              recommendedPesticide = '';
                              recommendedFertilizer = '';
                              advice = '';
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildActionButton(
                        icon: Icons.camera_alt_rounded,
                        label: 'Camera',
                        isDark: isDark,
                        isPrimary: false,
                        onPressed: () async {
                          final pickedFile =
                              await picker.pickImage(source: ImageSource.camera);
                          if (pickedFile != null) {
                            setState(() {
                              _image = File(pickedFile.path);
                             
                              healthResult = '';
                              diseaseResult = '';
                              recommendedPesticide = '';
                              recommendedFertilizer = '';
                              advice = '';
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                gradient: FarmColors.buttonGradient,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: FarmColors.primary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.scanner_rounded, size: 20),
                label: Text('Predict Health', style: GoogleFonts.nunito(fontWeight: FontWeight.w700, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () async {
                  if (_image == null) {
                    Fluttertoast.showToast(msg: 'Please select an image');
                    return;
                  }
                  try {
                    var request = http.MultipartRequest(
                      'POST',
                      Uri.parse('$baseUrl/predict_disease'),
                    );
                    request.files.add(
                        await http.MultipartFile.fromPath('file', _image!.path));
                    var response = await request.send();
                    var resString = await response.stream.bytesToString();
                    var jsonRes = jsonDecode(resString);
                    setState(() {
                      healthResult = jsonRes['status'] ?? '';
                      diseaseResult = jsonRes['disease'] ?? '';
                      recommendedPesticide = jsonRes['recommended_pesticide'] ?? '';
                      recommendedFertilizer = jsonRes['recommended_fertilizer'] ?? '';
                      advice = jsonRes['advice'] ?? '';
                    });
                  } catch (e) {
                    Fluttertoast.showToast(msg: 'Error: $e');
                  }
                },
              ),
            ),
          ),

          
          if (healthResult.isNotEmpty) ...[
            const SizedBox(height: 24),
            _buildResultCard(
              icon: healthResult.toLowerCase() == 'healthy'
                  ? Icons.check_circle_rounded
                  : Icons.warning_amber_rounded,
              iconColor: healthResult.toLowerCase() == 'healthy'
                  ? FarmColors.success
                  : FarmColors.secondary,
              title: 'Status: $healthResult',
              subtitle: diseaseResult.isNotEmpty ? 'Disease: $diseaseResult' : null,
              isDark: isDark,
            ),

            
            if (healthResult.toLowerCase() == 'diseased' && recommendedPesticide.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildResultCard(
                icon: Icons.science_rounded,
                iconColor: FarmColors.primary,
                title: 'Recommended Pesticide',
                subtitle: recommendedPesticide,
                isDark: isDark,
              ),
            ],

            if (healthResult.toLowerCase() == 'diseased' && recommendedFertilizer.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildResultCard(
                icon: Icons.grass_rounded,
                iconColor: FarmColors.primary,
                title: 'Recommended Fertilizer',
                subtitle: recommendedFertilizer,
                isDark: isDark,
              ),
            ],

            if (healthResult.toLowerCase() == 'diseased' && advice.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildResultCard(
                icon: Icons.lightbulb_rounded,
                iconColor: FarmColors.accent,
                title: 'Treatment Advice',
                subtitle: advice,
                isDark: isDark,
              ),
            ],

            const SizedBox(height: 8),
            Text(
              'The results may vary with real time',
              style: GoogleFonts.nunito(
                fontSize: 13,
                fontStyle: FontStyle.italic,
                color: isDark ? FarmColors.textSecondaryDark : FarmColors.textSecondary,
              ),
            ),
          ],

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  
  Widget _buildYieldPage(BuildContext context, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 12),

          
          _buildSectionHeader(
            icon: Icons.bar_chart_rounded,
            title: 'Yield Prediction',
            subtitle: 'Enter crop data to estimate production yield',
            isDark: isDark,
          ),

          const SizedBox(height: 24),

          
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? FarmColors.cardDark : FarmColors.cardLight,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark
                    ? FarmColors.primaryLight.withValues(alpha: 0.15)
                    : FarmColors.primaryLight.withValues(alpha: 0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: (isDark ? Colors.black : FarmColors.primary).withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildNumberField('Year', yearController, Icons.calendar_today_rounded),
                _buildNumberField('Average Rainfall (mm/year)', rainfallController, Icons.water_drop_rounded),
                _buildNumberField('Pesticides (tonnes)', pesticidesController, Icons.bug_report_rounded),
                _buildNumberField('Average Temperature (°C)', tempController, Icons.thermostat_rounded),
                _buildTextField('Area', areaController, Icons.map_rounded),
                _buildTextField('Item', itemController, Icons.grass_rounded),
              ],
            ),
          ),

          const SizedBox(height: 20),

          
          SizedBox(
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                gradient: FarmColors.buttonGradient,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: FarmColors.primary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.agriculture_rounded, size: 20),
                label: Text('Predict Yield', style: GoogleFonts.nunito(fontWeight: FontWeight.w700, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () async {
                  if (!_validateYieldInputs()) return;
                  try {
                    var response = await http.post(
                      Uri.parse('$baseUrl/predict_yield'),
                      headers: {'Content-Type': 'application/json'},
                      body: jsonEncode({
                        'Year': int.parse(yearController.text),
                        'average_rain_fall_mm_per_year':
                            double.parse(rainfallController.text),
                        'pesticides_tonnes':
                            double.parse(pesticidesController.text),
                        'avg_temp': double.parse(tempController.text),
                        'Area': areaController.text,
                        'Item': itemController.text
                      }),
                    );
                    var jsonRes = jsonDecode(response.body);
                    setState(() {
                      yieldResult = jsonRes['predicted_yield']?.toDouble() ?? 0.0;
                    });
                  } catch (e) {
                    Fluttertoast.showToast(msg: 'Error: $e');
                  }
                },
              ),
            ),
          ),

          
          if (yieldResult > 0) ...[
            const SizedBox(height: 24),
            _buildResultCard(
              icon: Icons.emoji_nature_rounded,
              iconColor: FarmColors.accent,
              title: 'Predicted Yield',
              value: yieldResult.toStringAsFixed(2),
              isDark: isDark,
            ),
            const SizedBox(height: 8),
            Text(
              'The results may vary with real time',
              style: GoogleFonts.nunito(
                fontSize: 13,
                fontStyle: FontStyle.italic,
                color: isDark ? FarmColors.textSecondaryDark : FarmColors.textSecondary,
              ),
            ),
          ],

          const SizedBox(height: 30),
        ],
      ),
    );
  }

 

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: FarmColors.buttonGradient,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: isDark ? FarmColors.textPrimaryDark : FarmColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.nunito(
                  fontSize: 13,
                  color: isDark ? FarmColors.textSecondaryDark : FarmColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required bool isDark,
    required bool isPrimary,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 20),
      label: Text(label, style: GoogleFonts.nunito(fontWeight: FontWeight.w700)),
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary
            ? FarmColors.primary
            : (isDark ? FarmColors.cardDark : FarmColors.surfaceLight),
        foregroundColor: isPrimary
            ? Colors.white
            : (isDark ? FarmColors.textPrimaryDark : FarmColors.primary),
        elevation: isPrimary ? 2 : 0,
        side: isPrimary
            ? null
            : BorderSide(
                color: isDark
                    ? FarmColors.primaryLight.withValues(alpha: 0.3)
                    : FarmColors.primary.withValues(alpha: 0.3)),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onPressed,
    );
  }

  Widget _buildResultCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    String? value,
    required bool isDark,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? FarmColors.cardDark : FarmColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: iconColor.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: iconColor.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.nunito(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: isDark ? FarmColors.textPrimaryDark : FarmColors.textPrimary,
                  ),
                ),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      subtitle,
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        color: isDark ? FarmColors.textSecondaryDark : FarmColors.textSecondary,
                      ),
                    ),
                  ),
                if (value != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      value,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: iconColor,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberField(String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }

  bool _validateYieldInputs() {
    if (yearController.text.isEmpty ||
        rainfallController.text.isEmpty ||
        pesticidesController.text.isEmpty ||
        tempController.text.isEmpty ||
        areaController.text.isEmpty ||
        itemController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please fill all fields');
      return false;
    }
    return true;
  }
}
