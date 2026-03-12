import 'package:cpy_app/data/models/poem_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../utils/colors/light_colors.dart';
import '../../../../utils/dimensions/fontsizes.dart';
import '../../../../utils/globals.dart';
import '../providers/admin_hymn_book_provider.dart';

class PoemDetailPage extends StatefulWidget {
  const PoemDetailPage({
    super.key,
    required this.id,
    required this.title,
  });

  final int id;
  final String title;

  @override
  State<PoemDetailPage> createState() => _PoemDetailPageState();
}

class _PoemDetailPageState extends State<PoemDetailPage> {


  late final AdminHymnBookProvider _provider;

  final List<String> _fontFamilies = [
    'Roboto',
    'Poppins',
    'Courier New',
    'Georgia',
    'Times New Roman',
  ];

  @override
  void initState() {
    super.initState();
    _provider = context.read<AdminHymnBookProvider>();
    _initializeData();
  }

  void _initializeData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider.getPoemById(id: widget.id);
      _loadSettings();
    });
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      fontSizeGlobal = prefs.getDouble('fontSizeGlobal') ?? 1.0;
      fontFamilyGlobal = prefs.getString('fontFamilyGlobal') ?? 'Roboto';
      textOpacityGlobal = prefs.getDouble('textOpacityGlobal') ?? 1.0;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSizeGlobal', fontSizeGlobal);
    await prefs.setString('fontFamilyGlobal', fontFamilyGlobal);
    await prefs.setDouble('textOpacityGlobal', textOpacityGlobal);
  }

  void _updateFontSize(double value) {
    setState(() => fontSizeGlobal = value);
    _saveSettings();
  }

  void _updateTextOpacity(double value) {
    setState(() => textOpacityGlobal = value);
    _saveSettings();
  }

  void _updateFontFamily(String? value) {
    if (value != null) {
      setState(() => fontFamilyGlobal = value);
      _saveSettings();
    }
  }

  void _showFontSettingsDialog() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _FontSettingsBottomSheet(
        fontFamilies: _fontFamilies,
        onFontSizeChanged: _updateFontSize,
        onTextOpacityChanged: _updateTextOpacity,
        onFontFamilyChanged: _updateFontFamily,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        title: Text(widget.title),
        actions: [

          IconButton(
            onPressed: _showFontSettingsDialog,
            icon: const Icon(Icons.font_download_outlined, size: 20),
          ),


        ],
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Consumer<AdminHymnBookProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.error != null) {
          return Center(
            child: Text(
              provider.error!,
              style: TextStyle(
                fontSize: FontSizes().font17(context.screenSize),
                color: Colors.red,
              ),
            ),
          );
        }

        if (provider.poem == null) {
          return const Center(child: Text('Aucun poème trouvé'));
        }

        return _PoemContent(poem: provider.poem!);
      },
    );
  }
}

class _PoemContent extends StatelessWidget {
  final PoemModel poem;

  const _PoemContent({required this.poem});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: appPadding.padH16(MediaQuery.of(context).size),
        vertical: appPadding.padV15(MediaQuery.of(context).size),
      ),
      child: SingleChildScrollView(
        child: Text(
          poem.paroles,
          style: TextStyle(
            fontFamily: fontFamilyGlobal,
            fontSize: FontSizes().fontReading(MediaQuery.of(context).size),
            letterSpacing: 1.2,
            color: black.withOpacity(textOpacityGlobal),
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }
}

class _FontSettingsBottomSheet extends StatefulWidget {
  final List<String> fontFamilies;
  final ValueChanged<double> onFontSizeChanged;
  final ValueChanged<double> onTextOpacityChanged;
  final ValueChanged<String?> onFontFamilyChanged;

  const _FontSettingsBottomSheet({
    required this.fontFamilies,
    required this.onFontSizeChanged,
    required this.onTextOpacityChanged,
    required this.onFontFamilyChanged,
  });

  @override
  State<_FontSettingsBottomSheet> createState() => _FontSettingsBottomSheetState();
}

class _FontSettingsBottomSheetState extends State<_FontSettingsBottomSheet> {
  late double _currentFontSize;
  late double _currentTextOpacity;
  late String _currentFontFamily;

  @override
  void initState() {
    super.initState();
    _currentFontSize = fontSizeGlobal;
    _currentTextOpacity = textOpacityGlobal;
    _currentFontFamily = fontFamilyGlobal;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      minChildSize: 0.3,
      maxChildSize: 1,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 50),
              _buildFontSizeSlider(),
              const SizedBox(height: 25),
              _buildTextOpacitySlider(),
              const SizedBox(height: 25),
              _buildFontFamilyDropdown(),
              const SizedBox(height: 25),
              _buildPreviewText(),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Paramètres de police",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              fontSize: FontSizes().font20(MediaQuery.of(context).size),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }

  Widget _buildFontSizeSlider() {
    return _SettingSection(
      title: "Ajuster la taille de la police",
      child: Slider(
        min: 0.5,
        max: 5.0,
        value: _currentFontSize,
        activeColor: primarySoft,
        label: _currentFontSize.toStringAsFixed(2),
        onChanged: (value) {
          setState(() => _currentFontSize = value);
          widget.onFontSizeChanged(value);
        },
      ),
    );
  }

  Widget _buildTextOpacitySlider() {
    return _SettingSection(
      title: "Opacité du texte",
      child: Slider(
        activeColor: primarySoft,
        min: 0.0,
        max: 1.0,
        divisions: 10,
        value: _currentTextOpacity,
        label: _currentTextOpacity.toStringAsFixed(1),
        onChanged: (value) {
          setState(() => _currentTextOpacity = value);
          widget.onTextOpacityChanged(value);
        },
      ),
    );
  }

  Widget _buildFontFamilyDropdown() {
    return _SettingSection(
      title: "Famille de polices",
      child: DropdownButton<String>(
        dropdownColor: Colors.white,
        value: _currentFontFamily,
        isExpanded: true,
        items: widget.fontFamilies.map((font) {
          return DropdownMenuItem(
            value: font,
            child: Text(
              font,
              style: TextStyle(fontFamily: font),
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() => _currentFontFamily = value!);
          widget.onFontFamilyChanged(value);
        },
      ),
    );
  }

  Widget _buildPreviewText() {
    return const _SettingSection(
      title: "Aperçu",
      child: Padding(
        padding: EdgeInsets.zero,
        child: Text(
          "Que tout ce qui respire loue Yah ! Allélou-Yah !",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w300,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class _SettingSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _SettingSection({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
              fontSize: FontSizes().font17(MediaQuery.of(context).size),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: child,
        ),
      ],
    );
  }
}