import 'package:app/core/app_color.dart';
import 'package:app/core/app_font.dart';
import 'package:app/core/app_image.dart';
import 'package:app/data/repository/user_repository.dart';
import 'package:app/presentation/widgets/alert_home.dart';
import 'package:app/presentation/widgets/buttons/menu_button.dart';
import 'package:app/presentation/widgets/hello_name.dart';
import 'package:app/presentation/widgets/textfields/search_bar_custom.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  
  String _searchQuery = ""; 
  String? _name;

  final List<Map<String, dynamic>> _menus = [
    {'label': 'Diabetes', 'icon': Icons.bloodtype, 'path': '/chat'},
    {'label': 'Obesitas', 'icon': Icons.monitor_weight, 'path': '/chat'},
    {'label': 'Jantung', 'icon': Icons.favorite_rounded, 'path': '/chat'},
    {'label': 'Stress', 'icon': Icons.sentiment_very_dissatisfied, 'path': '/chat'}, 
    {'label': 'Calc BMI', 'icon': Icons.calculate, 'path': '/calc_bmi'},
    {'label': 'About Us', 'icon': Icons.info, 'path': '/about'},
  ];

  void getName() async {
    final userRepository = UserRepository();
    final String? result = await userRepository.getName();
    if (mounted) {
      setState(() {
        _name = result;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(_onSearchChanged);
    getName();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchCtrl.text;
    });
  }

  @override
  void dispose() {
    _searchCtrl.removeListener(_onSearchChanged);
    _searchCtrl.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> filteredMenus = _menus.where((menu) {
      final menuLabel = menu['label'].toString().toLowerCase();
      final searchLower = _searchQuery.toLowerCase();
      return menuLabel.contains(searchLower);
    }).toList();

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: AppColor.foreign, // Warna fallback jika gambar gagal dimuat
        image: DecorationImage(
          image: AssetImage(AppImage.backGround), // 👈 Aset gambar latar belakangmu
          fit: BoxFit.cover, // 👈 Memastikan gambar memenuhi seluruh layar dengan rapi
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,        
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(AppImage.logo, height: 35, width: 35,),
                const SizedBox(height: 30),
                HelloName(name: _name ?? 'Guest'),
                const SizedBox(height: 30),
                
                SearchBarCustom(controller: _searchCtrl),
                
                const SizedBox(height: 30),
                const AlertHome(),
                const SizedBox(height: 30),
                const Text(
                  'What do you need?',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: AppFont.nunito,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 15),
                
                filteredMenus.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40.0),
                          child: Column(
                            children: [
                              Icon(Icons.search_off_rounded, size: 48, color: Colors.grey[400]),
                              const SizedBox(height: 12),
                              Text(
                                'Menu "$_searchQuery" tidak ditemukan',
                                style: TextStyle(
                                  fontFamily: AppFont.inter,
                                  color: Colors.grey[500],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 120.0, 
                          crossAxisSpacing: 12.0,
                          mainAxisSpacing: 12.0,
                          childAspectRatio: 0.75, 
                        ),
                        itemCount: filteredMenus.length,
                        itemBuilder: (BuildContext context, int index) {
                          bool active = (index + 1) % 4 == 1 ? true : false;
                          final item = filteredMenus[index];
                          
                          return MenuButton(
                            label: item['label'],
                            icon: item['icon'],
                            location: item['path'],
                            isActive: active,
                            extraData: item['path'] != '/chat'
                                ? null 
                                : {
                                    'title': item['label'], 
                                    'category': item['label'].toString().toLowerCase()
                                  },
                          );
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}